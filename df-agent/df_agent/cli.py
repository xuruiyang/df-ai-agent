"""Terminal chat UI for the Dwarf Fortress AI agent."""

from __future__ import annotations

import sys

import anthropic
from prompt_toolkit import PromptSession
from prompt_toolkit.formatted_text import HTML
from prompt_toolkit.history import InMemoryHistory
from rich.console import Console
from rich.markdown import Markdown
from rich.panel import Panel
from rich.text import Text

from .agent import DFAgent
from .client import BridgeError, DFBridgeClient


class ChatUI:
    def __init__(self, host: str = "localhost", port: int = 5580, model: str | None = None):
        self.bridge = DFBridgeClient(host=host, port=port)
        self.agent: DFAgent | None = None
        self.console = Console()
        self.session = PromptSession(history=InMemoryHistory())
        self.model = model

    def _connect(self) -> bool:
        try:
            self.bridge.connect()
            self.agent = DFAgent(self.bridge, model=self.model)
            self.console.print("[green]Connected to Dwarf Fortress bridge[/green]")
            # Show initial game state
            try:
                overview = self.bridge.get_fortress_overview()
                self.console.print(
                    f"  Year {overview.get('year', '?')}, "
                    f"{overview.get('season', '?')} | "
                    f"Pop: {overview.get('population', '?')} | "
                    f"Food: {overview.get('food', '?')} | "
                    f"Drink: {overview.get('drink', '?')}"
                )
            except BridgeError:
                pass
            return True
        except (OSError, BridgeError) as e:
            self.console.print(f"[red]Connection failed: {e}[/red]")
            self.console.print(
                "[dim]Make sure Dwarf Fortress is running with DFHack and "
                "run 'df-agent-bridge' in the DFHack console.[/dim]"
            )
            return False

    def _disconnect(self):
        self.bridge.disconnect()
        self.agent = None
        self.console.print("[yellow]Disconnected[/yellow]")

    def _handle_command(self, text: str) -> bool:
        """Handle slash commands. Returns True if handled."""
        if text == "/quit" or text == "/exit":
            self._disconnect()
            return True
        elif text == "/connect":
            self._connect()
            return True
        elif text == "/disconnect":
            self._disconnect()
            return True
        elif text == "/pause":
            try:
                self.bridge.pause()
                self.console.print("[yellow]Game paused[/yellow]")
            except BridgeError as e:
                self.console.print(f"[red]{e}[/red]")
            return True
        elif text == "/unpause":
            try:
                self.bridge.unpause()
                self.console.print("[green]Game unpaused[/green]")
            except BridgeError as e:
                self.console.print(f"[red]{e}[/red]")
            return True
        elif text == "/status":
            if self.bridge.connected:
                try:
                    overview = self.bridge.get_fortress_overview()
                    self.console.print(Panel(
                        f"Year {overview.get('year', '?')}, "
                        f"{overview.get('season', '?')}\n"
                        f"Population: {overview.get('population', '?')}\n"
                        f"Food: {overview.get('food', '?')} | "
                        f"Drink: {overview.get('drink', '?')}\n"
                        f"Paused: {overview.get('paused', '?')}",
                        title="Fortress Status",
                    ))
                except BridgeError as e:
                    self.console.print(f"[red]{e}[/red]")
            else:
                self.console.print("[dim]Not connected[/dim]")
            return True
        elif text == "/clear":
            if self.agent:
                self.agent.reset_conversation()
            self.console.print("[dim]Conversation cleared[/dim]")
            return True
        elif text == "/help":
            self.console.print(Panel(
                "/connect    - Connect to game bridge\n"
                "/disconnect - Disconnect from bridge\n"
                "/status     - Show fortress status\n"
                "/pause      - Pause the game\n"
                "/unpause    - Unpause the game\n"
                "/clear      - Clear conversation history\n"
                "/quit       - Exit df-agent",
                title="Commands",
            ))
            return True
        return False

    def _get_prompt(self) -> HTML:
        if self.bridge.connected:
            return HTML("<ansigreen>You</ansigreen>> ")
        return HTML("<ansired>[disconnected]</ansired>> ")

    def run(self):
        self.console.print(Panel(
            "Dwarf Fortress AI Agent\n"
            "Type a message to chat, or /help for commands.\n"
            "Connecting to bridge...",
            title="df-agent",
            style="bold blue",
        ))

        self._connect()
        self.console.print()

        while True:
            try:
                text = self.session.prompt(self._get_prompt()).strip()
                if not text:
                    continue

                # Handle slash commands
                if text.startswith("/"):
                    if text in ("/quit", "/exit"):
                        self.console.print("[dim]Goodbye![/dim]")
                        break
                    self._handle_command(text)
                    continue

                # Chat with the agent
                if not self.agent or not self.bridge.connected:
                    self.console.print(
                        "[red]Not connected. Use /connect first.[/red]"
                    )
                    continue

                self.console.print()

                # Callbacks for display
                tool_calls_made = []

                def on_tool_call(name, args):
                    tool_calls_made.append(name)
                    args_brief = ", ".join(
                        f"{k}={v}" for k, v in (args or {}).items()
                    )
                    self.console.print(
                        f"  [dim]> {name}({args_brief})[/dim]"
                    )

                def on_tool_result(name, result):
                    # Show truncated result
                    preview = result[:200] + "..." if len(result) > 200 else result
                    self.console.print(f"  [dim]  = {preview}[/dim]")

                try:
                    response = self.agent.chat(
                        text,
                        on_tool_call=on_tool_call,
                        on_tool_result=on_tool_result,
                    )

                    if tool_calls_made:
                        self.console.print()

                    # Render response as markdown
                    self.console.print(Markdown(response))

                except anthropic.APIError as e:
                    self.console.print(f"[red]API error: {e}[/red]")
                except BridgeError as e:
                    self.console.print(f"[red]Bridge error: {e}[/red]")
                    self.console.print(
                        "[dim]Connection may be lost. Try /connect[/dim]"
                    )
                    self.bridge.disconnect()
                    self.agent = None

                self.console.print()

            except KeyboardInterrupt:
                continue
            except EOFError:
                self.console.print("[dim]Goodbye![/dim]")
                break


def run_cli(host: str = "localhost", port: int = 5580, model: str | None = None):
    ui = ChatUI(host=host, port=port, model=model)
    ui.run()
