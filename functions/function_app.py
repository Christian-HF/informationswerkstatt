import os
import azure.functions as func
from azure.storage.blob import BlobServiceClient
from azure.core.exceptions import ResourceExistsError

app = func.FunctionApp(http_auth_level=func.AuthLevel.ANONYMOUS)

@app.route(route="upload", methods=["POST"])
def upload_file(req: func.HttpRequest) -> func.HttpResponse:
    try:
        file = req.files.get('file') if hasattr(req, 'files') else None
    except Exception:
        file = None

    if not file:
        return func.HttpResponse("No file provided (expected form-data field 'file').", status_code=400)

    filename = getattr(file, 'filename', 'upload.bin')
    conn = os.getenv("AZURE_STORAGE_CONNECTION_STRING")
    container = os.getenv("HF_UPLOAD_CONTAINER", "uploads")

    if conn:
        try:
            bsc = BlobServiceClient.from_connection_string(conn)
            cc = bsc.get_container_client(container)
            try:
                cc.create_container()
            except ResourceExistsError:
                pass
            blob = cc.get_blob_client(blob=filename)
            blob.upload_blob(file.stream, overwrite=True)
            return func.HttpResponse(f"Uploaded to blob '{container}/{filename}'.", status_code=200)
        except Exception as e:
            return func.HttpResponse(f"Upload error: {e}", status_code=500)

    return func.HttpResponse(f"(Dry-run) Received file '{filename}'. Set AZURE_STORAGE_CONNECTION_STRING to enable upload.", status_code=200)
