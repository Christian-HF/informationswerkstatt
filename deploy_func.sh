set -euo pipefail

RG="rg_informationswerkstatt"
LOCATION="germanywestcentral"
STORAGE="rginformationswerksa411"
SUFFIX="$(date +%H%M)"
FUNC="func-hf-info-dev-${SUFFIX}"

echo "▶️  Resource Group: $RG"
echo "▶️  Region        : $LOCATION"
echo "▶️  Storage       : $STORAGE"
echo "▶️  Function Name : $FUNC"

echo "🔎 Prüfe Azure-Kontext…"
az account show --query '{name:name,id:id,tenant:tenantId}' -o table

echo "🔑 Hole Connection String…"
CONN=$(az storage account show-connection-string -g "$RG" -n "$STORAGE" --query connectionString -o tsv)

echo "🛠️  Erzeuge Python Function App…"
az functionapp create \
  -g "$RG" \
  -n "$FUNC" \
  --consumption-plan-location "$LOCATION" \
  --runtime python --runtime-version 3.11 \
  --functions-version 4 \
  --storage-account "$STORAGE" >/dev/null

echo "⚙️  Setze App Settings…"
az functionapp config appsettings set \
  -g "$RG" -n "$FUNC" \
  --settings FUNCTIONS_WORKER_RUNTIME=python \
             AZURE_STORAGE_CONNECTION_STRING="$CONN" \
             HF_UPLOAD_CONTAINER=uploads \
             WEBSITE_RUN_FROM_PACKAGE=1 >/dev/null

echo "📦 Schreibe Function-Code…"
mkdir -p functions/upload

cat > functions/host.json <<'J'
{
  "version": "2.0",
  "extensionBundle": {
    "id": "Microsoft.Azure.Functions.ExtensionBundle",
    "version": "[4.*, 5.0.0)"
  }
}
J

cat > functions/requirements.txt <<'J'
azure-functions==1.20.0
azure-storage-blob==12.22.0
python-multipart==0.0.9
J

cat > functions/upload/function.json <<'J'
{
  "scriptFile": "__init__.py",
  "bindings": [
    { "authLevel": "anonymous", "type": "httpTrigger", "direction": "in", "name": "req", "methods": ["post"], "route": "upload" },
    { "type": "http", "direction": "out", "name": "res" }
  ]
}
J

cat > functions/upload/__init__.py <<'J'
import os
import azure.functions as func
from azure.core.exceptions import ResourceExistsError

def _upload_bytes_to_blob(data: bytes, filename: str) -> str:
    from azure.storage.blob import BlobServiceClient
    conn = os.getenv("AZURE_STORAGE_CONNECTION_STRING")
    if not conn:
        return f"(Dry-run) Received '{filename}'. Set AZURE_STORAGE_CONNECTION_STRING to enable upload."
    container = os.getenv("HF_UPLOAD_CONTAINER", "uploads")
    bsc = BlobServiceClient.from_connection_string(conn)
    cc = bsc.get_container_client(container)
    try:
        cc.create_container()
    except ResourceExistsError:
        pass
    cc.upload_blob(name=filename, data=data, overwrite=True)
    return f"Uploaded to blob '{container}/{filename}'."

def main(req: func.HttpRequest) -> func.HttpResponse:
    try:
        ct = (req.headers.get('content-type') or '').lower()
        if ct.startswith('multipart/form-data'):
            try:
                from io import BytesIO
                from multipart import MultipartParser
                parser = MultipartParser(BytesIO(req.get_body()), ct)
                file_part = next((p for p in parser.parts() if p.name == 'file'), None)
                if not file_part:
                    return func.HttpResponse("No 'file' part provided", status_code=400)
                filename = file_part.filename or "upload.bin"
                return func.HttpResponse(_upload_bytes_to_blob(file_part.raw, filename), status_code=200)
            except Exception as e:
                return func.HttpResponse(f"Multipart error: {e}", status_code=500)

        data = req.get_body() or b""
        if not data:
            return func.HttpResponse("Empty body. Send bytes or multipart 'file'.", status_code=400)
        filename = req.headers.get("x-filename", "upload.bin")
        return func.HttpResponse(_upload_bytes_to_blob(data, filename), status_code=200)
    except Exception as e:
        return func.HttpResponse(f"Upload error: {e}", status_code=500)
J

echo "🧰 Installiere Dependencies & erstelle Zip…"
pushd functions >/dev/null
rm -rf package functions.zip
python3 -m pip install -r requirements.txt -t ./package >/dev/null
cp -r host.json upload ./package/
( cd package && zip -rq ../functions.zip . )
popd >/dev/null

echo "🚀 Zip-Deploy…"
az functionapp deployment source config-zip -g "$RG" -n "$FUNC" --src functions/functions.zip >/dev/null
az functionapp restart -g "$RG" -n "$FUNC" >/dev/null

FUNC_URL="https://$(az functionapp show -g "$RG" -n "$FUNC" --query defaultHostName -o tsv)"
echo "🔗 Function URL: $FUNC_URL"

echo "hello infoswerkstatt" > "$HOME/Downloads/test.txt"
echo "📡 Test-Upload…"
curl -i -sS -X POST "$FUNC_URL/api/upload" -H "x-filename: test.txt" --data-binary "@$HOME/Downloads/test.txt"

echo
echo "✅ Fertig. Prüfe Storage-Container 'uploads' im Account '$STORAGE'."
