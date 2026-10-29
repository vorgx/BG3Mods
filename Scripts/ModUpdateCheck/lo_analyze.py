"""Check the current BG3 load order and build a recommended one that moves as few mods as possible."""
import heapq, json, os, re, sys
from collections import defaultdict
from datetime import datetime, timezone

sys.stdout.reconfigure(encoding="utf-8")
HERE = os.path.dirname(os.path.abspath(__file__))
S = os.environ.get("BG3MC_WORK") or os.path.join(HERE, "work")  # caches and intermediate JSON
CONF = os.path.join(HERE, "config")  # hand-checked matches and rules
lo = json.load(open(os.path.join(S, "lo_data.json"), encoding="utf-8"))
upd = {m["pak"]: m for m in json.load(open(os.path.join(S, "report.json"), encoding="utf-8"))["mods"]}
notes = json.load(open(os.path.join(S, "lo_notes.json"), encoding="utf-8"))

BUILTIN = re.compile(r"^(Gustav|GustavDev|GustavX|Shared|SharedDev|Honour|HonourX|MainUI|ModBrowser|PhotoMode|CrossplayUI|Engine|Game|DiceSet_\d+)$", re.I)
# files inside the base game's own module folders: they replace game files directly
OVERRIDE = re.compile(r"^(Public|Mods|Generated/Public)/(Game|Shared|SharedDev|Gustav|GustavDev|GustavX|Honour|HonourX|Engine|MainUI|"
                      r"ModBrowser|PhotoMode|CrossplayUI|DiceSet_\d+)/", re.I)
PATCHY = re.compile(r"patch|compat|\bfix|addon|add-on|add on|submod|integration|_eotb|eotb\b|tweak", re.I)
TOP = [  # framework mods whose own pages say to load them first, in this order
    ("communitylibrary", "Community Library: Druid Wild Shape Overhaul's page says it goes at the top"),
    ("impui", "ImpUI: UI framework other UI mods build on, conventionally first"),
    ("mod configuration menu", "Mod Configuration Menu: its page says 'drag it to the top of your load order'"),
    ("volitioncabinet", "Volition Cabinet: library mod; Goon's Library page says libraries load near the top"),
]
BOTTOM = [("compatibilityframework", "Compatibility Framework: its page says 'Move CompatibilityFramework to bottom of load order'")]


def stem(s):
    s = re.sub(r"\.pak$", "", s or "", flags=re.I)
    s = re.sub(r"[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}", "", s, flags=re.I)
    return re.sub(r"[^a-z0-9]", "", s.lower())


paks = {p["pak"]: p for p in lo["paks"]}
by_uuid = defaultdict(list)
for p in lo["paks"]:
    if p.get("uuid"):
        by_uuid[p["uuid"]].append(p["pak"])

order = lo["order"]
issues = []


def issue(sev, kind, text, mods=()):
    issues.append({"sev": sev, "kind": kind, "text": text, "mods": list(mods)})


# --- current order -> paks
active = []          # pak names in current load order
builtins = []        # order entries that are part of the game
pos = {}
for i, o in enumerate(order):
    hits = by_uuid.get(o["uuid"], [])
    if hits:
        pk = hits[0]
        pos[pk] = len(active)
        active.append(pk)
    elif BUILTIN.match(o.get("name") or "") or BUILTIN.match(o.get("folder") or ""):
        builtins.append(o)
    else:
        issue("high", "missing", f"'{o.get('name')}' is in the load order but its pak isn't in the Mods folder. The game will skip it, "
              "and any mod that needs it may not load.", [o.get("name")])

for u, lst in by_uuid.items():
    if len(lst) > 1:
        issue("high", "duplicate", f"{len(lst)} paks share one mod UUID ({paks[lst[0]].get('name')}). The game loads only one of them, "
              "usually an old copy left behind after an update. Delete the outdated pak.", lst)

for p in lo["paks"]:
    if p.get("error"):
        issue("high", "corrupt", f"{p['pak']} couldn't be read ({p['error'].split(':')[0]}). The file may be damaged or "
              "half-downloaded. Re-download it.", [p["pak"]])
    elif not p.get("uuid"):
        issue("info", "nometa", f"{p['pak']} has no meta.lsx. It's a loose override pak that loads automatically, "
              "outside the load order.", [p["pak"]])
    elif p["pak"] not in pos and by_uuid[p["uuid"]][0] == p["pak"]:
        # the game mounts every pak in the Mods folder, so files that replace base-game files apply even when the
        # mod isn't in the load order (BG3 Mod Manager lists such paks under "Overrides")
        content = [f for f in p["files"] if not f.lower().endswith("meta.lsx") and not f.startswith("Localization/")]
        over = [f for f in content if OVERRIDE.match(f)]
        if content and len(over) == len(content):
            issue("info", "override", f"{p.get('name')} is an override pak: all {len(over)} of its files replace base-game files "
                  f"(e.g. {over[0]}), so the game uses it whether or not it's in the load order. "
                  "BG3 Mod Manager lists it under Overrides.", [p["pak"]])
        elif over:
            some = "1 of its files replaces a base-game file" if len(over) == 1 else f"{len(over)} of its files replace base-game files"
            issue("medium", "partial-override", f"{p.get('name')} is out of the load order, but {some} "
                  f"({over[0]}{', …' if len(over) > 1 else ''}) that still applies. To switch it off completely, move the pak "
                  "out of the Mods folder.", [p["pak"]])
        else:
            issue("low", "inactive", f"{p.get('name')} is installed but not in the load order, so it isn't active.", [p["pak"]])

