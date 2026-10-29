"""Render report.json into a self-contained HTML page."""
import json, os, sys

HERE = os.path.dirname(os.path.abspath(__file__))
S = os.environ.get("BG3MC_WORK") or os.path.join(HERE, "work")  # caches and intermediate JSON
CONF = os.path.join(HERE, "config")  # hand-checked matches and rules
OUT = sys.argv[1]
rep = json.load(open(os.path.join(S, "report.json"), encoding="utf-8"))
KEEP = ("source", "id", "name", "url", "files_url", "picture", "latest_version", "latest_date", "latest_file", "status", "note", "verify")
mods = [{
    "pak": m["pak"], "name": m.get("name") or m["pak"], "author": m.get("author"), "version": m.get("version"),
    "mtime": m["mtime"], "enabled": m.get("enabled"), "status": m["status"], "match": m.get("match_note"), "manual": m.get("manual_note"),
    "shared": len(m.get("shared_with") or []), "src": [{k: s.get(k) for k in KEEP} for s in m["sources"]],
} for m in rep["mods"]]
lo = json.load(open(os.path.join(S, "lo_report.json"), encoding="utf-8"))
rec_pos = {m["pak"]: m["rec"] for m in lo["recommended"]}
names = {m["pak"]: m["name"] for m in lo["current"]}
lo_out = {
    "builtins": lo["builtins"], "moved": lo["moved"], "issues": lo["issues"], "se": lo["se_count"],
    "edges": lo["edges"], "hard": lo["hard_edges"],
    "mods": [{k: m[k] for k in ("pak", "name", "uuid", "cur", "rec", "se", "moved", "why", "deps", "after", "notes", "status")}
             for m in lo["recommended"]],
    "stat": [{**p, "loser": names[p["loser"]], "winner": names[p["winner"]]} for p in lo["stat_conflicts"]],
    "file": [{**p, "loser": names[p["loser"]], "winner": names[p["winner"]]} for p in lo["file_conflicts"]],
    "stat_pairs": lo["stat_conflict_pairs"], "file_pairs": lo["file_conflict_pairs"],
}
addons_path = os.path.join(S, "addons.json")
addons = json.load(open(addons_path, encoding="utf-8")) if os.path.exists(addons_path) else None
data = json.dumps({"generated": rep["generated"], "mods": mods, "lo": lo_out, "addons": addons},
                  ensure_ascii=False).replace("</", "<\\/")

