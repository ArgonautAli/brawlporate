# Current status

**Snapshot date:** 2026-10-22  
**Verification method:** Source-file inspection only. Godot Editor was not launched; no playtest, no CI, no recorded prior test run.

## Playable scope (as configured)

The engine is set to run `scenes/level/test.tscn`, which instances one `scenes/character/player.tscn`. Code exists for:

- Sampling A/D as horizontal input
- Gravity + `move_and_slide()` on the player body
- Idle / movement / jump **states**
- Flip of body and arm sprites when horizontal input is nonzero
- Idle (2-frame) and jump (1-frame) `SpriteFrames`
- A static `Camera2D` at zoom `(3, 3)`
- An infinite-style floor via default `WorldBoundaryShape2D`

Whether that loop is **actually playable** (lands on the floor, jump leaves the ground, sprites load) is **unverified**.

## Implemented (code and scenes present)

| Item | Where | Runtime |
| --- | --- | --- |
| Main scene wiring | `project.godot` L14; `scenes/level/test.tscn` | Unverified |
| Player scene + controller | `scenes/character/player.tscn`; `scripts/character/player_controller.gd` | Unverified |
| State machine node | `scripts/state/state_machine.gd`; child `StateMachine` | Unverified |
| Idle, movement, jump states | `scripts/character/player_*_state.gd` | Unverified |
| Input actions A / D / W | `project.godot` L23–39 | Unverified |
| Nearest-neighbor textures | `project.godot` L43 | Unverified |
| Idle + jump animations in SpriteFrames | `scenes/character/player.tscn` L22–42 | Unverified |
| Rest-pose arm sprites | `r_hand1.png`, `l_hand1.png` on markers | Unverified |

## Partially implemented

| Item | What exists | What is missing |
| --- | --- | --- |
| Ground movement | Speed integration in `PlayerMovementState` | No walk animation; no transition back to idle when input is 0 |
| Jump | Impulse and air X in `PlayerJumpState` | No floor check on press; no facing in air; unused `MAX_JUMP_FORCE`; debug `print` |
| Facing | Flip + `r_arm.position.x` | `l_arm` X never updated; `_facing` never read |
| Level | Player + boundary + camera | Camera does not follow; no walls, platforms, or art |
| Character art | Idle, jump, rest hands in the player scene | Jab/hook/uppercut imports are unused |

## Known issues (from code; not play-confirmed)

These are **likely** defects or incomplete FSM behavior. Do not treat them as crash-reproduced bugs.

1. **No Movement → Idle.** `PlayerMovementState` never transitions to idle. Stopping still decelerates in movement while playing `"idle"`.
2. **Jump from air.** Idle/movement call `transition("PlayerJumpState")` on W with no `is_on_floor()` check. Impulse applies only if on floor at `enter`.
3. **Jump land still applies air X** in the same `physics_process` after `transition()`.
4. **Idle does not zero `velocity.x`.**
5. **Parent physics vs child FSM:** `PlayerController` gravity/`move_and_slide` runs on the body; state X/jump run on the child `StateMachine` (and jump press is in `_process`). Frame timing is unverified.
6. **Static camera** — walking in X will leave the view if movement works.
7. **`print("Enter jump")` and `is_logging = true`** left on.
8. **Empty `arms` node**; `PlayerState.r_arm` / `l_arm` never assigned.

## Missing features (absent from project files)

Combat, dash, enemies, health, UI, audio, pause, save, menus, extra levels, walk animation, gamepad/arrows, autoloads, scene changes.

Punch textures exist only as `.import` sidecars (`assets/character/arms/**/jab1.png`, `*hook1.png`, `*uppercut1.png`) and are not referenced by any `.tscn` or `.gd`.

## Test / verification status

| Check | Status |
| --- | --- |
| Source audit of `project.godot`, both `.tscn`, all seven `.gd` | Done 2026-10-22 |
| Play `test.tscn` in Godot 4.3 | **Not done** |
| Confirm PNG files load | **Not done** (editor had `jump.png` open in a later session; not used as a full asset inventory) |
| Git plugin editor load | **Not done**; native libs missing from `addons/godot-git-plugin/` |
| Automated tests | **None** in the repo |

## Blockers

- **Runtime unknown.** Next code changes should follow a playtest, or they may “fix” behavior that already feels acceptable.
- **Git plugin binaries** missing — editor VCS only, not a game blocker.
- **Texture completeness** — if any referenced PNG is absent on disk, sprites will break. Full disk inventory was not completed after the first search.

## Last verified state

- **Verified:** File contents listed in [ARCHITECTURE.md](ARCHITECTURE.md) and [GAMEPLAY_SYSTEMS.md](GAMEPLAY_SYSTEMS.md) as of 2026-10-22.
- **Not verified:** Any in-game result (jump height, landing, collider vs sprite, camera, gravity value).

## Recommended next task

**Playtest `scenes/level/test.tscn` in Godot 4.3** using the checklist in [ROADMAP.md](ROADMAP.md) task P0. Record what actually happens (especially landing, W-jump, stop-after-walk, and Output log). Do not start combat or new states until that snapshot exists.
