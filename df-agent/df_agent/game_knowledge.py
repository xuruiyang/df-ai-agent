"""Dwarf Fortress mechanics reference data for the system prompt."""

WORKSHOP_TYPES = """
## Workshop Types
- Carpenter's Workshop: wooden furniture, bins, barrels, beds, chairs, tables, doors
- Mason's Workshop: stone furniture, blocks, doors, chairs, tables
- Craftsdwarf's Workshop: bone/shell/stone crafts, totems, instruments
- Mechanic's Workshop: mechanisms, traction benches
- Jeweler's Workshop: cut gems, encrust items
- Metalsmith's Forge: metal weapons, armor, furniture, tools, chains, cages
- Bowyer's Workshop: wooden crossbows
- Leather Works: leather armor, bags, quivers, backpacks
- Clothier's Shop: cloth/silk clothing, bags
- Loom: thread into cloth
- Butcher's Shop: butcher animals into meat, bones, skin
- Tanner's Shop: raw hides into leather
- Kitchen: cook lavish meals from ingredients
- Still/Brewery: brew drinks from plants (CRITICAL for dwarf happiness)
- Fishery: prepare raw fish
- Farmer's Workshop: process plants (mill, thresh), spin thread
- Quern/Millstone: mill plants into flour/dye/sugar
- Siege Workshop: catapults, ballistae
- Ashery: ash from wood, lye from ash
- Soap Maker's Workshop: soap from lye + tallow
"""

FURNACE_TYPES = """
## Furnace Types
- Wood Furnace: logs into charcoal (fuel for smelting)
- Smelter: ore into metal bars (needs fuel or magma)
- Glass Furnace: sand into glass items
- Kiln: clay into pottery, bricks
"""

PRODUCTION_CHAINS = """
## Key Production Chains
- **Drinks**: farm plants (plump helmets) -> Still -> brew drink (ESSENTIAL - dwarves need alcohol)
- **Metal**: mine ore -> Smelter (+ fuel) -> bars -> Metalsmith's Forge -> weapons/armor
- **Fuel**: chop wood -> Wood Furnace -> charcoal (or find magma for free smelting)
- **Food**: farm -> Kitchen -> prepared meals (or butcher animals)
- **Cloth**: shear animals -> spin thread (Farmer's) -> weave cloth (Loom) -> make clothes (Clothier's)
- **Leather**: butcher animal -> raw hide -> Tanner's -> leather -> Leather Works -> goods
- **Stone crafts**: mine stone -> Mason's/Craftsdwarf's -> furniture/crafts
- **Soap**: Wood Furnace -> ash -> Ashery -> lye + butcher -> tallow -> Soap Maker -> soap
"""

LABOR_TYPES = """
## Important Labor Types
- MINE: Mining (digging out stone/ore)
- CARPENTER: Carpentry (wooden items)
- MASON: Masonry (stone items)
- COOK: Cooking
- BREW: Brewing
- SMELT: Smelting ore
- FORGE_WEAPON/FORGE_ARMOR/FORGE_FURNITURE: Metalsmithing
- PLANT: Farming (planting/harvesting)
- FISH: Fishing
- HUNT: Hunting
- BUTCHER: Butchering
- TAN_HIDE: Tanning
- WEAVE: Weaving
- CUT_GEM: Gem cutting
- MECHANIC: Mechanics
- HAUL_STONE/HAUL_WOOD/HAUL_BODY/HAUL_FOOD/HAUL_REFUSE/HAUL_ITEM/HAUL_FURNITURE: Hauling
"""

COMMON_PROBLEMS = """
## Common Problems & Solutions
- **No booze**: Build a Still, farm plump helmets underground, brew them. Dwarves get unhappy without alcohol.
- **No food**: Build farm plots underground, grow plump helmets. Build Kitchen for meals.
- **Cave-in**: Dig supports before removing critical pillars. Don't channel above unsupported areas.
- **Flooding**: Build floodgates and levers. Channel water carefully.
- **Unhappy dwarves**: Ensure food, drink, bedrooms, dining room. Build temple, tavern.
- **No wood**: Trade for it, or embark near trees. Charcoal from wood furnace for fuel.
- **Goblin siege**: Build walls, raise drawbridge, train military squads with weapons/armor.
- **Strange mood**: Dwarf needs specific materials (check announcements). Provide workshop + materials.
"""

SPATIAL_GUIDE = """
## Coordinate System
- X axis: West (0) to East (max)
- Y axis: North (0) to South (max)
- Z axis: Lower numbers = deeper underground, higher = above ground
- Ground level is typically around z=100-140 depending on embark
- To dig underground: designate dig at lower z-levels
"""

ALL_KNOWLEDGE = (
    WORKSHOP_TYPES
    + FURNACE_TYPES
    + PRODUCTION_CHAINS
    + LABOR_TYPES
    + COMMON_PROBLEMS
    + SPATIAL_GUIDE
)
