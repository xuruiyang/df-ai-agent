"""Tool definitions for Claude API tool-use, mapping to bridge methods."""

# Observation tools (read-only)

OBSERVATION_TOOLS = [
    {
        "name": "get_fortress_overview",
        "description": "Get a high-level overview of the fortress: population count, food/drink stocks, current date/season, and recent announcements. Use this first to understand the overall state.",
        "input_schema": {
            "type": "object",
            "properties": {},
        },
    },
    {
        "name": "get_units",
        "description": "List units (dwarves, animals, visitors) in the fortress. Returns name, profession, current job, and position for each unit.",
        "input_schema": {
            "type": "object",
            "properties": {
                "filter": {
                    "type": "string",
                    "enum": ["citizens", "military", "animals", "visitors", "all"],
                    "description": "Category of units to list. Default: citizens",
                },
                "limit": {
                    "type": "integer",
                    "description": "Max number of units to return. Default: 50",
                },
            },
        },
    },
    {
        "name": "get_unit_detail",
        "description": "Get detailed information about a specific unit: skills, labors, inventory, and attributes.",
        "input_schema": {
            "type": "object",
            "properties": {
                "id": {
                    "type": "integer",
                    "description": "The unit ID to look up",
                },
            },
            "required": ["id"],
        },
    },
    {
        "name": "get_buildings",
        "description": "List buildings in the fortress. Optionally filter by type (Workshop, Furnace, Chair, Table, Door, etc.).",
        "input_schema": {
            "type": "object",
            "properties": {
                "type": {
                    "type": "string",
                    "description": "Building type to filter by (e.g., 'Workshop', 'Furnace', 'Chair'). Omit for all.",
                },
                "limit": {
                    "type": "integer",
                    "description": "Max buildings to return. Default: 50",
                },
            },
        },
    },
    {
        "name": "get_map_area",
        "description": "Get tile data for a rectangular area of the map. Returns tile shape and material for each position. Max 50x50.",
        "input_schema": {
            "type": "object",
            "properties": {
                "x": {"type": "integer", "description": "Left edge X coordinate"},
                "y": {"type": "integer", "description": "Top edge Y coordinate"},
                "z": {"type": "integer", "description": "Z-level"},
                "w": {
                    "type": "integer",
                    "description": "Width (max 50). Default: 20",
                },
                "h": {
                    "type": "integer",
                    "description": "Height (max 50). Default: 20",
                },
            },
            "required": ["x", "y", "z"],
        },
    },
    {
        "name": "get_resources",
        "description": "Get summarized item counts by category: food, drink, wood, stone, bars, cloth, leather, weapons, armor, ammo.",
        "input_schema": {
            "type": "object",
            "properties": {},
        },
    },
    {
        "name": "get_manager_orders",
        "description": "Get the current manager production order queue.",
        "input_schema": {
            "type": "object",
            "properties": {},
        },
    },
    {
        "name": "get_workshops",
        "description": "List all workshops and furnaces with their current jobs.",
        "input_schema": {
            "type": "object",
            "properties": {
                "limit": {
                    "type": "integer",
                    "description": "Max workshops to return. Default: 50",
                },
            },
        },
    },
    {
        "name": "get_military",
        "description": "Get military squads, their members, and active orders.",
        "input_schema": {
            "type": "object",
            "properties": {},
        },
    },
    {
        "name": "get_announcements",
        "description": "Get recent game announcements and events.",
        "input_schema": {
            "type": "object",
            "properties": {
                "limit": {
                    "type": "integer",
                    "description": "Number of recent announcements. Default: 20",
                },
            },
        },
    },
]

# Action tools (modify game state)

