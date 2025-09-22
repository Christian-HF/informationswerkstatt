export default function Settings() {
  return (
    <>
      <h2>⚙️ Einstellungen</h2>
      <div className="card">
        <div className="grid cols-2">
          <div>
            <div style={{ fontWeight:600, marginBottom:6 }}>Teams-Benachrichtigungen</div>
            <p style={{ margin:0, opacity:.8 }}>Später via Logic Apps / Webhooks. Abos für Themen wie „Redispatch“, „Marktkommunikation“, …</p>
          </div>
          <div>
            <div style={{ fontWeight:600, marginBottom:6 }}>Datenquellen</div>
            <p style={{ margin:0, opacity:.8 }}>BDEW, VKU, … (Crawler/ETL folgt).</p>
          </div>
        </div>
      </div>
    </>
  );
}
