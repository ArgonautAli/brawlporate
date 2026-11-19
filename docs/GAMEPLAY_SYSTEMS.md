# Gameplay systems

Only systems that exist in code or scenes. Runtime feel is **unverified** unless noted. Dash, combat, health, and enemies are **not implemented**.

## Level

`scenes/level/test.tscn`:

- Player spawn `(197, 370)`
- `StaticBody2D` at `(178, 420)` with a default `WorldBoundaryShape2D` (no custom properties in the file)
- `Camera2D` at `(195, 363)`, zoom `(3, 3)`, **not** parented to the player

**Assumption (unverified):** the boundary acts as a floor the capsule can stand on. **Fact:** there are no walls or platforms in the scene.

## Shared body loop

Every physics frame, `PlayerController` (`scripts/character/player_controller.gd` L22–28):

1. `horizontal_input = strength(move_right) - strength(move_left)`
2. If `not is_on_floor()`: `velocity.y += _gravity * delta`
3. `move_and_slide()`

`_gravity` comes from `ProjectSettings.get_setting("physics/2d/default_gravity")` (L8). Value is **not** in `project.godot` (**unverified**).

Horizontal speed is **not** set on the controller. Idle does not write `velocity`. Movement and jump write `velocity.x` with **different** formulas.

## Inputs

| Action | Key | Consumers |
| --- | --- | --- |
| `move_left` | A | Controller → `horizontal_input` |
| `move_right` | D | Controller → `horizontal_input` |
| `jump` | W | Idle and movement `process` via `is_action_just_pressed` |

No dash or attack actions.

## Facing

`handle_facing()` (`player_controller.gd` L31–50), called from idle and movement `process` only:

- Input &lt; 0: flip all three sprites, `r_arm.position.x = 2`, `_facing = LEFT`
- Input &gt; 0: unflip, `r_arm.position.x = -2`, `_facing = RIGHT`
- Input == 0: no change

`_facing` is never read. `l_arm.position` is never updated. Jump does not call `handle_facing`. **Unverified:** whether the ±2 X swap looks correct.

## Idle — `PlayerIdleState`

`scripts/character/player_idle_state.gd`

| | |
| --- | --- |
| Status | Partially implemented |
| Enter | Initial state; also from jump land when air `input == 0` |
| `process` | `play("idle")`; W → `"PlayerJumpState"`; `handle_facing()` (L8–13) |
| `physics_process` | If `horizontal_input != 0` → `PlayerMovementState` (L15–17) |
| Velocity | Not written |

## Ground movement — `PlayerMovementState`

`scripts/character/player_movement_state.gd`

| Constant | Value | Used |
| --- | --- | --- |
| `ACCELERATION` | 20.0 | `move_toward` step (L5, L20–23) |
| `MAX_SPEED` | 150.0 | `target_speed = horizontal_input * MAX_SPEED` (L6, L19) |

| | |
| --- | --- |
| Status | Partially implemented |
| `process` | `play("idle")` — **no walk clip**; W → jump; `handle_facing()` (L11–16) |
| `physics_process` | `velocity.x` toward target at 20 per physics tick (L18–24) |
| Exit to idle | **Missing** |

Releasing A/D stays in this state (decelerate toward 0, still `"idle"` animation). Whether that feels like standing still is **unverified**.

## Jump — `PlayerJumpState`

`scripts/character/player_jump_state.gd`

| Constant | Value | Used |
| --- | --- | --- |
| `JUMP_FORCE` | 350.0 | `velocity.y = -JUMP_FORCE` if on floor in `enter` (L5, L20–21) |
| `MAX_JUMP_FORCE` | 2000.0 | **Unused** (L6) |
| `ACCELERATION` | 20.0 | Air: `input = horizontal_input * ACCELERATION` (L8, L31) |
| `MAX_SPEED` | 150.0 | Clamp `velocity.x` (L9, L46) |
| `STOP_FORCE` | 5.0 | Decel when `abs(input) < ACCELERATION * 0.2` (L10, L41–42) |

| | |
| --- | --- |
| Status | Partially implemented |
| `enter` | `print("Enter jump")`; impulse if `is_on_floor()`; `is_jumping = true` (L18–22) |
| `exit` | `is_jumping = false` (L24–25) |
| `process` | `play("jump")` (L27–28) |
| Land | `is_on_floor() and is_jumping` → idle if `input == 0` else movement (L33–37). Here `input` is `horizontal_input * 20`, so idle iff horizontal input is 0. |
| After `transition` | Same function still applies air X (L41–46) |

Jump **press** is not gated on floor (idle L10–11, movement L13–14). Air W still enters this state; impulse is skipped if not on floor. That is an informal fall path, not a dedicated fall state.

Jump height, one-frame floor stick, and air control feel are **unverified**.

## Collision / sprite (layout only)

- Sprite position `(0, -16)`, 32×32 atlas frames (`player.tscn` L10–20, L53–54).
- Capsule radius 4, height 18, position `(-1, -20)` (L44–46, L59–61).

Whether the collider matches the art (float/sink) is **unverified**.

## Animation

SpriteFrames (`player.tscn` L22–42): `"idle"` two frames at speed 5, loop; `"jump"` one frame at speed 5, loop. Current animation property is `"jump"`; `autoplay = "idle"`. What plays on the first frame is **unverified**.

## Assumptions to keep explicit

- States are ticked by `StateMachine`, not by being in the scene tree.
- `move_and_slide` on the **parent** body vs state `physics_process` on the **child** — order is engine default (**unverified** in play).
- `PlayerState._init` reads `player.animated_sprite`, which is `@onready`; construction happens in `_ready` (intended to be valid; **unverified** if anything else constructs a state earlier).
- Duplicate `ACCELERATION` / `MAX_SPEED` on movement vs jump are copies, not a shared resource.
