export default function Sidebar({ open, view, setView }) {
  const Link = ({ id, label, emoji }) => (
    <a
      href="#"
      className={`nav-link ${view === id ? "active" : ""}`}
      onClick={(e) => { e.preventDefault(); setView(id); }}
      style={{ display:"block" }}
    >
      <span style={{ marginRight:8 }}>{emoji}</span>{label}
    </a>
  );

  return (
    <aside className={`sidebar ${open ? "open" : ""}`}>
      <div className="brand">HF-Informationswerkstatt</div>
      <nav className="nav" style={{ display:"grid", gap:6 }}>
        <Link id="documents" label="Dokumente" emoji="📄" />
        <Link id="upload"    label="Upload"    emoji="⬆️" />
        <Link id="agent"     label="Agent (Q&A)" emoji="🤖" />
        <Link id="settings"  label="Einstellungen" emoji="⚙️" />
      </nav>
      <div style={{ marginTop:"auto", opacity:.75, fontSize:12 }}>
        <div>RG: <span className="badge">rg_informationswerkstatt</span></div>
        <div>Env: <span className="badge">dev</span></div>
      </div>
    </aside>
  );
}
