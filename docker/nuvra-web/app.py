from http.server import HTTPServer, BaseHTTPRequestHandler

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-type', 'text/html')
        self.end_headers()
        html = """
        <!DOCTYPE html>
        <html>
        <head><title>Nuvraverse</title>
        <style>
        body{background:#0a0a0f;color:#f4f0e8;font-family:sans-serif;
             display:flex;align-items:center;justify-content:center;
             height:100vh;margin:0;text-align:center;}
        h1{color:#c9a84c;font-size:52px;}
        p{color:#6b6560;}
        .badge{background:#c9a84c;color:#0a0a0f;padding:10px 28px;
               font-weight:bold;display:inline-block;margin-top:20px;}
        </style></head>
        <body><div>
        <h1>NUVRAVERSE</h1>
        <p>Running in Docker on AWS ECR 🐳</p>
        <div class='badge'>Day 22 — Container Lab ⚡</div>
        </div></body></html>
        """
        self.wfile.write(html.encode())
    def log_message(self, format, *args):
        pass

if __name__ == '__main__':
    server = HTTPServer(('0.0.0.0', 8080), Handler)
    print('Server running on port 8080...')
    server.serve_forever()
