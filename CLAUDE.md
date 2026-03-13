# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

df-ai is a DFHack plugin for Dwarf Fortress that makes the game play itself autonomously. It handles embarking, fortress planning, population management, resource management, trading, and military operations. Written in C++, it builds as a shared library loaded by DFHack.

## Build System

This is a CMake-based DFHack plugin. It must be built within the DFHack build tree (not standalone):

```bash
# Clone into DFHack's plugins directory, then build via DFHack's CMake
# Requires: CMake 3.11+, Boost 1.67+ (context library), jsoncpp, lua, zlib, SDL
```

Compiler flags: `-Wall -Wextra -Werror -Wno-unused-parameter` (GCC), `/W3 /WX` (MSVC). All warnings are errors.

## JSON Schema Validation

Blueprint/room JSON files are validated using ajv-cli:

```bash
npm install ajv-cli
node_modules/.bin/ajv compile -s "schemas/*.json" -r "schemas/*.json"
node_modules/.bin/ajv test --valid --errors=text --all-errors -s schemas/plan.json -r "schemas/*.json" -d "plans/*.json" > /dev/null
node_modules/.bin/ajv test --valid --errors=text --all-errors -s schemas/room-instance.json -r "schemas/*.json" -d "rooms/instances/*/*.json" > /dev/null
node_modules/.bin/ajv test --valid --errors=text --all-errors -s schemas/room-template.json -r "schemas/*.json" -d "rooms/templates/*/*.json" > /dev/null
```

## Testing

In-game test via DFHack's Lua console: `test/main.lua` runs `ai validate`.

## Architecture

The central `AI` class (`ai.h`/`ai.cpp`) owns and coordinates five major subsystems:

- **Population** (`population.h`, `population*.cpp`) — Manages dwarves: labor assignments, noble appointments, military squads, occupations, pets, justice, and death handling.
- **Plan** (`plan.h`, `plan*.cpp`) — Fortress layout planning: room placement, construction task management, blueprint setup, cistern/water systems, smoothing, and room assignment. Uses JSON blueprints from `plans/` and `rooms/` directories.
- **Stocks** (`stocks.h`, `stocks*.cpp`) — Resource/inventory management: detecting needs, queuing manager orders, farming, forging, equipment, and trade goods.
- **Camera** (`camera.h`, `camera.cpp`) — Follows interesting events in the fortress.
- **Trade** (`trade.h`, `trade_*.cpp`) — Handles trade depot interactions and caravan negotiations.

Supporting systems:
- **Embark** (`embark.h`, `embark.cpp`) — Automated world generation and embark site selection.
- **Blueprint** (`blueprint.h`, `blueprint*.cpp`) — Parses and merges JSON room/furniture blueprints from `rooms/` (templates and instances) and `plans/`.
- **EventManager** (`event_manager.h`, `event_manager.cpp`) — Tick-based callback system for scheduling periodic AI updates.
- **ExclusiveCallback** (`exclusive_callback.h`, `exclusive_callback.cpp`) — Coroutine-based UI automation using Boost.Context for interacting with DF viewscreens.
- **Config** (`config.h`, `config.cpp`) — Runtime settings loaded from `dfhack-config/df-ai.json`.

The plugin entry point is `df-ai.cpp`, which registers with DFHack via `DFHACK_PLUGIN("df-ai")` and manages the global `dwarfAI` singleton. `hooks.cpp` patches DF viewscreens for UI automation.

## Key Conventions

- The plugin interacts with DF internals through DFHack's `df::` namespace (generated structure bindings).
- JSON is handled via jsoncpp (`json/json.h`).
- `apply.h` provides a template utility for applying JSON-driven configuration to structured data.
- `weblegends.cpp` exposes AI status through the weblegends HTTP interface (submodule in `thirdparty/weblegends`).
- Room/plan definitions use JSON schemas in `schemas/` — any changes to blueprint JSON must conform to these schemas.
