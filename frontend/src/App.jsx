import { useState } from "react";
import "./styles.css";
import SidebarComponent from "./components/SidebarComponent.jsx";
import Documents from "./pages/Documents.jsx";
import Upload from "./pages/Upload.jsx";
import Agent from "./pages/Agent.jsx";
import Settings from "./pages/Settings.jsx";

/**
 * Hauptkomponente der HF-Informationswerkstatt.
 * Steuert die sichtbare Ansicht (view) und das Öffnen/Schließen der Sidebar.
 */
export default function App() {
  const [open, setOpen] = useState(true);
  const [view, setView] = useState("documents");

  return (
    <div className="app">
      <SidebarComponent open={open} view={view} setView={setView} />
      <div className="content">
        <div className="topbar">
          <button className="burger" onClick={() => setOpen((v) => !v)}>
            ≡
          </button>
        </div>
        <div>
          <div className="hf-text-bold">HF‑Informationswerkstatt</div>
          <div style={{ fontSize: 12, opacity: 0.7 }}>
            Prototype · React + SWA · {view}
          </div>
        </div>
        {view === "documents" && <Documents />}
        {view === "upload" && <Upload />}
        {view === "agent" && <Agent />}
        {view === "settings" && <Settings />}
      </div>
    </div>
  );
}
