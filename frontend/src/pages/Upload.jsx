import { useState } from "react";

export default function Upload() {
  const [file, setFile] = useState(null);

  return (
    <>
      <h2>⬆️ Upload</h2>
      <div className="card">
        <p>Wähle ein Dokument (PDF, DOCX, …). Backend-Upload folgt nach API/Functions.</p>
        <input
          type="file"
          onChange={(e)=>setFile(e.target.files?.[0] ?? null)}
        />
        {file && <p style={{ marginTop:10 }}>Gewählt: <strong>{file.name}</strong></p>}
        <button className="burger" disabled style={{ marginTop:10 }}>
          Upload (inaktiv – kommt mit Backend)
        </button>
      </div>
    </>
  );
}
