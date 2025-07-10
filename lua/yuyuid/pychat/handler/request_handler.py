import sys
import asyncio
from os.path import dirname, abspath
sys.path.append(f"{dirname(dirname(abspath(__file__)))}/agent")

from agent_builder import get_session, get_runner, call_agent_async
import logging

logging.basicConfig(
    filename="simplelog.log",
    level=logging.DEBUG,
    format="%(asctime)s [%(levelname)s] %(message)s",
)

APP_NAME = "coding_assistant"
USER_ID = "user_1"
SESSION_ID = "session_001"
LLM_MODEL = "gemini-2.0-flash"


def handle_send_message(data):
    """Handles the 'sendMessage' command."""
    logging.info(f"Received Message: {data}")

    # Extract content for the LLM.  Handle potential missing params.
    try:
        content = data["params"][-1]["content"]
    except (KeyError, TypeError):
        logging.warning(
            "Missing 'params' or 'content' in sendMessage request.")
        content = ""  # Provide a default or handle the error as needed

    llm_response = _send_to_llm(content)
    return {
        "jsonrpc": "2.0",
        "method": "sendMessage",
        "id": data.get("id"),
        "result": {
            "message": "Message processed",
            "content": llm_response,
            "role": "system"
        }
    }


def handle_initialize_connection(data):
    """Handles the 'initialize' command."""
    logging.info(f"Connection initialized for ID {data.get('id')}")
    return {
        "jsonrpc": "2.0",
        "method": "initialize",
        "id": data.get("id"),
        "result": {
            "message": "Connection initialized"
        }
    }


def handle_close_connection(data):
    """Handles the 'close' command."""
    logging.info(f"Connection Close for ID {data.get('id')}")
    return {
        "jsonrpc": "2.0",
        "method": "close",
        "id": data.get("id"),
        "result": {
            "message": "Connection Closed"
        }
    }


def _send_to_llm(prompt):
    """
    Placeholder function to send the prompt to LLM and return a response.
    Replace this with your actual LLM call.
    """
    logging.info(f"The prompt is: {prompt}")
    session, session_service = get_session(APP_NAME, USER_ID, SESSION_ID)
    runner = get_runner(session_service, LLM_MODEL, APP_NAME)
    return f"{asyncio.run(call_agent_async(prompt, runner, USER_ID, SESSION_ID))}" 

def handle_unknown_method(data):
    """Handles unknown methods."""
    logging.warn(f"Unknown Method from request: {data.get('id')}")
    return {
        "jsonrpc": "2.0",
        "id": data.get("id"),
        "error": {
            "code": -32601,
            "message": "Unknown command"
        }
    }


def process_request(data):
    """Routes the request to the appropriate handler."""
    method = data.get("method", "")

    if method == "initialize":
        return handle_initialize_connection(data)
    elif method == "sendMessage":
        return handle_send_message(data)
    elif method == "close":
        return handle_close_connection(data)
    else:
        return handle_unknown_method(data)
