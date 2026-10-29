"""Find author-stated incompatibilities between installed mods (from Nexus descriptions)."""
import json, re, sys, html, os
sys.stdout.reconfigure(encoding="utf-8")
HERE = os.path.dirname(os.path.abspath(__file__))
S = os.environ.get("BG3MC_WORK") or os.path.join(HERE, "work")  # caches and intermediate JSON
CONF = os.path.join(HERE, "config")  # hand-checked matches and rules
c = json.load(open(os.path.join(S, "nexus_cache.json"), encoding="utf-8"))
lo = json.load(open(os.path.join(S, "lo_report.json"), encoding="utf-8"))
rep = {m["pak"]: m for m in json.load(open(os.path.join(S, "report.json"), encoding="utf-8"))["mods"]}
active = [m["pak"] for m in lo["current"]]
page = {pk: next((s for s in rep[pk]["sources"] if s["source"] == "nexus"), None) for pk in active}
pages = {}
for pk, s in page.items():
    if s:
        pages.setdefault(s["id"], []).append(pk)
INC = re.compile(r"\b(not|isn't|is not|aren't|are not|won't be|will not be|NOT)\s+(?:be\s+)?compatible with|\bincompatible with|\bconflicts? with|\bdo(?:es)? not work with|doesn't work with", re.I)
STOP = {"the", "and", "for", "mod", "mods", "with", "of", "by", "a", "an", "to", "in", "bg3", "baldur", "gate", "version", "patch", "all", "more", "new"}

def clean(d):
    t = re.sub(r"<br\s*/?>", "\n", d or "")
    t = re.sub(r"\[/?[a-z*]+(?:=[^\]]*)?\]", " ", t, flags=re.I)
    return re.sub(r"[ \t\u00a0\ufeff]+", " ", html.unescape(re.sub(r"<[^>]+>", " ", t)))

def toks(s):
    return [w[:5] for w in re.findall(r"[a-z0-9']+", s.lower().replace("'s", "")) if w not in STOP and len(w) > 2]

found = []
for nid, owners in pages.items():
    d = c.get(str(nid))
    if not d:
        continue
    for line in clean(d["mod"].get("description")).split("\n"):
        for sent in re.split(r"(?<=[.!?])\s+", line):
            if not INC.search(sent) or len(sent) > 400:
                continue
            st = set(toks(sent))
            for oid, others in pages.items():
                if oid == nid:
                    continue
                name = c[str(oid)]["mod"]["name"]
                nt = toks(re.sub(r"\(.*?\)|-.*$", "", name))
                if len(nt) >= 2 and all(t in st for t in nt):
                    found.append({"mod": owners[0], "other": others[0], "mod_name": d["mod"]["name"], "other_name": name, "sentence": sent.strip()})
json.dump(found, open(os.path.join(S, "lo_incompat.json"), "w", encoding="utf-8"), indent=1, ensure_ascii=False)
for f in found:
    print("==", f["mod_name"], "X", f["other_name"], "\n   ", f["sentence"][:300])
print(len(found))