HTML = r"""<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>BG3 Mod Updates</title>
<style>
:root{
  --bg:#f6f5f1; --panel:#ffffff; --ink:#1d1c19; --muted:#6b6860; --line:#e3e0d8; --hover:#faf9f6;
  --accent:#8a5a1f;
  --upd:#b3261e; --upd-bg:#fbe9e7; --chk:#8a5a00; --chk-bg:#fdf1d6; --lik:#6a5d00; --lik-bg:#f6f2cf;
  --cur:#2e6b3a; --cur-bg:#e4f2e6; --unk:#5f5f68; --unk-bg:#ececef;
  --nexus:#d98f40; --modio:#3b7bd4;
  color-scheme: light;
}
@media (prefers-color-scheme: dark){
  :root:not([data-theme="light"]){
    --bg:#151412; --panel:#1e1d1a; --ink:#ecebe6; --muted:#a19d93; --line:#33312c; --hover:#25241f;
    --accent:#e0a85a;
    --upd:#ff8a80; --upd-bg:#3a1d1a; --chk:#f2c46b; --chk-bg:#3a2e14; --lik:#e3d77a; --lik-bg:#33301a;
    --cur:#86d19a; --cur-bg:#17301d; --unk:#b5b5bd; --unk-bg:#2a2a2f;
    color-scheme: dark;
  }
}
:root[data-theme="dark"]{
  --bg:#151412; --panel:#1e1d1a; --ink:#ecebe6; --muted:#a19d93; --line:#33312c; --hover:#25241f;
  --accent:#e0a85a;
  --upd:#ff8a80; --upd-bg:#3a1d1a; --chk:#f2c46b; --chk-bg:#3a2e14; --lik:#e3d77a; --lik-bg:#33301a;
  --cur:#86d19a; --cur-bg:#17301d; --unk:#b5b5bd; --unk-bg:#2a2a2f;
  color-scheme: dark;
}
*{box-sizing:border-box}
body{margin:0;background:var(--bg);color:var(--ink);font:14px/1.45 system-ui,-apple-system,"Segoe UI",Roboto,sans-serif}
a{color:inherit}
.wrap{max-width:1240px;margin:0 auto;padding:28px 16px 64px}
header h1{font-size:26px;letter-spacing:-.01em;margin:0 0 4px}
header p{margin:0;color:var(--muted)}
.stats{display:grid;grid-template-columns:repeat(6,minmax(0,1fr));gap:10px;margin:22px 0 16px}
.stat{background:var(--panel);border:1px solid var(--line);border-radius:10px;padding:12px 14px;text-align:left;cursor:pointer;font:inherit;color:inherit}
.stat:hover{background:var(--hover)}
.stat[aria-pressed="true"]{outline:2px solid var(--accent);outline-offset:-1px}
.stat b{display:block;font-size:24px;font-variant-numeric:tabular-nums;line-height:1.1}
.stat span{color:var(--muted);font-size:12.5px}
.stat.upd b{color:var(--upd)} .stat.chk b{color:var(--chk)} .stat.lik b{color:var(--lik)} .stat.cur b{color:var(--cur)} .stat.unk b{color:var(--unk)}
.tools{display:flex;gap:10px;flex-wrap:wrap;align-items:center;margin-bottom:12px}
.tools input[type=search]{flex:1 1 260px;min-width:0;padding:9px 12px;border:1px solid var(--line);border-radius:8px;background:var(--panel);color:var(--ink);font:inherit}
.tools label{color:var(--muted);display:flex;gap:6px;align-items:center;font-size:13px}
button.btn{padding:8px 12px;border:1px solid var(--line);border-radius:8px;background:var(--panel);color:var(--ink);font:inherit;cursor:pointer}
button.btn:hover{background:var(--hover)}
.count{color:var(--muted);font-size:13px;margin:0 0 8px}
.list{background:var(--panel);border:1px solid var(--line);border-radius:12px;overflow:hidden}
.row{display:grid;grid-template-columns:52px minmax(0,2.4fr) minmax(0,1fr) minmax(0,1.5fr) 150px;gap:14px;padding:12px 14px;border-top:1px solid var(--line);align-items:start}
.row:first-child{border-top:0}
.row.head{background:var(--hover);color:var(--muted);font-size:12px;text-transform:uppercase;letter-spacing:.04em;padding:9px 14px;align-items:center}
.thumb{width:52px;height:40px;border-radius:6px;object-fit:cover;background:var(--line);display:block}
.thumb.blank{display:grid;place-items:center;color:var(--muted);font-size:11px}
.name{font-weight:600;overflow-wrap:anywhere}
.sub{color:var(--muted);font-size:12.5px;overflow-wrap:anywhere}
.ver{font-variant-numeric:tabular-nums;font-family:ui-monospace,SFMono-Regular,Consolas,monospace;font-size:13px}
.links{display:flex;flex-wrap:wrap;gap:6px;margin-top:6px}
.tag{display:inline-flex;align-items:center;gap:5px;font-size:12px;padding:2px 8px;border-radius:999px;border:1px solid var(--line);text-decoration:none;white-space:nowrap}
.tag:hover{background:var(--hover)}
.tag i{width:7px;height:7px;border-radius:50%;display:inline-block}
.tag.nexus i{background:var(--nexus)} .tag.modio i{background:var(--modio)}
.tag.off{color:var(--muted)}
.badge{display:inline-block;font-size:12px;font-weight:600;padding:3px 9px;border-radius:999px;white-space:nowrap}
.badge.update{color:var(--upd);background:var(--upd-bg)} .badge.check{color:var(--chk);background:var(--chk-bg)}
.badge.likely{color:var(--lik);background:var(--lik-bg)} .badge.current{color:var(--cur);background:var(--cur-bg)}
.badge.unknown,.badge.gone{color:var(--unk);background:var(--unk-bg)} .badge.obsolete{color:var(--upd);background:var(--upd-bg)}
.vtag{display:inline-block;font-size:11px;margin-left:6px;color:var(--cur)}
.manual{margin-top:6px;font-size:12.5px;color:var(--ink);background:var(--hover);border-radius:6px;padding:6px 8px}
.note{color:var(--muted);font-size:12.5px;margin-top:6px}
.lbl{display:none}
.empty{padding:40px;text-align:center;color:var(--muted)}
details.how{margin-top:28px;background:var(--panel);border:1px solid var(--line);border-radius:12px;padding:14px 18px}
details.how summary{cursor:pointer;font-weight:600}
details.how li{margin:6px 0;color:var(--muted)}
.theme{position:fixed;top:12px;right:12px}
.tabs{display:flex;gap:4px;border-bottom:1px solid var(--line);margin:20px 0 0}
.tabs button{font:inherit;font-weight:600;background:none;border:0;border-bottom:2px solid transparent;padding:10px 14px;color:var(--muted);cursor:pointer}
.tabs button[aria-selected="true"]{color:var(--ink);border-bottom-color:var(--accent)}
[hidden]{display:none!important}
h2{font-size:17px;margin:28px 0 10px}
.issues{display:grid;gap:8px}
.issue{background:var(--panel);border:1px solid var(--line);border-left-width:4px;border-radius:8px;padding:10px 14px}
.issue.high{border-left-color:var(--upd)} .issue.medium{border-left-color:var(--chk)} .issue.low{border-left-color:var(--unk)} .issue.info{border-left-color:var(--line)}
.issue .k{font-size:11.5px;text-transform:uppercase;letter-spacing:.05em;color:var(--muted);font-weight:600}
.okline{background:var(--cur-bg);color:var(--cur);border-radius:8px;padding:10px 14px;font-weight:600}
.lo-row{display:grid;grid-template-columns:54px 54px minmax(0,1fr) minmax(0,1.2fr);gap:12px;padding:8px 14px;border-top:1px solid var(--line);align-items:start}
.lo-row:first-child{border-top:0}
.lo-row.head{background:var(--hover);color:var(--muted);font-size:12px;text-transform:uppercase;letter-spacing:.04em}
.lo-row.mv{background:var(--chk-bg)}
.num{font-variant-numeric:tabular-nums;font-family:ui-monospace,SFMono-Regular,Consolas,monospace;font-size:13px}
.mini{font-size:11px;padding:1px 7px;border-radius:999px;border:1px solid var(--line);color:var(--muted);margin-left:6px;white-space:nowrap}
.cf{background:var(--panel);border:1px solid var(--line);border-radius:10px;margin-top:8px}
.cf summary{cursor:pointer;padding:10px 14px;font-weight:600}
.cf-row{padding:8px 14px;border-top:1px solid var(--line)}
.cf-row code{font-size:12px;color:var(--muted);overflow-wrap:anywhere}
.lo-tools{display:flex;gap:10px;flex-wrap:wrap;align-items:center;margin:10px 0}
@media (max-width:860px){
  .lo-row{grid-template-columns:40px 40px minmax(0,1fr)}
  .lo-row > .lo-notes{grid-column:3}
}
@media (max-width:860px){
  .stats{grid-template-columns:repeat(3,minmax(0,1fr))}
  .row.head{display:none}
  .row{grid-template-columns:44px minmax(0,1fr);gap:8px 12px}
  .thumb{width:44px;height:34px}
  .row > .c-inst,.row > .c-new,.row > .c-st{grid-column:2}
  .lbl{display:inline;color:var(--muted);font-size:12px;margin-right:6px}
  .theme{position:static;margin-bottom:10px}
}
</style>
</head>
<body>
<div class="wrap">
  <button class="btn theme" id="theme" type="button" aria-label="Toggle light or dark theme">Theme</button>
  <header>
    <h1>BG3 Mod Check</h1>
    <p id="meta"></p>
  </header>
  <nav class="tabs" role="tablist">
    <button role="tab" id="t-upd" aria-selected="true" data-tab="upd">Updates</button>
    <button role="tab" id="t-lo" aria-selected="false" data-tab="lo">Load order</button>
    <button role="tab" id="t-add" aria-selected="false" data-tab="add">Add-ons</button>
  </nav>
  <section id="tab-lo" hidden>
    <div class="stats" id="lo-stats"></div>
    <h2>Problems found</h2>
    <div class="issues" id="lo-issues"></div>
    <h2>Recommended changes</h2>
    <div id="lo-moves"></div>
    <div class="lo-tools">
      <button class="btn" id="lo-dl" type="button">Download recommended order for BG3 Mod Manager</button>
      <span class="sub">In BG3MM: File → Import Order from File, then Save and Export.</span>
    </div>
    <h2>Full load order</h2>
    <div class="lo-tools">
      <input type="search" id="lo-q" placeholder="Search load order" aria-label="Search load order" style="flex:1 1 260px;min-width:0;padding:9px 12px;border:1px solid var(--line);border-radius:8px;background:var(--panel);color:var(--ink);font:inherit">
      <label class="sub"><input type="checkbox" id="lo-notes-only"> Only mods with author load-order notes</label>
    </div>
    <div class="list" id="lo-list"></div>
    <h2>Overrides between mods</h2>
    <p class="sub">When two active mods define the same stat entry or ship the same file, the one lower in the load order wins. Most of these are intended (a rebalance over a base mod). Look over the big ones and check the winner is the mod you want.</p>
    <div id="lo-conf"></div>
    <details class="how">
      <summary>How the load order was checked</summary>
      <ul>
        <li>The current order is read from <code>PlayerProfiles/Public/modsettings.lsx</code>, the file the game uses. Mods lower in the list load later and win conflicts.</li>
        <li>Dependencies come from each pak's own <code>meta.lsx</code>. A dependency must be installed, active, and loaded above the mod that needs it.</li>
        <li>Patches and add-ons are expected to load below the mod they patch. These are detected by name, by sharing a Nexus page with the main mod, or by overriding its stat entries.</li>
        <li>Placement rules come from the mod authors' own Nexus pages. Community Library, ImpUI, Mod Configuration Menu and Volition Cabinet go at the top. Compatibility Framework goes at the bottom. For Eyes of the Beholder the order is head and race mods, then EotB and its patches, then eye presets.</li>
        <li>The recommended order changes as little as possible. It keeps your current order and moves only the mods that break one of these rules. PhotoMode and CrossplayUI dependencies are built into the game and are ignored.</li>
      </ul>
    </details>
  </section>
  <section id="tab-add" hidden>
    <p class="sub" style="margin-top:16px">Things your installed mods ask for or offer that you don't have. Requirements come from each mod's Nexus or mod.io page, with the author's own notes. Suggested patches are files that connect two mods you already run. Check each one before installing; the matching is automatic.</p>
    <h2>Missing requirements</h2>
    <div class="issues" id="add-req"></div>
    <h2>Suggested compatibility patches and add-ons</h2>
    <div class="issues" id="add-sug"></div>
    <h2>Other optional files on your mods' pages</h2>
    <div class="lo-tools"><input type="search" id="add-q" placeholder="Search optional files" aria-label="Search optional files" style="flex:1 1 260px;min-width:0;padding:9px 12px;border:1px solid var(--line);border-radius:8px;background:var(--panel);color:var(--ink);font:inherit"></div>
    <div class="list" id="add-opt"></div>
  </section>
  <section id="tab-upd">
  <div class="stats" id="stats"></div>
  <div class="tools">
    <input type="search" id="q" placeholder="Search mod, pak file or author" aria-label="Search mods">
    <label><input type="checkbox" id="onlyEnabled"> Only mods in my load order</label>
    <button class="btn" id="copy" type="button">Copy update list</button>
  </div>
  <p class="count" id="count"></p>
  <div class="list" id="list" role="table" aria-label="Installed mods"></div>
  <details class="how">
    <summary>How this was checked</summary>
    <ul>
      <li>Every <code>.pak</code> in the BG3 Mods folder was opened and its <code>meta.lsx</code> read for the mod's name, author, version and UUID.</li>
      <li>Each pak was matched to Nexus Mods and mod.io using BG3ModHelper's records: file IDs you downloaded, its Nexus pak database, and its mod.io links. Seven paks with no record were found by name or author search.</li>
      <li>Latest versions come live from the Nexus Mods API (mod details and file lists) and the mod.io API.</li>
      <li><b>Update available</b> means Nexus marks your exact file as replaced or moved to old versions, or the newest file's version number is higher and it was uploaded after your pak.</li>
      <li><b>Hash check:</b> Nexus publishes a manifest for each download, listing every file inside with its SHA1 hash, or only its rounded size for older uploads. Your installed paks were hashed and matched against the current downloads. '✓ hash checked' is an exact comparison, while '≈ size checked' compares rounded sizes only. This settles most of the cases that version numbers alone couldn't.</li>
      <li><b>No longer hosted</b> and <b>Obsolete</b> verdicts were checked by hand: removed mods and banned authors, and changelogs that retire a patch.</li>
      <li><b>Check manually</b> means the evidence conflicts: for example, Nexus shows a higher version, but your pak was installed after that upload.</li>
      <li><b>Possible update</b> means versions can't be compared and only the dates point to a newer file. This is common for add-on paks hosted on a bigger mod's page.</li>
      <li>A Nexus file uploaded within 3 days of your pak's date counts as the same release, because pak dates are usually build dates and many authors don't change the version inside the pak.</li>
    </ul>
  </details>
  </section>
</div>
<script id="data" type="application/json">__DATA__</script>
<script>
(function(){
  const D = JSON.parse(document.getElementById('data').textContent);
  const LABEL = {update:'Update available', obsolete:'Obsolete, remove', check:'Check manually', likely:'Possible update', gone:'No longer hosted', current:'Up to date', unknown:'Not found online'};
  const ORDER = {update:0, obsolete:1, check:2, likely:3, unknown:4, gone:5, current:6};
  const SRC = {nexus:'Nexus', modio:'mod.io'};
  const state = {filter:'attention', q:'', onlyEnabled:false};
  try { const t = localStorage.getItem('bg3upd-theme'); if (t) document.documentElement.dataset.theme = t; } catch(e) {}
  document.getElementById('theme').onclick = () => {
    const dark = document.documentElement.dataset.theme ? document.documentElement.dataset.theme === 'dark' : matchMedia('(prefers-color-scheme: dark)').matches;
    const next = dark ? 'light' : 'dark';
    document.documentElement.dataset.theme = next;
    try { localStorage.setItem('bg3upd-theme', next); } catch(e) {}
  };
  const esc = s => String(s ?? '').replace(/[&<>"']/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
  const day = t => t ? new Date(typeof t === 'number' ? t*1000 : t).toLocaleDateString(undefined,{year:'numeric',month:'short',day:'numeric'}) : '';
  const gen = new Date(D.generated);
  const mods = D.mods.slice().sort((a,b) => ORDER[a.status]-ORDER[b.status] || a.name.localeCompare(b.name));
  const cnt = s => mods.filter(m => s === 'all' ? true : s === 'attention' ? m.status !== 'current' : m.status === s).length;
  document.getElementById('meta').textContent =
    `${mods.length} paks scanned on ${gen.toLocaleString(undefined,{dateStyle:'medium',timeStyle:'short'})} · ` +
    `${mods.filter(m=>m.src.some(s=>s.source==='nexus')).length} on Nexus, ${mods.filter(m=>m.src.some(s=>s.source==='modio')).length} on mod.io`;
  const STATS = [['attention','Need attention','upd'],['update','Update available','upd'],['obsolete','Obsolete, remove','upd'],['check','Check manually','chk'],
                 ['likely','Possible update','lik'],['unknown','Not found online','unk'],['gone','No longer hosted, keep','unk'],['current','Up to date','cur']]
                 .filter(([k]) => ['attention','update','current'].includes(k) || cnt(k) > 0);
  const statsEl = document.getElementById('stats');
  statsEl.innerHTML = STATS.map(([k,l,c]) => `<button class="stat ${c}" data-f="${k}" aria-pressed="${k===state.filter}"><b>${cnt(k)}</b><span>${l}</span></button>`).join('');
  statsEl.onclick = e => {
    const b = e.target.closest('.stat'); if (!b) return;
    state.filter = state.filter === b.dataset.f ? 'all' : b.dataset.f;
    statsEl.querySelectorAll('.stat').forEach(x => x.setAttribute('aria-pressed', x.dataset.f === state.filter));
    render();
  };
  document.getElementById('q').oninput = e => { state.q = e.target.value.toLowerCase(); render(); };
  document.getElementById('onlyEnabled').onchange = e => { state.onlyEnabled = e.target.checked; render(); };

  function visible(){
    return mods.filter(m => {
      if (state.filter === 'attention' && m.status === 'current') return false;
      if (!['all','attention'].includes(state.filter) && m.status !== state.filter) return false;
      if (state.onlyEnabled && m.enabled === false) return false;
      if (state.q) {
        const hay = [m.name, m.pak, m.author, ...m.src.map(s => s.name)].join(' ').toLowerCase();
        if (!hay.includes(state.q)) return false;
      }
      return true;
    });
  }
  function lead(m){ // the source that drives the status
    return m.src.find(s => s.status === m.status) || m.src[0];
  }
  function vtag(m){
    const v = (m.src.find(s => s.verify) || {}).verify;
    if (v === 'identical' || v === 'differs' || v === 'outdated') return `<span class="vtag" title="Your pak's SHA1 was compared with the files inside the Nexus downloads">✓ hash checked</span>`;
    if (v === 'size-match' || v === 'size-differs') return `<span class="vtag" title="Older Nexus uploads list only rounded file sizes">≈ size checked</span>`;
    return '';
  }
  function row(m){
    const L = lead(m);
    const pic = (m.src.find(s => s.picture) || {}).picture;
    const thumb = pic ? `<img class="thumb" loading="lazy" alt="" src="${esc(pic)}">` : `<div class="thumb blank">pak</div>`;
    const links = m.src.map(s => `<a class="tag ${s.source}" href="${esc(s.files_url || s.url)}" target="_blank" rel="noopener"><i></i>${SRC[s.source]}${s.source==='nexus' ? ' #'+s.id : ''}</a>`).join('');
    const search = m.src.length ? '' :
      `<a class="tag off" href="https://www.nexusmods.com/games/baldursgate3/mods?keyword=${encodeURIComponent(m.name)}" target="_blank" rel="noopener">Search Nexus</a>` +
      `<a class="tag off" href="https://mod.io/g/baldursgate3?_q=${encodeURIComponent(m.name)}" target="_blank" rel="noopener">Search mod.io</a>`;
    const extra = [];
    if (m.enabled === false) extra.push('not in load order');
    if (m.shared) extra.push(`shares a Nexus page with ${m.shared} other pak${m.shared>1?'s':''}`);
    if (m.match && !m.manual) extra.push(m.match.toLowerCase());
    const others = m.src.filter(s => s !== L && s.latest_version);
    const latest = L && L.latest_version ? `<div class="ver">${esc(L.latest_version)}</div><div class="sub">${esc(SRC[L.source])} · ${day(L.latest_date)}</div>` +
       (L.latest_file ? `<div class="sub">${esc(L.latest_file)}</div>` : '') +
       others.map(s => `<div class="sub">${esc(SRC[s.source])}: <span class="ver">${esc(s.latest_version)}</span> · ${day(s.latest_date)}</div>`).join('')
      : `<div class="sub">—</div>`;
    const notes = m.src.filter(s => s.note && s.status !== 'current' || (s === L && s.note)).map(s => (m.src.length > 1 ? SRC[s.source] + ': ' : '') + s.note);
    return `<div class="row" role="row">
      ${thumb}
      <div role="cell"><div class="name">${esc(m.name)}</div>
        <div class="sub">${esc(m.pak)}${m.author ? ' · ' + esc(m.author) : ''}</div>
        <div class="links">${links}${search}</div>
        ${extra.length ? `<div class="note">${esc(extra.join(' · '))}</div>` : ''}</div>
      <div class="c-inst" role="cell"><span class="lbl">Installed</span><span class="ver">${esc(m.version || '?')}</span><div class="sub">${day(m.mtime)}</div></div>
      <div class="c-new" role="cell"><span class="lbl">Latest</span>${latest}</div>
      <div class="c-st" role="cell"><span class="badge ${m.status}">${LABEL[m.status]}</span>${vtag(m)}
        ${m.manual ? `<div class="manual">${esc(m.manual)}</div>` : notes.length ? `<div class="note">${esc(notes.join(' '))}</div>` : ''}</div>
    </div>`;
  }
  function render(){
    const v = visible();
    document.getElementById('count').textContent = `Showing ${v.length} of ${mods.length} paks`;
    const head = `<div class="row head" role="row"><span></span><span>Mod</span><span>Installed</span><span>Latest online</span><span>Status</span></div>`;
    document.getElementById('list').innerHTML = v.length ? head + v.map(row).join('') : `<div class="empty">No mods match.</div>`;
  }
  document.getElementById('copy').onclick = async e => {
    const lines = mods.filter(m => m.status === 'update').map(m => {
      const L = lead(m);
      return `${m.name}  ${m.version} -> ${L.latest_version}  ${L.files_url || L.url}`;
    });
    try { await navigator.clipboard.writeText(lines.join('\n')); e.target.textContent = `Copied ${lines.length}`; }
    catch(err) { e.target.textContent = 'Copy failed'; }
    setTimeout(() => e.target.textContent = 'Copy update list', 1800);
  };
  render();

  // ---- tabs
  const tabs = document.querySelectorAll('.tabs button');
  function showTab(t){
    tabs.forEach(b => b.setAttribute('aria-selected', b.dataset.tab === t));
    document.getElementById('tab-upd').hidden = t !== 'upd';
    document.getElementById('tab-lo').hidden = t !== 'lo';
    document.getElementById('tab-add').hidden = t !== 'add';
    try { localStorage.setItem('bg3upd-tab', t); } catch(e) {}
  }
  tabs.forEach(b => b.onclick = () => showTab(b.dataset.tab));
  try { const t = localStorage.getItem('bg3upd-tab'); if (t) showTab(t); } catch(e) {}

  // ---- add-ons
  const A = D.addons || {required: [], suggested: [], optional: []};
  const addRow = (r, sev) => `<div class="issue ${sev}"><div class="k">For ${esc(r.for.slice(0, 3).join(', '))}${r.for.length > 3 ? ' …' : ''}</div>
      <b>${r.url ? `<a href="${esc(r.url)}" target="_blank" rel="noopener">${esc(r.title)}</a>` : esc(r.title)}</b>
      <div class="sub">${esc(r.reason)}</div>${r.notes ? `<div class="note">“${esc(r.notes)}”</div>` : ''}</div>`;
  document.getElementById('add-req').innerHTML = A.required.length ? A.required.map(r => addRow(r, 'high')).join('') : '<div class="okline">Every requirement is installed.</div>';
  document.getElementById('add-sug').innerHTML = A.suggested.length ? A.suggested.map(r => addRow(r, 'medium')).join('') : '<div class="okline">No missing patches found.</div>';
  function renderOpt(q){
    const v = A.optional.filter(r => !q || (r.title + ' ' + r.for.join(' ') + ' ' + r.notes).toLowerCase().includes(q));
    document.getElementById('add-opt').innerHTML = v.slice(0, 400).map(r => `<div class="cf-row"><a href="${esc(r.url)}" target="_blank" rel="noopener"><b>${esc(r.title)}</b></a>
      <div class="sub">${esc(r.reason)}${r.notes ? ' · ' + esc(r.notes) : ''}</div></div>`).join('') || '<div class="cf-row sub">None.</div>';
  }
  document.getElementById('add-q').oninput = e => renderOpt(e.target.value.toLowerCase());
  renderOpt('');
  document.getElementById('t-add').textContent = `Add-ons (${A.required.length + A.suggested.length})`;

  // ---- load order
  const LO = D.lo;
  const issues = LO.issues;
  const sevCount = s => issues.filter(i => i.sev === s).length;
  const orderIssues = issues.filter(i => i.kind === 'order').length;
  document.getElementById('lo-stats').innerHTML = [
    [LO.mods.length, 'Active mods', ''],
    ...(() => { const bad = issues.filter(i => i.kind === 'order' && i.sev === 'high').length;
       return [[LO.hard, bad ? `Dependency rules, ${bad} broken` : 'Dependency rules, all met', bad ? 'upd' : 'cur']]; })(),
    [sevCount('high'), 'Serious problems', 'upd'], [orderIssues, 'Order problems', 'chk'],
    [LO.moved, 'Mods to move', 'lik'], [LO.se, 'Use Script Extender', '']
  ].map(([n,l,c]) => `<div class="stat ${c}" style="cursor:default"><b>${n}</b><span>${l}</span></div>`).join('');
  const KIND = {missing:'Missing pak', duplicate:'Duplicate', corrupt:'Unreadable pak', 'missing-dep':'Missing dependency',
    'disabled-dep':'Inactive dependency', obsolete:'Obsolete mod', conflict:'Declared conflict', incompatible:'Incompatible mods', order:'Wrong order',
    placement:'Placement', inactive:'Not active', nometa:'Loose pak', override:'Override pak (always active)', 'partial-override':'Partly still active'};
  const SEV = {high:'Fix this', medium:'Should fix', low:'FYI', info:'FYI'};
  document.getElementById('lo-issues').innerHTML = issues.length ? issues.map(i =>
    `<div class="issue ${i.sev}"><div class="k">${SEV[i.sev]} · ${esc(KIND[i.kind] || i.kind)}</div>${esc(i.text)}</div>`).join('')
    : `<div class="okline">No problems found.</div>`;
  const moved = LO.mods.filter(m => m.moved);
  document.getElementById('lo-moves').innerHTML = moved.length ? `<div class="list">` + moved.map(m =>
    `<div class="cf-row"><b>${esc(m.name)}</b>: move from position <span class="num">${m.cur}</span> to <span class="num">${m.rec}</span>
      <div class="sub">${esc(m.why || '')}</div></div>`).join('') + `</div>`
    : `<div class="okline">Your current order already follows every rule. Nothing needs to move.</div>`;
  document.getElementById('lo-dl').onclick = () => {
    const order = {Order: LO.mods.map(m => ({UUID: m.uuid, Name: m.name})), Name: 'Recommended', Description: 'From the BG3 mod check report'};
    const a = document.createElement('a');
    a.href = URL.createObjectURL(new Blob([JSON.stringify(order, null, 2)], {type:'application/json'}));
    a.download = 'BG3_Recommended_Load_Order.json';
    a.click();
    setTimeout(() => URL.revokeObjectURL(a.href), 2000);
  };
  const loState = {q:'', notes:false};
  document.getElementById('lo-q').oninput = e => { loState.q = e.target.value.toLowerCase(); renderLO(); };
  document.getElementById('lo-notes-only').onchange = e => { loState.notes = e.target.checked; renderLO(); };
  function renderLO(){
    const v = LO.mods.filter(m => (!loState.notes || m.notes.length) &&
      (!loState.q || (m.name + ' ' + m.pak).toLowerCase().includes(loState.q)));
    const head = `<div class="lo-row head"><span>Now</span><span>Rec.</span><span>Mod</span><span class="lo-notes">Rules and author notes</span></div>`;
    const builtins = loState.q || loState.notes ? '' : LO.builtins.map(b => `<div class="lo-row"><span class="num">0</span><span class="num">0</span><span><b>${esc(b)}</b> <span class="mini">base game</span></span><span></span></div>`).join('');
    document.getElementById('lo-list').innerHTML = head + builtins + v.map(m => {
      const tags = [m.se ? '<span class="mini">Script Extender</span>' : '',
        m.status && m.status !== 'current' ? `<span class="mini" style="color:var(--${m.status==='update'?'upd':'chk'})">${esc(LABEL[m.status])}</span>` : '',
        m.moved ? '<span class="mini" style="color:var(--chk)">moved</span>' : ''].join('');
      const rules = [m.deps.length ? 'Needs: ' + m.deps.join(', ') : '', m.after.length ? 'Loads after: ' + m.after.join(', ') : ''].filter(Boolean);
      const notes = m.notes.length ? `<details><summary class="sub">Author's load-order notes (${m.notes.length})</summary>${m.notes.map(n => `<div class="sub">“${esc(n)}”</div>`).join('')}</details>` : '';
      return `<div class="lo-row${m.moved ? ' mv' : ''}"><span class="num">${m.cur}</span><span class="num">${m.rec}</span>
        <span><b>${esc(m.name)}</b>${tags}<div class="sub">${esc(m.pak)}</div></span>
        <span class="lo-notes">${rules.map(r => `<div class="sub">${esc(r)}</div>`).join('')}${notes}</span></div>`;
    }).join('');
  }
  renderLO();
  const conf = (list, total, what) => `<details class="cf"><summary>${total} pairs of mods override each other's ${what}${list.length < total ? ` (largest ${list.length} shown)` : ''}</summary>` +
    list.map(p => `<div class="cf-row"><b>${esc(p.winner)}</b> overrides <b>${esc(p.loser)}</b> on ${p.count} ${what}
      <div><code>${esc(p.examples.join(', '))}${p.count > p.examples.length ? ', …' : ''}</code></div></div>`).join('') + `</details>`;
  document.getElementById('lo-conf').innerHTML = conf(LO.stat, LO.stat_pairs, 'stat entries') + conf(LO.file, LO.file_pairs, 'files');
})();
</script>
</body>
</html>
"""
open(OUT, "w", encoding="utf-8").write(HTML.replace("__DATA__", data))
print("wrote", OUT, os.path.getsize(OUT))
