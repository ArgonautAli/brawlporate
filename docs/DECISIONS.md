# Decisions

Only items with evidence in the repo are **established**. Anything else is a **proposal** or **unknown**. Do not treat proposals as chosen design.

## Established (evidence in files)

### Engine and project identity

- Godot 4.3 project, Forward Plus, `config_version=5`. Application name `"brawl"`.  
  Evidence: `project.godot` L9–16.

### How the game starts

- Main scene is `scenes/level/test.tscn`.  
  Evidence: `project.godot` L14.
- That scene instances `scenes/character/player.tscn`.  
  Evidence: `scenes/level/test.tscn` L3, L15–16.
- There is no gameplay autoload and no scripted scene change.  
  Evidence: no `[autoload]`; no `change_scene` / `instantiate` in `.gd` files.

### Input map

- Actions are `move_left` (A), `move_right` (D), `jump` (W), deadzone 0.5.  
  Evidence: `project.godot` L23–39.

### Player structure

- Player is a `CharacterBody2D` with `PlayerController`.  
  Evidence: `scenes/character/player.tscn` L48–49; `scripts/character/player_controller.gd` L1.
- Gravity and `move_and_slide` live on the body; horizontal speed and jump impulse live in states.  
  Evidence: `player_controller.gd` L22–28 vs movement/jump state `physics_process` / `enter`.
- FSM is a child `StateMachine` node; states are constructed in `_ready`, not placed in the `.tscn`.  
  Evidence: `player.tscn` L76–78; `player_controller.gd` L17–19; `state_machine.gd` L9–14.
- Initial state is whatever is first in the array: `PlayerIdleState`.  
  Evidence: `player_controller.gd` L18; `state_machine.gd` L14, L23.

### Presentation defaults in project files

- Default canvas texture filter is 0 (nearest).  
  Evidence: `project.godot` L43.
- Player SpriteFrames define `"idle"` (two 32×32 frames from `idle.png`) and `"jump"` (one frame from `jump.png`).  
  Evidence: `scenes/character/player.tscn` L10–42.
- Rest-pose arms use `r_hand1.png` and `l_hand1.png`; left arm `z_index = -1`.  
  Evidence: `player.tscn` L63–74.

### What is not in the product yet

- No combat/dash input, no attack scripts, no extra scenes, no tests.  
  Evidence: input map and file inventory.

### Editor plugin (not gameplay)

- GitPlugin is named as editor VCS with autoload on startup.  
  Evidence: `project.godot` L18–21; `addons/godot-git-plugin/git_plugin.gdextension`.
- Referenced native libraries are not in this tree.  
  Evidence: `.gdextension` L7–10 vs addon folder contents.

## Unknown (do not invent)

- Design intent of the name “brawl” vs current movement-only code.
- Whether Movement → Idle was forgotten or skipped because both states play `"idle"`.
- Whether air-W entering `PlayerJumpState` is an intentional fall hook.
- Numeric gravity (not in `project.godot`).
- WorldBoundaryShape2D default normal/distance and Camera2D `current` flag.
- Target jump height, max air speed feel, collider vs sprite alignment.
- Ownership of unused punch textures (future combat vs leftover art).
- Why Forward Plus was chosen for a 2D prototype.
- Any decision recorded before 2026-10-22 — none found in-repo.

## Proposals (not decisions)

These are recommendations from the 2026-10-22 audit. They are **not** established.

1. Playtest before changing movement (see `ROADMAP.md` P0).
2. Require `is_on_floor()` for jump press, or add an explicit fall state (P1).
3. Add Movement → Idle (or formally accept staying in movement) (P2).
4. Stop applying jump air X after landing `transition` (P3).
5. Parent `Camera2D` to the player or add follow logic (P5).
6. Default `StateMachine.is_logging` to false; remove `print("Enter jump")` (P4).
7. Share `ACCELERATION` / `MAX_SPEED` instead of duplicating them (E1).
8. Do not build combat until idle/move/jump and camera are settled (E3).
9. Keep documentation in `docs/` and update `CURRENT_STATUS.md` after each playtest.

When a proposal is actually chosen, move it to **Established** with a date and the file that implements it.
