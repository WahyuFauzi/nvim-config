import logging
from handler import request_handler, io_handler

logging.basicConfig(
    filename="simplelog.log",
    level=logging.DEBUG,
    format="%(asctime)s [%(levelname)s] %(message)s",
)


def main():
    """Main function to orchestrate request processing."""

    while True:
        try:
            data = io_handler.read_request()
            logging.info(f"Request Received with data: {data}")
            if data is None:  # Handle JSON parsing failure
                io_handler.send_error_response(
                    "Failed to parse JSON request", None)
                continue  # Skip processing and read next request

            response = request_handler.process_request(data)
            logging.info(f"Response data: {response}")
            io_handler.send_response(response)

        except Exception as e:
            logging.error(f"Error processing request: {e}")
            io_handler.send_error_response(
                e, data if 'data' in locals() else None)

        except KeyboardInterrupt:
            break  # Handle Ctrl+C gracefully


if __name__ == "__main__":
    main()
