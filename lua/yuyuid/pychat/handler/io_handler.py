import sys
import json
import logging

logging.basicConfig(
    filename="simplelog.log",
    level=logging.DEBUG,
    format="%(asctime)s [%(levelname)s] %(message)s",
)


def read_request():
    """Reads headers and body from stdin and returns the parsed JSON data."""
    headers = {}
    while True:
        line = sys.stdin.readline().strip()
        if not line:
            break
        key, value = line.split(":", 1)
        headers[key.strip()] = value.strip()

    content_length = int(headers.get("Content-Length", 0))
    body = sys.stdin.read(content_length)
    try:
        return json.loads(body)
    except json.JSONDecodeError as e:
        logging.error(f"JSON Decode Error: {e}")
        return None  # Indicate failure to parse JSON


def send_response(response):
    """Sends a JSON response to stdout with headers."""
    response_str = json.dumps(response)
    response_headers = f"Content-Length: {len(response_str)}\r\n\r\n"
    sys.stdout.write(response_headers + response_str + "\n")
    sys.stdout.flush()


def send_error_response(error, data=None):
    """Sends a JSON error response to stdout with headers."""
    error_response = {
        "jsonrpc": "2.0",
        "id": data.get("id", None) if data else None,
        "error": {
            "code": -32000,
            "message": str(error)
        }
    }
    response_str = json.dumps(error_response)
    response_headers = f"Content-Length: {len(response_str)}\r\n\r\n"
    sys.stdout.write(response_headers + response_str + "\n")
    sys.stdout.flush()
