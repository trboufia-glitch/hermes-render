#!/bin/bash
set -e

# إنشاء مجلد الإعدادات
mkdir -p /app/.hermes

# إنشاء ملف config.yaml من القالب
envsubst < /app/hermes-config.yaml.template > /app/.hermes/config.yaml

# بدء خادم HTTP بسيط على المنفذ 10000 في الخلفية
# هذا يرضي Render health check
python3 -c "
import http.server
import socketserver
import os

PORT = int(os.environ.get('PORT', 10000))

class Handler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-type', 'text/plain')
        self.end_headers()
        self.wfile.write(b'Hermes Telegram Bot is running')
    
    def log_message(self, format, *args):
        pass

with socketserver.TCPServer(('0.0.0.0', PORT), Handler) as httpd:
    httpd.serve_forever()
" &

# بدء Hermes gateway
exec hermes gateway run
