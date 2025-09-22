import { useState } from "react";
import "./styles.css";
import Sidebar from "./components/Sidebar.jsx";
import Documents from "./pages/Documents.jsx";
import Upload from "./pages/Upload.jsx";
import Agent from "./pages/Agent.jsx";
import Settings from "./pages/Settings.jsx";

export default function App(){
  const [open, setOpen] = useState(true);
  const [view, setView] = useState("documents");

  return (
    <div className="app">
      <Sidebar open={open} view={view} setView={setView} />
      <div className="content">
        <div className="topbar">
          <button className="burger" onClick={()=>setOpen(v=>!v)}>☰</button>
          <div>
            <div style={{ fontWeight:700 }}>Informationswerkstatt</div>
            <div style={{ fontSize:12, opacity:.7 }}>
              Prototype • React + SWA • {view}
            </div>
          </div>
        </div>

        {view === "documents" && <Documents />}
        {view === "upload"    && <Upload />}
        {view === "agent"     && <Agent />}
        {view === "settings"  && <Settings />}
      </div>
    </div>
  );
}
