#!/usr/bin/env python3
"""Simple CLI to call bridge methods via file IPC. Used by Claude Code as a proxy agent."""

from __future__ import annotations

import json
import os
import sys
import time
import uuid


DEFAULT_IPC_DIR = os.path.join(
    os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))),
    "df_osx", "df-agent-ipc"
)


def call_bridge(method: str, params: dict | None = None, ipc_dir: str = DEFAULT_IPC_DIR, timeout: float = 10.0) -> dict:
    request_file = os.path.join(ipc_dir, "request.json")
    response_file = os.path.join(ipc_dir, "response.json")
    lock_file = os.path.join(ipc_dir, "ready.lock")

    if not os.path.exists(lock_file):
        raise ConnectionError(f"Bridge not running (no {lock_file})")

    request_id = str(uuid.uuid4())[:8]
    request = {"id": request_id, "method": method}
    if params:
        request["params"] = params

    # Clean stale response
    if os.path.exists(response_file):
        os.remove(response_file)

    # Write request
    with open(request_file, "w") as f:
        json.dump(request, f)

    # Poll for response
    start = time.time()
    while time.time() - start < timeout:
        if os.path.exists(response_file):
            time.sleep(0.05)
            try:
                with open(response_file, "rb") as f:
                    content = f.read().decode("utf-8", errors="replace")
                os.remove(response_file)
                return json.loads(content)
            except (json.JSONDecodeError, IOError):
                time.sleep(0.1)
                continue
        time.sleep(0.05)

    if os.path.exists(request_file):
        os.remove(request_file)
    raise TimeoutError("Timed out waiting for bridge response")


def main():
    if len(sys.argv) < 2:
        print("Usage: bridge_cli.py <method> [json_params]")
        print("Example: bridge_cli.py ping")
        print("Example: bridge_cli.py get_units '{\"filter\":\"citizens\"}'")
        sys.exit(1)

    method = sys.argv[1]
    params = None
    if len(sys.argv) > 2:
        params = json.loads(sys.argv[2])

    # Allow overriding IPC dir
    ipc_dir = os.environ.get("DF_IPC_DIR", DEFAULT_IPC_DIR)

    try:
        result = call_bridge(method, params, ipc_dir=ipc_dir)
        print(json.dumps(result, indent=2))
    except ConnectionError as e:
        print(json.dumps({"error": str(e)}))
        sys.exit(1)
    except TimeoutError as e:
        print(json.dumps({"error": str(e)}))
        sys.exit(1)
    except Exception as e:
        print(json.dumps({"error": str(e)}))
        sys.exit(1)


if __name__ == "__main__":
    main()
