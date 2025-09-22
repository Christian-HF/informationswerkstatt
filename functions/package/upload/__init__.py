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
