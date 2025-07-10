import os
import coding_assistant_agent
from google.adk.sessions import InMemorySessionService
from google.adk.runners import Runner
from google.genai import types  # For creating message Content/Parts

os.environ["GOOGLE_API_KEY"] = os.getenv("GEMINI_API_KEY")
os.environ["GOOGLE_GENAI_USE_VERTEXAI"] = "False"
# AGENT_MODEL = "gemini-2.0-flash"  # Starting with a powerful Gemini model
session_service = None
session = None
runner = None


def get_session(app_name, user_id, session_id):
    global session, session_service
    if (session_service is None):
        session_service = InMemorySessionService()
    if (session is None):
        session = session_service.create_session(
            app_name=app_name,
            user_id=user_id,
            session_id=session_id
        )
    return session, session_service


def get_runner(session_service, agent_model, app_name):
    global runner 
    if (runner is None):
        runner = Runner(
            agent=coding_assistant_agent.create_agent(agent_model),  # the agent we want to run
            app_name=app_name,   # associates runs with our app
            session_service=session_service # Uses our session_service manager
        )
    return runner


async def call_agent_async(query: str, runner, user_id, session_id):
    """Sends a query to the agent and prints the final response."""
    print(f"\n>>> User Query: {query}")

    # Prepare the user's message in ADK format
    content = types.Content(role='user', parts=[types.Part(text=query)])
    final_response_text = "Agent did not produce a final response."  # Default

    # Key Concept: run_async executes the agent logic and yields Events.
    # We iterate through events to find the final answer.
    async for event in runner.run_async(user_id=user_id, session_id=session_id, new_message=content):
        # You can uncomment the line below to see *all* events during execution
        # print(f"  [Event] Author: {event.author}, Type: {type(event).__name__}, Final: {event.is_final_response()}, Content: {event.content}")

        # Key Concept: is_final_response() marks the concluding message for the turn.
        if event.is_final_response():
            if event.content and event.content.parts:
                # Assuming text response in the first part
                final_response_text = event.content.parts[0].text
            elif event.actions and event.actions.escalate:  # Handle potential errors/escalations
                final_response_text = f"Agent escalated: {
                    event.error_message or 'No specific message.'}"
            # Add more checks here if needed (e.g., specific error codes)
            break  # Stop processing events once the final response is found
    return final_response_text
