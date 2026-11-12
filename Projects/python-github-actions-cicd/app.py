"""Minimal HTTP health-check application for a CI/CD demonstration."""

import json
from http.server import BaseHTTPRequestHandler, HTTPServer


def health_payload():
    """Return the application's health status."""
    return {"status": "healthy", "service": "python-cicd-demo"}


class HealthHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/health":
            body = json.dumps(health_payload()).encode("utf-8")
            self.send_response(200)
            self.send_header("Content-Type", "application/json")
            self.send_header("Content-Length", str(len(body)))
            self.end_headers()
            self.wfile.write(body)
        else:
            body = json.dumps({"error": "not found"}).encode("utf-8")
            self.send_response(404)
            self.send_header("Content-Type", "application/json")
            self.send_header("Content-Length", str(len(body)))
            self.end_headers()
            self.wfile.write(body)

    def log_message(self, format_string, *args):
        """Keep the container logs concise."""
        print("%s - %s" % (self.address_string(), format_string % args))


if __name__ == "__main__":
    server = HTTPServer(("0.0.0.0", 8080), HealthHandler)
    print("Health-check service listening on port 8080")
    server.serve_forever()
