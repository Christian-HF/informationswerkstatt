export default function Documents() {
  const rows = [
    { id:1, title:"BDEW Leitfaden XY (PDF)", tags:["BDEW","Recht"], date:"2025-09-01" },
    { id:2, title:"VKU Rundschreiben 2025-08", tags:["VKU"], date:"2025-08-28" },
  ];
  return (
    <>
      <h2>📄 Dokumente</h2>
      <div className="card">
        <div className="grid cols-2">
          <div><strong>Suche/Filter (später):</strong> Themen, Verband, Datum</div>
          <div style={{ textAlign:"right" }}><span className="badge">Platzhalter</span></div>
        </div>
      </div>
      {rows.map(r => (
        <div className="card" key={r.id}>
          <div style={{ fontWeight:600 }}>{r.title}</div>
          <div style={{ fontSize:13, opacity:.8, marginTop:6 }}>
            {r.tags.map(t => <span key={t} className="badge" style={{ marginRight:6 }}>{t}</span>)}
            <span style={{ marginLeft:8 }}>• {r.date}</span>
          </div>
        </div>
      ))}
    </>
  );
}
