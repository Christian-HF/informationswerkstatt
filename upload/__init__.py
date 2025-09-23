import logging
import azure.functions as func

def main(req: func.HttpRequest, outputBlob: func.Out[bytes]) -> func.HttpResponse:
    try:
        # Dateiinhalt aus dem Request holen
        data = req.get_body()
        if not data:
            return func.HttpResponse(
                "Empty body. Send file content in request body.",
                status_code=400
            )

        # Datei in den Blob schreiben (über Binding aus function.json)
        outputBlob.set(data)

        return func.HttpResponse(
            "File successfully uploaded to blob storage.",
            status_code=200
        )

    except Exception as e:
        logging.error(f"Upload error: {e}")
        return func.HttpResponse(
            f"Upload error: {e}",
            status_code=500
        )