# --- constraints: (before, after, reason, hard)
edges = []


def add_edge(a, b, reason, hard):
    if a != b and a in pos and b in pos:
        edges.append((a, b, reason, hard))


name_of = {pk: paks[pk].get("name") or pk for pk in paks}
for pk in active:
    p = paks[pk]
    for d in p["deps"]:
        if BUILTIN.match(d.get("name") or "") or BUILTIN.match(d.get("folder") or ""):
            continue
        hit = by_uuid.get(d["uuid"])
        if not hit:
            issue("high", "missing-dep", f"{name_of[pk]} requires '{d.get('name')}', which isn't installed.", [pk])
        elif hit[0] not in pos:
            issue("high", "disabled-dep", f"{name_of[pk]} requires '{name_of[hit[0]]}', which is installed but not in the load order.", [pk, hit[0]])
        else:
            add_edge(hit[0], pk, f"{name_of[pk]} lists {name_of[hit[0]]} as a dependency", True)
    for c in p["conflicts"]:
        hit = by_uuid.get(c["uuid"])
        if hit and hit[0] in pos:
            issue("high", "conflict", f"{name_of[pk]} declares a conflict with {name_of[hit[0]]}, and both are active.", [pk, hit[0]])

# author-stated incompatibilities, checked by hand against the installed files
for inc in json.load(open(os.path.join(CONF, "incompat_verified.json"), encoding="utf-8")):
    if inc["a"] in pos and inc["b"] in pos:
        issue("high", "incompatible", inc["text"], [inc["a"], inc["b"]])

pull_pos = {}  # pak -> position it should be pulled up to (manual rules with "pull")
# the local loot merge patch declares no dependencies (the game rejected them), so keep it after its sources here
_sources = os.path.join(S, "lootpatch", "sources.json")
if os.path.exists(_sources):
    for src_pak in json.load(open(_sources, encoding="utf-8")):
        add_edge(src_pak, "ModCheck_LootMerge.pak", "the ModCheck Loot Merge patch rebuilds loot tables from this mod and must load after it", True)
# rules checked by hand (spellset overrides etc.)
for rule in json.load(open(os.path.join(CONF, "manual_rules.json"), encoding="utf-8")):
    if not rule.get("skip"):
        add_edge(rule["before"], rule["after"], rule["reason"], True)
        if rule.get("pull") and rule["before"] in pos and rule["after"] in pos:
            # move the small "before" mod up to just above "after", instead of pushing "after" (and its patches) down
            pull_pos[rule["before"]] = pos[rule["after"]] - 0.5
# mods the update check marked obsolete
for pk in active:
    if upd.get(pk, {}).get("status") == "obsolete":
        issue("high", "obsolete", upd[pk].get("manual_note") or f"{name_of[pk]} is obsolete.", [pk])

# patches / add-ons load after the mod they patch
nexus_page = {pk: next((s["id"] for s in upd.get(pk, {}).get("sources", []) if s["source"] == "nexus"), None) for pk in active}
page_paks = defaultdict(list)
for pk, nid in nexus_page.items():
    if nid:
        page_paks[nid].append(pk)
stems = {pk: stem(pk) for pk in active}
alias = {"eotb": [pk for pk in active if re.search(r"eyes ?of ?the ?beholder", name_of[pk] or "", re.I) or stems[pk].startswith("eyesofthebeholder")]}
first_def = {}
for pk in active:
    for e in paks[pk]["stats"]:
        first_def.setdefault(e, pk)

