"""Pull author load-order instructions out of cached Nexus descriptions."""
import json, re, sys, html, os
sys.stdout.reconfigure(encoding="utf-8")
HERE = os.path.dirname(os.path.abspath(__file__))
S = os.environ.get("BG3MC_WORK") or os.path.join(HERE, "work")  # caches and intermediate JSON
CONF = os.path.join(HERE, "config")  # hand-checked matches and rules
c = json.load(open(os.path.join(S, "nexus_cache.json"), encoding="utf-8"))
SENT = re.compile(r"[^.!?\n]{0,220}[.!?]?")
KEY = re.compile(r"\b(load(?:ed|ing)?|placed?|put)\b[^.!?\n]{0,80}\b(after|before|below|above|under|over|last|first|top|bottom|end|beneath|underneath|higher|lower)\b"
                 r"|\b(top|bottom|end|beginning) of (?:your|the) (?:load ?order|mod ?list|list)\b"
                 r"|\bload ?order\b[^.!?\n]{0,40}\b(after|before|below|above|top|bottom)\b", re.I)
NOISE = re.compile(r"save (?:your |the )?load ?order|export|inactive mods|load your save|loading screen|reload|load a save|before (?:you )?(?:start|install|uninstall)|new game", re.I)
out = {}
for k, v in c.items():
    desc = v["mod"].get("description") or ""
    t = re.sub(r"<br\s*/?>", "\n", desc)
    t = re.sub(r"\[/?[a-z*]+(?:=[^\]]*)?\]", " ", t, flags=re.I)
    t = html.unescape(re.sub(r"<[^>]+>", " ", t))
    t = re.sub(r"[ \t\u00a0\ufeff]+", " ", t)
    hits = []
    for line in t.split("\n"):
        for s in re.split(r"(?<=[.!?])\s+", line):
            s = s.strip(" -*•\t")
            if 12 < len(s) < 300 and KEY.search(s) and not NOISE.search(s) and s not in hits:
                hits.append(s)
    if hits:
        out[k] = {"name": v["mod"]["name"], "notes": hits[:8]}
json.dump(out, open(os.path.join(S, "lo_notes.json"), "w", encoding="utf-8"), indent=1, ensure_ascii=False)
print(len(out), "mods with notes")
for k in out:
    if re.search(r"compatib|impui|configuration menu|unlock ?level|5e spells|combat extender|many more|volition|beholder|community lib|tav's hair|goon", out[k]["name"], re.I):
        print("==", k, out[k]["name"]); [print("   -", n[:220]) for n in out[k]["notes"]]
