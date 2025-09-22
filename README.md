# InformationsWerkstatt (HF)

Interne Web-Anwendung zur Verwaltung von Webcrawlern (Verbände/Regulatoren), manuellem Dokument-Upload,
automatischer Klassifikation und Q&A (RAG) – Azure-basiert.

## Ordner
- `frontend/` – React-Frontend (TypeScript)
- `api/` – Backend/API (NestJS, TypeScript)
- `functions/` – Azure Functions (Python) für Crawler/Jobs
- `infra/` – Bicep-Infrastruktur
- `.github/workflows/` – CI/CD-Pipelines (GitHub Actions)

## Erste Schritte
1. **Repo lokal klonen oder anlegen** (siehe Anleitung in Chat).
2. Diese Dateien in das lokale Repo legen.
3. Commit & Push auf `main`.
4. In GitHub → *Settings → Secrets and variables → Actions*:
   - `AZURE_CLIENT_ID`, `AZURE_TENANT_ID`, `AZURE_SUBSCRIPTION_ID`
   - `AZURE_SWA_TOKEN` (von der Static Web App)
5. Pipeline triggert automatisch bei Push auf `main`.
6. **Wichtig**: Ersetze Platzhalter (Passwörter/Tokens) vor echtem Deployment.