for pk in active:
    label = f"{pk} {name_of[pk]}"
    if not PATCHY.search(label):
        continue
    parents = set()
    nid = nexus_page.get(pk)
    if nid and len(page_paks[nid]) > 1:
        # the page's main pak is its largest non-patch pak; other options on the page don't constrain order
        mains = [q for q in page_paks[nid] if q != pk and not PATCHY.search(f"{q} {name_of[q]}")]
        if mains:
            main = max(mains, key=lambda q: sum(1 for _ in paks[q]["files"]))
            parents.add((main, "same Nexus page, and this pak looks like its add-on or patch"))
    st = stems[pk]
    for q in active:
        sq = stems[q]
        if q != pk and len(sq) >= 6 and sq in st and sq != st:
            parents.add((q, f"its name contains '{q[:-4]}'"))
    for tok, targets in alias.items():
        if re.search(rf"(^|[^a-z]){tok}([^a-z]|$)", label, re.I):
            parents |= {(q, "it's an Eyes of the Beholder patch") for q in targets if q != pk}
    overridden = defaultdict(int)
    for e in paks[pk]["stats"]:
        q = first_def.get(e)
        if q and q != pk and pos[q] != pos[pk]:
            overridden[q] += 1
    for q, n in overridden.items():
        if n >= 3 and pos[q] < pos[pk] + 10 ** 6:  # any position: a patch should win over what it patches
            parents.add((q, f"it overrides {n} stat entries from it"))
    for q, why in parents:
        add_edge(q, pk, f"{name_of[pk]} is a patch or add-on for {name_of[q]} ({why})", False)

# --- tiers
tier = {pk: 2 for pk in active}
pin_reason = {}
for i, (key, why) in enumerate(TOP):
    for pk in active:
        if key in stems[pk] or key in (name_of[pk] or "").lower().replace(" ", "") or key in (name_of[pk] or "").lower():
            tier[pk] = min(tier[pk], 1)
            pin_reason[pk] = why
for key, why in BOTTOM:
    for pk in active:
        if key in stems[pk]:
            tier[pk] = 3
            pin_reason[pk] = why
# a dependency must never sit below its dependent, so it inherits the dependent's tier
changed = True
while changed:
    changed = False
    for a, b, _, _ in edges:
        if tier[a] > tier[b]:
            tier[a] = tier[b]
            changed = True
top_rank = {pk: i for i, (key, _) in enumerate(TOP) for pk in active if pk in pin_reason and pin_reason[pk] == TOP[i][1]}


def topo(edge_list):
    succ, indeg = defaultdict(list), {pk: 0 for pk in active}
    for a, b, _, _ in edge_list:
        succ[a].append(b)
        indeg[b] += 1
    key = lambda pk: (tier[pk], top_rank.get(pk, 99), pull_pos.get(pk, pos[pk]))
    heap = [(key(pk), pk) for pk in active if indeg[pk] == 0]
    heapq.heapify(heap)
    out = []
    while heap:
        _, pk = heapq.heappop(heap)
        out.append(pk)
        for b in succ[pk]:
            indeg[b] -= 1
            if indeg[b] == 0:
                heapq.heappush(heap, (key(b), b))
    return out if len(out) == len(active) else None


# drop soft edges that would contradict hard ones (cycles)
edge_set = list({(a, b): (a, b, r, h) for a, b, r, h in edges}.values())
rec = topo(edge_set)
if rec is None:
    hard = [e for e in edge_set if e[3]]
    soft = [e for e in edge_set if not e[3]]
    kept = list(hard)
    for e in soft:
        if topo(kept + [e]) is not None:
            kept.append(e)
    edge_set = kept
    rec = topo(edge_set) or active[:]
newpos = {pk: i for i, pk in enumerate(rec)}

# violations in the current order
violations = []
for a, b, reason, hard in edge_set:
    if pos[a] > pos[b]:
        violations.append({"before": a, "after": b, "reason": reason, "hard": hard})
        issue("high" if hard else "medium", "order",
              f"{name_of[b]} loads before {name_of[a]}, but it should load after it: {reason}.", [a, b])
for pk, why in pin_reason.items():
    t = tier[pk]
    if t == 1 and pos[pk] > 15:
        issue("medium", "placement", f"{name_of[pk]} is at position {pos[pk] + 1}. {why}.", [pk])
    if t == 3 and pos[pk] != len(active) - 1:
        issue("medium", "placement", f"{name_of[pk]} is at position {pos[pk] + 1} of {len(active)}. {why}.", [pk])

# minimal set of "moved" mods: those outside the longest increasing run of old positions
seq = [pos[pk] for pk in rec]
import bisect
tails, idx, prev = [], [], [-1] * len(seq)
for i, v in enumerate(seq):
    j = bisect.bisect_left([seq[t] for t in tails], v)
    if j > 0:
        prev[i] = tails[j - 1]
    if j == len(tails):
        tails.append(i)
    else:
        tails[j] = i
keep, k = set(), tails[-1] if tails else -1
while k != -1:
    keep.add(rec[k])
    k = prev[k]
moved = [pk for pk in rec if pk not in keep]
move_reason = {}
for v in violations:
    for pk in (v["before"], v["after"]):
        move_reason.setdefault(pk, v["reason"])