ACTION_TOOLS = [
    {
        "name": "designate_dig",
        "description": "Mark tiles for mining/digging. Specify a rectangular area and dig type.",
        "input_schema": {
            "type": "object",
            "properties": {
                "x": {"type": "integer", "description": "Left X coordinate (or x1)"},
                "y": {"type": "integer", "description": "Top Y coordinate (or y1)"},
                "z": {"type": "integer", "description": "Z-level to dig on"},
                "w": {
                    "type": "integer",
                    "description": "Width of area. Default: 1",
                },
                "h": {
                    "type": "integer",
                    "description": "Height of area. Default: 1",
                },
                "dig_type": {
                    "type": "string",
                    "enum": [
                        "Default",
                        "UpDownStair",
                        "Channel",
                        "Ramp",
                        "UpStair",
                        "DownStair",
                    ],
                    "description": "Type of digging. Default: 'Default' (normal dig)",
                },
            },
            "required": ["x", "y", "z"],
        },
    },
    {
        "name": "place_building",
        "description": "Place a building (workshop, furnace, furniture) at coordinates. Uses DFHack building placement.",
        "input_schema": {
            "type": "object",
            "properties": {
                "type": {
                    "type": "string",
                    "description": "Building type string (e.g., 'Carpenter', 'Mason', 'Still', 'Smelter', 'Chair', 'Table', 'Bed', 'Door')",
                },
                "x": {"type": "integer", "description": "X coordinate"},
                "y": {"type": "integer", "description": "Y coordinate"},
                "z": {"type": "integer", "description": "Z-level"},
            },
            "required": ["type", "x", "y", "z"],
        },
    },
    {
        "name": "remove_building",
        "description": "Deconstruct/remove a building by its ID.",
        "input_schema": {
            "type": "object",
            "properties": {
                "id": {
                    "type": "integer",
                    "description": "Building ID to remove",
                },
            },
            "required": ["id"],
        },
    },
    {
        "name": "assign_labor",
        "description": "Enable or disable a labor for a specific dwarf.",
        "input_schema": {
            "type": "object",
            "properties": {
                "unit_id": {
                    "type": "integer",
                    "description": "The unit/dwarf ID",
                },
                "labor": {
                    "type": "string",
                    "description": "Labor name (e.g., 'MINE', 'CARPENTER', 'MASON', 'COOK', 'BREW', 'PLANT', 'HAUL_STONE')",
                },
                "enable": {
                    "type": "boolean",
                    "description": "True to enable, false to disable. Default: true",
                },
            },
            "required": ["unit_id", "labor"],
        },
    },
    {
        "name": "add_manager_order",
        "description": "Queue a production order in the manager. Specify job type and quantity.",
        "input_schema": {
            "type": "object",
            "properties": {
                "job_type": {
                    "type": "string",
                    "description": "Job type (e.g., 'BrewDrink', 'ConstructBed', 'SmeltOre', 'MakeCharcoal', 'PrepareMeal')",
                },
                "quantity": {
                    "type": "integer",
                    "description": "Number to produce. Default: 1",
                },
            },
            "required": ["job_type"],
        },
    },
    {
        "name": "create_stockpile",
        "description": "Create a stockpile zone with the specified category.",
        "input_schema": {
            "type": "object",
            "properties": {
                "category": {
                    "type": "string",
                    "description": "Stockpile category (e.g., 'food', 'drink', 'wood', 'stone', 'weapons', 'armor')",
                },
            },
        },
    },
    {
        "name": "create_activity_zone",
        "description": "Create an activity zone (meeting area, hospital, pasture).",
        "input_schema": {
            "type": "object",
            "properties": {
                "zone_type": {
                    "type": "string",
                    "description": "Zone type: 'meeting', 'hospital', 'pasture'",
                },
            },
        },
    },
    {
        "name": "run_dfhack_command",
        "description": "Run any DFHack console command directly. Use as an escape hatch for operations not covered by other tools.",
        "input_schema": {
            "type": "object",
            "properties": {
                "command": {
                    "type": "string",
                    "description": "The DFHack command string to execute",
                },
            },
            "required": ["command"],
        },
    },
]

ALL_TOOLS = OBSERVATION_TOOLS + ACTION_TOOLS

# Set of tool names for quick lookup
OBSERVATION_TOOL_NAMES = {t["name"] for t in OBSERVATION_TOOLS}
ACTION_TOOL_NAMES = {t["name"] for t in ACTION_TOOLS}
