#!/usr/bin/env python3
# Grok Bot -> jade-py bridge (Python version).
# Runs in the Grok Bot environment or as a local server.

network is offline in the Grok Bot sandbox, so this script is meant to live
# on the same host as jade-py and be called by the Grok Bot via a local internal
# network endpoint.

import http.server
import json
import os
import urllib.request

JADE_API_URL = os.environ['JADE_API_URL'] if 'JADE_API_URL' in os.environelse 'http://localhost:8760/v1/chat'
JADE_API_TOKEN = os.environ.get('JADE_API_TOKEN')
GROK_PORT = int(os.environ.get('GROK_PORT', 8780))

def forward(method, target_url, body=None, headers=None):
    headers = headers or {}
    headers['Content-Type'] = 'application/json'
    headers['Accept'] = 'application/json'
    if JADE_API_TOKEN:
        headers['Authorization'] = f'Bearer {JADE_API_TOKEN}'
    data = json.dumps(body).encode() if body else None
    req = urllib.request.Request(target_url, data=data, headers=headers, method=method)
    with urllib.request.urlopen(req, timeout=30) as resp:
        return json.loads(resp.read().decode())

class GrokBridgeHandler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/health':
            self.send_json({'ok': True})
            return
        self.send_json({'ok': False, 'error': 'unknown endpoint'}, status=404)

    def do_POST(self):
        if self.path not in ('/v1', '/v1/chat'):
            self.send_json({'ok': False, 'error': 'unknown endpoint'}, status=404)
            return
        content_length = int(self.headers['Content-Length'])
        body = self.rfile.read(content_length).decode()
        try:
            payload = json.loads(body)
            message = payload.get('message', payload.get('prompt', payload.get('text', '')))
            if not message:
                self.send_json({'ok': False, 'error': 'missing_message'}, status=400)
                return
            result = forward('POST', JADE_API_URL, {'message': message, 'stream': False})
            self.send_json(result)
        except Exception as e:
            self.send_json({'ok': False, 'error': str(e)}, status=502)

    def send_json(self, data, status=200):
        self.send_response(status, {'Content-Type': 'application/json'})
        self.wfile.write(json.dumps(data).encode())

def run():
    with http.server.HTTPServer(('', GROK_PORT), GrokBridgeHandler) as server:
        print(f'Grok bridge listening on port {GROK_PORT}')
        server.serve_forever()

if __name__ == '__main__':
    run()