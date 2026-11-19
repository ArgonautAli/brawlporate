# brawl

Godot 4.3 2D prototype. Application name in `project.godot` is `"brawl"`. The repo contains a single test level, one player character, and a small code-driven state machine for idle, ground movement, and jump. There is no combat, dash, UI, audio, or second scene in the project files.

This folder is the developer handbook for returning to the prototype. Paths below are from the **repository root**.

## Godot version

- **Target:** Godot **4.3** (`config/features` includes `"4.3"` and `"Forward Plus"` in `project.godot` lines 15–16).
- **Project format:** `config_version=5` (`project.godot` line 9).
- Renderer is Forward Plus. Window size, stretch, and physics gravity are **not** overridden in `project.godot` (engine defaults; see [DECISIONS.md](DECISIONS.md)).

## Prerequisites

- Godot **4.3** (same minor version as `config/features`; other 4.x versions are unverified).
- The native Git editor plugin is referenced under `addons/godot-git-plugin/` but its platform binaries are **not** in the tree. Version control in the editor may fail; it is not required to run the game.

## Setup

1. Clone or open this repository.
2. Confirm character textures exist next to their `.import` sidecars under `assets/character/` (`idle.png`, `jump.png`, `arms/left/l_hand1.png`, `arms/right/r_hand1.png`). Import files name those sources; if a PNG is missing, Godot will fail to show that sprite.
3. Open the project folder in Godot 4.3 (open `project.godot`).
4. Let Godot import assets. `.godot/` is gitignored and is created locally.

## Launch

- **Configured main scene:** `scenes/level/test.tscn` (`project.godot` line 14).
- Press **F5** / Run Project, or open `scenes/level/test.tscn` and run the current scene.
- That level instances `scenes/character/player.tscn`. There is no boot menu and no `change_scene` in scripts.

Runtime behavior (landing, jump height, camera framing, missing textures) has **not** been playtested in this documentation pass. Treat launch as unverified until you run it. See [CURRENT_STATUS.md](CURRENT_STATUS.md).

## Controls

Mapped in `project.godot` lines 23–39. Keyboard only; no arrow keys or gamepad.

| Action | Physical key | Used by |
| --- | --- | --- |
| `move_left` | A | Horizontal input on the player |
| `move_right` | D | Horizontal input on the player |
| `jump` | W | Idle and movement states only |

Dash and combat have **no** input actions and **no** gameplay code.

## Docs

| Doc | Contents |
| --- | --- |
| [CURRENT_STATUS.md](CURRENT_STATUS.md) | Dated snapshot, playable scope, bugs, next task |
| [ARCHITECTURE.md](ARCHITECTURE.md) | Scenes, scripts, FSM, dependencies |
| [GAMEPLAY_SYSTEMS.md](GAMEPLAY_SYSTEMS.md) | Movement/jump mechanics and constants |
| [ROADMAP.md](ROADMAP.md) | Prioritized issues vs enhancements |
| [DECISIONS.md](DECISIONS.md) | Evidence-backed constraints vs proposals |
