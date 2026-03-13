"""File-based IPC client for communicating with the df-agent-bridge DFHack script."""

from __future__ import annotations

import json
import os
import time
import uuid


class BridgeError(Exception):
    """Error returned by the bridge."""


class DFBridgeClient:
    def __init__(self, ipc_dir: str | None = None):
        if ipc_dir:
            self.ipc_dir = ipc_dir
        else:
            # Default: df_osx/df-agent-ipc relative to project
            self.ipc_dir = os.path.join(
                os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))),
                "df_osx", "df-agent-ipc"
            )
        self.request_file = os.path.join(self.ipc_dir, "request.json")
        self.response_file = os.path.join(self.ipc_dir, "response.json")
        self.lock_file = os.path.join(self.ipc_dir, "ready.lock")

    @property
    def connected(self) -> bool:
        return os.path.exists(self.lock_file)

    def connect(self) -> None:
        if not os.path.exists(self.lock_file):
            raise BridgeError(
                f"Bridge not running (no lock file at {self.lock_file}). "
                "Start DF and run 'df-agent-bridge start' in DFHack."
            )

    def disconnect(self) -> None:
        pass  # No persistent connection to close

    def call(self, method: str, params: dict | None = None, timeout: float = 10.0) -> dict:
        if not os.path.exists(self.lock_file):
            raise BridgeError("Bridge not running")

        request_id = str(uuid.uuid4())[:8]
        request = {"id": request_id, "method": method}
        if params:
            request["params"] = params

        # Clean up any stale response
        if os.path.exists(self.response_file):
            os.remove(self.response_file)

        # Write request file
        with open(self.request_file, "w") as f:
            json.dump(request, f)

        # Poll for response
        start = time.time()
        while time.time() - start < timeout:
            if os.path.exists(self.response_file):
                # Small delay to ensure write is complete
                time.sleep(0.05)
                try:
                    with open(self.response_file, "rb") as f:
                        content = f.read().decode("utf-8", errors="replace")
                    os.remove(self.response_file)
                    result = json.loads(content)
                    if "error" in result:
                        raise BridgeError(result["error"])
                    return result.get("result", {})
                except json.JSONDecodeError:
                    # File might still be writing, retry
                    time.sleep(0.1)
                    continue
            time.sleep(0.05)

        # Timeout - clean up request
        if os.path.exists(self.request_file):
            os.remove(self.request_file)
        raise BridgeError("Timed out waiting for response (game may be paused or at a menu)")

    # Convenience methods

    def pause(self) -> dict:
        return self.call("pause")

    def unpause(self) -> dict:
        return self.call("unpause")

    def get_pause_state(self) -> dict:
        return self.call("get_pause_state")

    def get_game_time(self) -> dict:
        return self.call("get_game_time")

    def get_fortress_overview(self) -> dict:
        return self.call("get_fortress_overview")

    def get_units(self, filter: str = "citizens", limit: int = 50) -> dict:
        return self.call("get_units", {"filter": filter, "limit": limit})

    def get_unit_detail(self, unit_id: int) -> dict:
        return self.call("get_unit_detail", {"id": unit_id})

    def get_buildings(self, type_filter: str | None = None, limit: int = 50) -> dict:
        params = {"limit": limit}
        if type_filter:
            params["type"] = type_filter
        return self.call("get_buildings", params)

    def get_resources(self) -> dict:
        return self.call("get_resources")

    def get_manager_orders(self) -> dict:
        return self.call("get_manager_orders")

    def get_workshops(self, limit: int = 50) -> dict:
        return self.call("get_workshops", {"limit": limit})

    def get_military(self) -> dict:
        return self.call("get_military")

    def get_announcements(self, limit: int = 20) -> dict:
        return self.call("get_announcements", {"limit": limit})

    def get_map_area(self, x: int, y: int, z: int, w: int = 20, h: int = 20) -> dict:
        return self.call("get_map_area", {"x": x, "y": y, "z": z, "w": w, "h": h})
