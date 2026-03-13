"""Claude API agent with tool-use loop for Dwarf Fortress interaction."""

from __future__ import annotations

import json
import os

import anthropic

from .client import BridgeError, DFBridgeClient
from .system_prompt import build_system_prompt
from .tools import ALL_TOOLS, OBSERVATION_TOOL_NAMES

DEFAULT_MODEL = "claude-sonnet-4-20250514"
MAX_TOOL_ROUNDS = 20


class DFAgent:
    def __init__(
        self,
        bridge: DFBridgeClient,
        model: str | None = None,
        api_key: str | None = None,
    ):
        self.bridge = bridge
        self.model = model or os.environ.get("DF_AGENT_MODEL", DEFAULT_MODEL)
        self.client = anthropic.Anthropic(api_key=api_key)
        self.conversation: list[dict] = []

    def _get_snapshot(self) -> dict | None:
        try:
            return self.bridge.get_fortress_overview()
        except BridgeError:
            return None

    def _execute_tool(self, name: str, input_args: dict) -> str:
        try:
            result = self.bridge.call(name, input_args if input_args else None)
            return json.dumps(result, indent=2)
        except BridgeError as e:
            return json.dumps({"error": str(e)})

    def chat(
        self,
        user_message: str,
        on_text: callable = None,
        on_tool_call: callable = None,
        on_tool_result: callable = None,
    ) -> str:
        """Process a user message through the agent loop.

        Args:
            user_message: The user's chat message
            on_text: Callback(text_chunk) for streaming text output
            on_tool_call: Callback(tool_name, tool_input) when a tool is called
            on_tool_result: Callback(tool_name, result_str) when a tool returns

        Returns:
            The complete assistant text response
        """
        # Pause the game
        try:
            self.bridge.pause()
        except BridgeError:
            pass

        # Get game snapshot for context
        snapshot = self._get_snapshot()
        system_prompt = build_system_prompt(snapshot)

        # Add user message to conversation
        self.conversation.append({"role": "user", "content": user_message})

        # Trim conversation history to avoid context overflow
        if len(self.conversation) > 40:
            self.conversation = self.conversation[-30:]

        # Tool-use loop
        messages = list(self.conversation)
        full_response_text = ""

        for _ in range(MAX_TOOL_ROUNDS):
            response = self.client.messages.create(
                model=self.model,
                max_tokens=4096,
                system=system_prompt,
                tools=ALL_TOOLS,
                messages=messages,
            )

            # Process response content blocks
            tool_uses = []
            text_parts = []

            for block in response.content:
                if block.type == "text":
                    text_parts.append(block.text)
                    if on_text:
                        on_text(block.text)
                elif block.type == "tool_use":
                    tool_uses.append(block)
                    if on_tool_call:
                        on_tool_call(block.name, block.input)

            if text_parts:
                full_response_text += "".join(text_parts)

            # If no tool calls, we're done
            if response.stop_reason == "end_of_turn" or not tool_uses:
                break

            # Execute tool calls and build tool results
            assistant_msg = {"role": "assistant", "content": response.content}
            messages.append(assistant_msg)

            tool_results = []
            for tool_use in tool_uses:
                result_str = self._execute_tool(tool_use.name, tool_use.input)
                if on_tool_result:
                    on_tool_result(tool_use.name, result_str)
                tool_results.append(
                    {
                        "type": "tool_result",
                        "tool_use_id": tool_use.id,
                        "content": result_str,
                    }
                )

            messages.append({"role": "user", "content": tool_results})

        # Save assistant response to conversation history
        self.conversation.append(
            {"role": "assistant", "content": full_response_text}
        )

        # Unpause the game
        try:
            self.bridge.unpause()
        except BridgeError:
            pass

        return full_response_text

    def reset_conversation(self) -> None:
        self.conversation = []
