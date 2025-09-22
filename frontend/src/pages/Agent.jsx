import { useState } from "react";

export default function Agent() {
  const [q, setQ] = useState("");
  const [items, setItems] = useState([
    { role:"assistant", text:"Hallo! Frag mich etwas zu BDEW/VKU-Dokumenten 🧠" }
  ]);

  function ask(e){
    e.preventDefault();
    if(!q.trim()) return;
    setItems(prev=>[
      ...prev,
      { role:"user", text:q.trim() },
      { role:"assistant", text:"(Platzhalter) Später befrage ich Azure OpenAI & Search und antworte mit Quellen." }
    ]);
    setQ("");
  }

  return (
    <>
      <h2>🤖 Agent (Q&A)</h2>
      <div className="card">
        <div style={{ display:"grid", gap:10 }}>
          {items.map((m,i)=>(
            <div key={i} style={{
              background: m.role==="user" ? "#f6fafc" : "#fff",
              border:"1px solid #e7ebef", borderRadius:12, padding:12
            }}>
              <div style={{ fontSize:12, opacity:.7, marginBottom:4 }}>
                {m.role==="user" ? "Du" : "Agent"}
              </div>
              <div>{m.text}</div>
            </div>
          ))}
          <form onSubmit={ask} style={{ display:"flex", gap:8 }}>
            <input value={q} onChange={(e)=>setQ(e.target.value)} placeholder="Frage stellen…" style={{ flex:1, padding:10, borderRadius:10, border:"1px solid #dde2e6" }}/>
            <button className="burger" type="submit">Senden</button>
          </form>
        </div>
      </div>
    </>
  );
}
