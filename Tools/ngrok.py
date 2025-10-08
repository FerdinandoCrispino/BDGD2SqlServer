import ngrok

listener = ngrok.forward("localhost:5000", authtoken_from_env=True,
    request_header_add="host:localhost")

print(f"Ingress established at: {listener.url()}")