import azure.functions as func

def main(req: func.HttpRequest, outputBlob: func.Out[bytes]) -> str:
    data = req.get_body()
    outputBlob.set(data)
    return f"Uploaded {len(data)} bytes"