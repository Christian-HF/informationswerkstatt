import azure.functions as func

def main(req: func.HttpRequest, outputBlob: func.Out[bytes]) -> func.HttpResponse:
    try:
        data = req.get_body() or b""
        if not data:
            return func.HttpResponse("Empty body. Send bytes or multipart 'file'.", status_code=400)

        filename = req.headers.get("x-filename")
        if not filename:
            return func.HttpResponse("Missing header 'x-filename'", status_code=400)

        # Schreibe in den Blob
        outputBlob.set(data)

        return func.HttpResponse(f"Uploaded to blob 'uploads/{filename}'", status_code=200)
    except Exception as e:
        return func.HttpResponse(f"Upload error: {e}", status_code=500)
