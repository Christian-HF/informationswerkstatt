import React from "react";

/**
 * Sidebar-Komponente für die HF-Informationswerkstatt.
 * Verwaltet die Navigation zwischen den Hauptansichten und zeigt
 * Branding sowie Umgebungshinweise an.
 */
export default function SidebarComponent({ open, view, setView }) {
  // Lokale Sub-Komponente für Links, um Redundanz zu vermeiden
  const Link = ({ id, label, emoji }) => (
    <a
      href="#"
      className={view === id ? "active" : ""}
      onClick={(e) => {
        e.preventDefault();
        setView(id);
      }}
      style={{ display: "block" }}
    >
      <span style={{ marginRight: 8 }}>{emoji}</span>
      {label}
    </a>
  );

  return (
    <aside className={`sidebar ${open ? "open" : ""}`}>
      <div className="brand">HF‑Informationswerkstatt</div>
      <nav className="nav" style={{ display: "grid", gap: 6 }}>
        <Link id="documents" label="Dokumente" emoji="📄" />
        <Link id="upload" label="Upload" emoji="⬆️" />
        <Link id="agent" label="Agent (Q&A)" emoji="🤖" />
        <Link id="settings" label="Einstellungen" emoji="⚙️" />
      </nav>
      <div className="footer" style={{ marginTop: "auto", opacity: 0.7, fontSize: 12 }}>
        <span className="badge">rg_informationswerkstatt</span>
        <div>
          <span className="badge">dev</span>
        </div>
      </div>
    </aside>
  );
}