for pk in moved:
    move_reason.setdefault(pk, pin_reason.get(pk, "moved so the mods around it can satisfy their order rules"))

# --- override conflicts between active mods (the later one wins)
related = {(a, b) for a, b, _, _ in edge_set} | {(b, a) for a, b, _, _ in edge_set}
stat_pairs = defaultdict(list)
definers = defaultdict(list)
for pk in active:
    for e in paks[pk]["stats"]:
        definers[e].append(pk)
for e, lst in definers.items():
    if len(lst) > 1:
        lst = sorted(lst, key=lambda x: newpos[x])
        winner = lst[-1]
        for loser in lst[:-1]:
            if (loser, winner) not in related:
                stat_pairs[(loser, winner)].append(e)
file_pairs = defaultdict(list)
owners = defaultdict(list)
for pk in active:
    folder = (paks[pk].get("folder") or "").lower()
    for f in paks[pk]["files"]:
        fl = f.lower()
        if fl.endswith("meta.lsx") or (folder and f"/{folder}/" in fl):
            continue
        owners[fl].append(pk)
for f, lst in owners.items():
    if len(lst) > 1:
        lst = sorted(lst, key=lambda x: newpos[x])
        for loser in lst[:-1]:
            if (loser, lst[-1]) not in related:
                file_pairs[(loser, lst[-1])].append(f)


def pairs(d):
    out = [{"loser": a, "winner": b, "count": len(v), "examples": sorted(v)[:6],
            "flips": (pos[a] > pos[b])} for (a, b), v in d.items()]
    return sorted(out, key=lambda x: -x["count"])


# author notes for installed mods
note_for = {}
for pk in active:
    nid = nexus_page.get(pk)
    if nid and str(nid) in notes:
        note_for[pk] = notes[str(nid)]["notes"]

se_mods = [pk for pk in active if paks[pk]["se"]]
mod_row = lambda pk: {"pak": pk, "name": name_of[pk], "uuid": paks[pk].get("uuid"), "cur": pos[pk] + 1,
                      "rec": newpos[pk] + 1, "tier": tier[pk], "se": paks[pk]["se"],
                      "moved": pk in moved, "why": move_reason.get(pk) if pk in moved else None,
                      "deps": [name_of[a] for a, b, _, h in edge_set if b == pk and h],
                      "after": [name_of[a] for a, b, _, h in edge_set if b == pk and not h],
                      "notes": note_for.get(pk, []), "status": upd.get(pk, {}).get("status")}
result = {
    "generated": datetime.now(timezone.utc).isoformat(),
    "builtins": [b.get("name") for b in builtins],
    "current": [mod_row(pk) for pk in active],
    "recommended": [mod_row(pk) for pk in rec],
    "moved": len(moved),
    "issues": sorted(issues, key=lambda x: {"high": 0, "medium": 1, "low": 2, "info": 3}[x["sev"]]),
    "stat_conflicts": pairs(stat_pairs)[:150], "stat_conflict_pairs": len(stat_pairs),
    "file_conflicts": pairs(file_pairs)[:150], "file_conflict_pairs": len(file_pairs),
    "se_count": len(se_mods),
    "edges": len(edge_set), "hard_edges": sum(1 for e in edge_set if e[3]),
}
json.dump(result, open(os.path.join(S, "lo_report.json"), "w", encoding="utf-8"), indent=1, ensure_ascii=False)

# BG3 Mod Manager order file (Import Order from File)
bg3mm = {"Order": [{"UUID": paks[pk]["uuid"], "Name": name_of[pk]} for pk in rec],
         "Name": "Recommended " + datetime.now().strftime("%Y-%m-%d"), "Description": "Generated by the BG3 mod update/load-order check"}
json.dump(bg3mm, open(os.path.join(S, "recommended_order.json"), "w", encoding="utf-8"), indent=2, ensure_ascii=False)

from collections import Counter
print("active", len(active), "builtins", [b.get("name") for b in builtins], "edges", len(edge_set), "hard", result["hard_edges"], "moved", len(moved))
print(Counter((i["sev"], i["kind"]) for i in issues))
for i in result["issues"]:
    if i["sev"] in ("high", "medium"):
        print(i["sev"][:3], i["kind"], "|", i["text"][:230])
print("stat pairs", len(stat_pairs), "file pairs", len(file_pairs))
for p in pairs(stat_pairs)[:12]:
    print("  S", p["count"], name_of[p["loser"]], "->", name_of[p["winner"]], p["examples"][:3])
for p in pairs(file_pairs)[:12]:
    print("  F", p["count"], name_of[p["loser"]], "->", name_of[p["winner"]], p["examples"][:2])
