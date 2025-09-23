import azure.functions as func

def main(req: func.HttpRequest, outputBlob: func.Out[bytes]) -> func.HttpResponse:
    try:
        # Dateiinhalt holen
        data = req.get_body()
        if not data:
            return func.HttpResponse("Empty body", status_code=400)

        # In Blob schreiben
        outputBlob.set(data)

        return func.HttpResponse(
            "File successfully uploaded to blob storage.",
            status_code=200
        )

    except Exception as e:
        return func.HttpResponse(
            f"Upload error: {e}",
            status_code=500
        )