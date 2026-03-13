# Dwarf Fortress AI Agent — Skill Guide

## What This Is
A file-based IPC bridge between Claude Code and a running Dwarf Fortress game via DFHack. You read game state and execute commands by running a Python CLI that exchanges JSON files with a Lua script inside the game.

## Quick Start (For the Agent)

### Test Connection
```bash
python3 df-agent/df_agent/bridge_cli.py ping
```
If this returns `{"status": "ok"}`, the game is running and the bridge is active.
If it times out, the game may be paused, at a menu, or not running.

### Read Game State
```bash
# Overview: population, food, drink, season, announcements
python3 df-agent/df_agent/bridge_cli.py get_fortress_overview

# List dwarves (filter: citizens/military/animals/visitors/all)
python3 df-agent/df_agent/bridge_cli.py get_units '{"filter":"citizens"}'

# Single dwarf details (skills, labors)
python3 df-agent/df_agent/bridge_cli.py get_unit_detail '{"id":5085}'

# Resources: food, drink, wood, stone, bars, cloth, leather, weapons, armor, ammo
python3 df-agent/df_agent/bridge_cli.py get_resources

# Buildings (optional type filter: Workshop, Furnace, Chair, etc.)
python3 df-agent/df_agent/bridge_cli.py get_buildings
python3 df-agent/df_agent/bridge_cli.py get_buildings '{"type":"Workshop"}'

# Workshops with current jobs
python3 df-agent/df_agent/bridge_cli.py get_workshops

# Map tiles (max 50x50)
python3 df-agent/df_agent/bridge_cli.py get_map_area '{"x":95,"y":95,"z":177,"w":15,"h":15}'

# Manager orders, military, announcements
python3 df-agent/df_agent/bridge_cli.py get_manager_orders
python3 df-agent/df_agent/bridge_cli.py get_military
python3 df-agent/df_agent/bridge_cli.py get_announcements
```

### Modify Game State
```bash
# Designate digging (dig_type: Default, DownStair, UpDownStair, Channel, Ramp, UpStair)
python3 df-agent/df_agent/bridge_cli.py designate_dig '{"x":100,"y":100,"z":177,"w":5,"h":5,"dig_type":"Default"}'

# Instant dig (DFHack cheat — skips dwarf labor)
python3 df-agent/df_agent/bridge_cli.py run_dfhack_command '{"command":"dig-now"}'

# Assign labor to a dwarf
python3 df-agent/df_agent/bridge_cli.py assign_labor '{"unit_id":5085,"labor":"MINE","enable":true}'

# Queue manager production order
python3 df-agent/df_agent/bridge_cli.py add_manager_order '{"job_type":"BrewDrink","quantity":5}'

# Pause/unpause
python3 df-agent/df_agent/bridge_cli.py pause
python3 df-agent/df_agent/bridge_cli.py unpause

# Run any DFHack command
python3 df-agent/df_agent/bridge_cli.py run_dfhack_command '{"command":"prospect"}'
```

### Write Helper Scripts for Complex Lua
Single-line Lua via `run_dfhack_command` often fails to parse. Instead, write a `.lua` file to `df_osx/hack/scripts/` and call it by name:
```bash
# Write script
cat > df_osx/hack/scripts/my-helper.lua << 'EOF'
-- your lua code here
print("hello from dfhack")
EOF

# Run it
python3 df-agent/df_agent/bridge_cli.py run_dfhack_command '{"command":"my-helper"}'
```

## Setup Guide (For New Users)

### Prerequisites
- Dwarf Fortress with DFHack (the `df_osx/` directory in this repo has both)
- Python 3.9+
- Claude Code (or any Claude-powered agent that can run shell commands)

### Step 1: Install the Bridge Script
Copy `df_osx/hack/scripts/df-agent-bridge.lua` into your DFHack scripts folder:
```
<your DF folder>/hack/scripts/df-agent-bridge.lua
```

### Step 2: Auto-Start the Bridge
Add this line to `<your DF folder>/dfhack-config/init/onMapLoad.init`:
```
df-agent-bridge start
```

