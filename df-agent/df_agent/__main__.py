"""Entry point: python -m df_agent"""

import argparse
import os
import sys


def main():
    parser = argparse.ArgumentParser(
        description="AI assistant for Dwarf Fortress powered by Claude"
    )
    parser.add_argument(
        "--host",
        default=os.environ.get("DF_BRIDGE_HOST", "localhost"),
        help="Bridge host (default: localhost)",
    )
    parser.add_argument(
        "--port",
        type=int,
        default=int(os.environ.get("DF_BRIDGE_PORT", "5580")),
        help="Bridge port (default: 5580)",
    )
    parser.add_argument(
        "--model",
        default=os.environ.get("DF_AGENT_MODEL"),
        help="Claude model to use (default: claude-sonnet-4-20250514)",
    )

    args = parser.parse_args()

    # Check for API key
    if not os.environ.get("ANTHROPIC_API_KEY"):
        print("Error: ANTHROPIC_API_KEY environment variable is required.")
        print("Set it with: export ANTHROPIC_API_KEY='your-key-here'")
        sys.exit(1)

    from .cli import run_cli

    run_cli(host=args.host, port=args.port, model=args.model)


if __name__ == "__main__":
    main()
