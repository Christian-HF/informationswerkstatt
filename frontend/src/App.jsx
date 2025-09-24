import { useState } from "react";
import "./styles.css";
import SidebarComponent from "./components/SidebarComponent.jsx";
import Documents from "./pages/Documents.jsx";
import Upload from "./pages/Upload.jsx";
import Agent from "./pages/Agent.jsx";
import Subscriptions from "./pages/Subscriptions.jsx";

export default function App() {
  const [open, setOpen] = useState(true);
  const [view, setView] = useState("sources");

  return (
    <div className="app">
      <SidebarComponent open={open} view={view} setView={setView} />

      <div className="content">
        <div className="card-layout">
          <div className="card-header">
            <h1>HF-Informationswerkstatt</h1>
          </div>

          <div className="card-body">
            {view === "sources" && <Documents />}
            {view === "upload" && <Upload />}
            {view === "agent" && <Agent />}
            {view === "subscriptions" && <Subscriptions />}
          </div>

          <div className="card-footer">
            <img src="/hf_logo_white.png" alt="HF Logo" />
          </div>
        </div>
      </div>
    </div>
  );
}
