# Roadmap

Prioritized for a developer returning to this prototype. **Issues** are gaps or defects visible in current files. **Enhancements** are new work. Do not treat items as scheduled or previously agreed.

Acceptance criteria assume Godot 4.3 and main scene `scenes/level/test.tscn`.

---

## Existing issues

### P0 — Playtest and record runtime facts

**Rationale:** Docs and code cannot claim the loop works. Every later movement fix needs a baseline.

**Depends on:** Godot 4.3, textures for idle/jump/hands on disk.

**Acceptance:** A short note (even a few bullets in `CURRENT_STATUS.md`) of what happened: spawn, fall/land, A/D, W, stop, Output log, missing-texture errors.

**Test:**

1. Open the project, run the main scene.
2. Watch spawn and whether the body rests on the boundary.
3. Hold D, then A; release; press W on ground; walk off visually and press W in air.
4. Walk far on X; note camera.
5. Check Output for `Enter jump` and state logs (`is_logging = true`).

### P1 — Floor-gate jump (or document air-W as fall)

**Rationale:** Idle/movement transition to jump on W with no `is_on_floor()` (`player_idle_state.gd` L10–11, `player_movement_state.gd` L13–14). Impulse only applies on floor (`player_jump_state.gd` L20–21). Easy to confuse with a broken jump.

**Depends on:** P0 (know whether air-W is already used as fall).

**Acceptance:** Either jump press requires `player.is_on_floor()`, or a named fall state/comment exists so air-W is intentional.

**Test:** W on ground leaves floor; W in air does not add a second impulse; walking off the floor without W uses the chosen fall path.

### P2 — Movement ↔ idle

**Rationale:** Movement never returns to idle. Stopping is a side effect of `move_toward` toward 0 while still in movement.

**Depends on:** P0 (whether staying in movement is acceptable because both play `"idle"`).

**Acceptance:** Releasing A/D on the ground either (a) transitions to `PlayerIdleState` and X speed goes to 0, or (b) the missing transition is explicitly documented as intended in `DECISIONS.md` after a real decision.

**Test:** From rest, hold D, release, confirm state name in log (`is_logging`) and that the body stops.

### P3 — Jump land should not keep integrating air X

**Rationale:** After `transition` in `player_jump_state.gd` L33–37, L41–46 still run.

**Depends on:** P0–P2.

**Acceptance:** The landing frame does not apply jump-state air control after the new state is current (or the overlap is measured and accepted in `DECISIONS.md`).

**Test:** Land while holding D vs not; compare first ground frame X speed.

### P4 — Strip debug / dead data or use it

**Rationale:** `print("Enter jump")`, `is_logging = true`, unused `MAX_JUMP_FORCE`, unread `_facing`, unassigned `PlayerState` arm refs, empty `arms` node.

**Depends on:** None.

**Acceptance:** Either removed or referenced by gameplay; logging off by default for play.

**Test:** Run scene; Output has no jump spam unless logging is enabled.

### P5 — Camera vs player

**Rationale:** `Camera2D` is a sibling at a fixed position (`scenes/level/test.tscn` L18–20). If movement works, the player leaves the view.

**Depends on:** P0.

**Acceptance:** Camera follows the player, **or** the test level keeps the player in the starting view on purpose (then document that).

**Test:** Hold D for several seconds; player remains framed if follow is required.

---

## Proposed enhancements

Not existing work. No design sign-off in the repo.

### E1 — Shared move constants

Duplicate `ACCELERATION` / `MAX_SPEED` on movement and jump. A single source would stop drift. **Proposal.**

### E2 — Walk animation

Movement currently `play("idle")`. Needs art + SpriteFrames + state change. **Proposal.**

### E3 — Combat using unused arm textures

`jab1` / hook / uppercut imports are unused. Would need input actions, states, hitboxes. **Proposal.** Do not start until P0–P2 are settled.

### E4 — Gamepad / arrows

Only A/D/W in `project.godot`. **Proposal.**

### E5 — Dedicated fall state, coyote time, jump buffer

None exist. **Proposal.**

### E6 — Real level art and collision

World boundary + empty `Node2D` only. **Proposal.**

---

## Suggested order

P0 → P1 → P2 → P3 → P5 → P4, then E-items as product choices. E3 (combat) last among these.
