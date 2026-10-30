// Run a built report's own script against a minimal DOM stub and print what it rendered, as JSON.
//   node render_report.js <report.html> [filter]
// filter clicks a stats card first (e.g. "gone"); without it the page shows its default "Need attention" view.
const fs = require('fs'), vm = require('vm');
const html = fs.readFileSync(process.argv[2], 'utf8');
const data = html.match(/<script id="data" type="application\/json">([\s\S]*?)<\/script>/)[1];
const code = [...html.matchAll(/<script>([\s\S]*?)<\/script>/g)].map(m => m[1]).join('\n');

const els = {};
function el(id) {
  const e = {id, textContent: '', innerHTML: '', value: '', checked: false, dataset: {}, style: {}, attrs: {},
    setAttribute(k, v) { this.attrs[k] = String(v); }, getAttribute(k) { return this.attrs[k]; },
    classList: {add() {}, remove() {}, toggle() {}, contains() { return false; }},
    addEventListener() {}, querySelectorAll() { return []; }, querySelector() { return el('_q'); },
    closest() { return null; }, focus() {}, click() {}};
  if (id === 'data') e.textContent = data;
  return e;
}
const document = {
  getElementById: id => (els[id] = els[id] || el(id)),
  querySelectorAll: () => [], querySelector: () => el('_q'), documentElement: el('html'),
  createElement: () => el('_c'), body: el('body'), addEventListener() {},
};
const ctx = {document, window: {}, localStorage: {getItem: () => null, setItem() {}}, matchMedia: () => ({matches: false}),
  navigator: {clipboard: {writeText: async () => {}}}, URL, Blob: function () {}, setTimeout, console};
ctx.window = ctx;
vm.runInNewContext(code, ctx);

const filter = process.argv[3];
if (filter) {
  const stats = els.stats;
  stats.onclick({target: {closest: () => ({dataset: {f: filter}})}});
}
const title = (html.match(/<title>(.*?)<\/title>/) || [])[1];
console.log(JSON.stringify({title, stats: els.stats.innerHTML, list: els.list.innerHTML, count: els.count.textContent}));
