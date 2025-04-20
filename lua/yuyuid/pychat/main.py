import sys
import logging
import os
import json

# 📝 Setup logging
logging.basicConfig(
    filename="simplelog.log",
    level=logging.DEBUG,
    format="%(asctime)s [%(levelname)s] %(message)s",
)

gemini_api_key = os.getenv("GEMINI_API_KEY")


# Function to handle 'sendMessage' command
def handle_send_message(data):
    logging.info(f"Received Message: {data}")
    # send request to gemini
    return {
        "jsonrpc": "2.0",
        "method": "sendMessage",
        "id": data.get("id"),  # keep same ID from request
        "result": {
            "message": "Message processed",  # changed message
            "content": "RETURN MESSAGE HERE FROM LLM",
            "role": "system"
        }
    }


def handle_initialize_connection(data):
    logging.info(f"Connection initialized for ID {data.get('id')}")
    return {
        "jsonrpc": "2.0",
        "method": "initialize",
        "id": data.get("id"),  # keep same ID from request
        "result": {
            "message": "Connection initialized"
        }
    }


def handle_close_connection(data):
    logging.info(f"Connection Close for ID {data.get('id')}")
    return {
        "jsonrpc": "2.0",
        "method": "close",
        "id": data.get("id"),  # keep same ID from request
        "result": {
            "message": "Connection Closed"
        }
    }


def main():
    while True:
        try:
            # Read headers
            headers = {}
            while True:
                # Read a line and remove leading/trailing whitespace
                line = sys.stdin.readline().strip()
                if not line:  # Empty line signifies end of headers
                    break

                key, value = line.split(":", 1)  # Split into key and value
                headers[key.strip()] = value.strip()  # Store the header

            # Read the body based on Content-Length
            # Default to 0 if not present
            content_length = int(headers.get("Content-Length", 0))
            body = sys.stdin.read(content_length)

            data = json.loads(body)
            method = data.get("method", "")

            # 👇 Manually handle 'hello' and 'sendMessage' commands
            if method == "initialize":
                response = handle_initialize_connection(data)
            elif method == "sendMessage":
                response = handle_send_message(data)
            elif method == "close":
                response = handle_close_connection(data)
            else:
                logging.warn(f"Unknown Method from request: {data.get('id')}")
                response = {
                    "jsonrpc": "2.0",
                    # keep the ID even for unknown commands
                    "id": data.get("id"),
                    "error": {
                        "code": -32601,
                        "message": "Unknown command"
                    }
                }

            # 📨 Send response back to stdout as JSON string
            response_str = json.dumps(response)
            # **Important**: Include content length in response headers
            response_headers = f"Content-Length: {len(response_str)}\r\n\r\n"
            # include headers in response
            sys.stdout.write(response_headers + response_str + "\n")
            sys.stdout.flush()

        except Exception as e:
            logging.error(f"Error processing request: {e}")
            # Send an error response
            error_response = {
                "jsonrpc": "2.0",
                # keep the ID if available
                "id": data.get("id", None) if 'data' in locals() else None,
                "error": {
                    "code": -32000,
                    "message": str(e)
                }
            }
            error_response_str = json.dumps(error_response)
            response_headers = f"Content-Length: {
                len(error_response_str)}\r\n\r\n"
            sys.stdout.write(response_headers + error_response_str + "\n")
            sys.stdout.flush()
        except KeyboardInterrupt:
            break  # handle Ctrl+C gracefully


if __name__ == "__main__":
    main()