### Step 3: Install Python Dependencies
```bash
cd df-agent
pip install anthropic prompt-toolkit rich
```

### Step 4: Play
1. Start Dwarf Fortress with DFHack:
   ```bash
   cd <your DF folder>
   ./dfhack          # Linux/Mac
   # or: arch -x86_64 ./dfhack   # Apple Silicon Mac
   ```
2. Load or start a fortress in the game
3. In a separate terminal, start Claude Code in this project directory and ask it to help you play

### Disabling df-ai
If the `df-ai` plugin is auto-playing the game, disable it by commenting out `enable df-ai` in:
- `dfhack-config/init/dfhack.init`
- `dfhack.init` (in the DF root folder)

## How the Bridge Works

```
Claude Code                        Dwarf Fortress + DFHack
    |                                      |
    |  write request.json                  |
    |----> df_osx/df-agent-ipc/ <----------|  Lua polls every frame
    |                                      |  reads request, executes,
    |  read response.json                  |  writes response
    |<---- df_osx/df-agent-ipc/ <----------|
```

- IPC directory: `df_osx/df-agent-ipc/`
- Lock file: `df_osx/df-agent-ipc/ready.lock` (exists = bridge running)
- Game must be UNPAUSED for the bridge to process (it runs on game frames)
- Response encoding may contain non-UTF-8 chars (DF dwarf names) — client handles with errors="replace"

## Visualizing the Map
Pipe map data through a Python formatter:
```bash
python3 df-agent/df_agent/bridge_cli.py get_map_area '{"x":91,"y":95,"z":177,"w":25,"h":15}' | python3 -c "
import json,sys
data=json.load(sys.stdin)
for row in data['result']['tiles']:
    line=''
    for t in row:
        s=t['shape']
        if s=='WALL': line+='#'
        elif 'STAIR' in s: line+='X'
        elif s=='FLOOR': line+='.'
        elif s=='RAMP': line+='>'
        else: line+=' '
    print(line)
"
```

## Key Dwarf Fortress Knowledge

### First Priorities on Fresh Embark
1. Dig underground (stair down + rooms)
2. Build Still (brew drinks — dwarves need alcohol!)
3. Build Carpenter's Workshop (beds, barrels, bins)
4. Set up underground farm plots (plump helmets)
5. Build bedrooms for each dwarf

### Resource Thresholds
- Drink < 20: URGENT — brew immediately
- Food < 20: Set up farms + kitchen
- Wood < 5: Chop trees or trade

### Common Labors
MINE, CARPENTER, MASON, COOK, BREW, PLANT, SMELT, FORGE_WEAPON, FORGE_ARMOR, BUTCHER, TAN_HIDE, WEAVE, CUT_GEM, MECHANIC, HAUL_STONE, HAUL_WOOD, HAUL_FOOD

### Coordinate System
- X: West(0) → East(max)
- Y: North(0) → South(max)
- Z: Down(low) → Up(high)
- `<` key = go up z-level, `>` key = go down z-level

## DFHack API Compatibility Notes (v0.47.05)
- `dfhack.units.getReadableName()` does NOT exist — use `dfhack.TranslateName(dfhack.units.getVisibleName(unit))`
- `dfhack.units.isAnimal()` does NOT exist — use `unit.race ~= df.global.ui.race_id`
- `dfhack.items.getStackSize()` does NOT exist — use `item.stack_size` field directly
- Lua one-liners via `run_dfhack_command` often fail — write helper scripts instead

## Platform Notes
- macOS Apple Silicon requires: `arch -x86_64 ./dfhack`
- `dfhack-run` often hangs — prefer the file-based bridge
- Zombie DF processes (UE state) persist until reboot
- If port 5000 is blocked by zombies, change port in `dfhack-config/remote-server.json`

## File Locations
- Bridge script: `df_osx/hack/scripts/df-agent-bridge.lua`
- Python CLI: `df-agent/df_agent/bridge_cli.py`
- Python package: `df-agent/df_agent/`
- IPC directory: `df_osx/df-agent-ipc/`
- Auto-start config: `df_osx/dfhack-config/init/onMapLoad.init`
