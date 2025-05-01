from google.adk.agents import Agent
from google.genai import types


def create_agent(agent_model):
    coding_agent = Agent(
        name="coding_agent_v1",
        model=agent_model,
        description="A coding assistant to explain, review and generate code",
        instruction="You are a helpful coding assistant primarily helping for explain, review, and generating code",
        tools=[],
        generate_content_config=types.GenerateContentConfig(
            temperature=0.2,
            max_output_tokens=640
        )
    )

    return coding_agent
