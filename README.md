# Godot 2D RPG — Technical Showcase

**Godot 4.7 · GDScript · Gameplay systems · Interface design**

Selected code and screenshots from Dean Jefferies' ongoing 2D action RPG. The project combines connected platforming environments, enemy encounters, persistent equipment and six skillbooks. This repository is a curated technical showcase, not a complete game distribution.

![The Hollow Pontiff casting Heaven's Divide](screenshots/boss-heavens-divide.png)

## Explore the project

| Area | What to inspect |
|---|---|
| [Maps and monsters](#maps-and-monsters) | World presentation and enemy encounters |
| [Combat in action](#combat-in-action) | Boss casting, Assassin ultimate and Lightning strike |
| [Skillbook interface](#skillbook-interface) | Six skill categories, ranks and point investment |
| [Selected code](#selected-code) | Item data, targeting and a timed enemy attack |
| [How to use this repository](#how-to-use-this-repository) | Navigate the gallery and source extracts |

## Maps and monsters

### Ruined Spire

![Ruined Spire and crystal enemies](screenshots/current-map-one.png)

### Main town

The town brings together NPCs, storage, portals and the skillbook interaction within a connected platform layout.

![Main town](screenshots/current-town.png)

### Map five

![Map five](screenshots/current-map-five.png)

## Combat in action

### The Hollow Pontiff — Heaven's Divide

The current courtyard encounter includes the boss's casting animation, a sustained beam, timed hazards and a dedicated health display.

![The Hollow Pontiff casting Heaven's Divide](screenshots/boss-heavens-divide.png)

### Celestial bells

Summoned bells mark areas of the arena with expanding warning rings.

![The Hollow Pontiff summoning celestial bells](screenshots/boss-bells.png)

### Assassin ultimate — Thousandfold Blades

The Assassin book's channelled ultimate creates a rotating blade vortex and outward blade waves.

![Thousandfold Blades in action](screenshots/assassin-thousandfold.png)

### Lightning — Thunderbolt

A targeted lightning strike connects the sky effect to an enemy, with an impact effect at the target.

![Lightning strike hitting an enemy](screenshots/lightning-strike.png)

## Skillbook interface

The current catalog contains **Basic, Blood, Lightning, Assassin, Barrier and Celestial**. All six books are unlocked in this demonstration profile. Normal progression controls which books appear. The tab strip scrolls, so not all six labels fit at once.

### Lightning — skill cards and investment controls
![Lightning book](screenshots/current-lightning.png)

### Basic and Blood
![Basic book](screenshots/current-basic.png)
![Blood book](screenshots/current-blood.png)

### Assassin and Barrier
![Assassin book](screenshots/current-assassin.png)
![Barrier book](screenshots/current-barrier.png)

### Celestial
![Celestial book](screenshots/current-celestial.png)

## Selected code

| File | Responsibility | Concepts |
|---|---|---|
| [ItemInstance.gd](code/ItemInstance.gd) | Preserve item identity and convert state to/from dictionaries | Serialization, defaults, deep copying |
| [combat-EnemyRegistry.gd](code/combat-EnemyRegistry.gd) | Register enemies, remove invalid references and select targets | Object lifecycle, collections, spatial queries |
| [FoxDash.gd](code/FoxDash.gd) | Manage attack windup, movement, recovery and cooldown | Timing, collision checks, state transitions |

These extracts retain their original game dependencies. `FoxDash` depends on its parent character and sprite assets; the registry integrates with world events; item instances are consumed by the wider inventory system. They cannot be run independently from this repository.

## How to use this repository

1. Read the gallery above, or open `screenshots/` to inspect individual captures.
2. Open `code/` and choose a system from the table.
3. Read the system overview below for context before inspecting its methods.

### Item persistence

An item has a unique identifier separate from its definition. Its upgrade level, appearance and attributes can be serialized without creating a new identity during transfers. `from_dict` supplies defaults for missing values.

### Enemy targeting

Enemies register with a shared registry. Invalid references are cleaned up before queries. Target selection filters unsuitable nodes and searches within a range, keeping targeting concerns in one place.

### Attack timing

The dash separates windup, travel and recovery. It checks available floor and walls, applies movement through the existing character collider and tracks already-hit targets. Cooldown prevents immediate repeats.

## Capture details

Captured in Godot from the current source on 6 November 2026. These staged views hide the unfinished player and companion, pause enemy animation frames, omit overlapping or clipped enemies, and align health bars with visible sprites. A separate camera frames the boss. Combat effects are rendered by the current game systems.

## Status and development

**Work in progress.** Movement, character presentation and balance are still under development; no video or finished-release claim is included. The broader project is developed with AI assistance. This gallery documents project systems and integration, not sole authorship of every code line or visual asset.

The complete local project uses Godot 4.7.1. This showcase intentionally excludes the full asset library, save data, backups and editor caches. Its selected source extracts have not been tested as standalone applications.



