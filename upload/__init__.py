import azure.functions as func

def main(req: func.HttpRequest, outputBlob: func.Out[bytes]) -> func.HttpResponse:
    try:
        # Dateiinhalt aus Body holen
        data = req.get_body()
        if not data:
            return func.HttpResponse("Empty body", status_code=400)

        # Filename aus Route holen
        filename = req.route_params.get("filename")
        if not filename:
            return func.HttpResponse("Missing filename in route", status_code=400)

        # In den Blob schreiben
        outputBlob.set(data)

        return func.HttpResponse(
            f"Uploaded to blob 'uploads/{filename}'",
            status_code=200
        )
    except Exception as e:
        return func.HttpResponse(f"Upload error: {e}", status_code=500)