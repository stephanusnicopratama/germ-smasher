# ADR 0001: Flutter + Flame for Germ Smasher

## Status

Accepted

## Context

We want a simple 2D tap game for children ages 4–6, themed around cartoon germs (Ant Smasher–style). The product will ship in mobile app stores later; for now we need fast local and web testing. UI copy should stay minimal (icons over text).

## Decision

- **Repository location**: Standalone **`germ-smasher`** repository (this project root), separate from vehicle-log.
- **Stack**: Flutter 3.x + **Flame** 1.x for game loop, tap handling, and overlays.
- **Primary test target**: **Flutter Web** (`flutter run -d chrome`, `flutter build web`).
- **Mobile**: Same codebase; iOS/Android builds deferred until MVP is validated.
- **MVP scope**: Endless tap-to-smash, score badge, mute toggle (SFX hook reserved), home button—no accounts, ads, or analytics.

## Alternatives considered

| Option | Why not (for this MVP) |
|--------|-------------------------|
| TypeScript + Vite + Capacitor | Fine for web, but more custom work for game loop and touch hit areas |
| React Native | Weaker ergonomics for a lightweight 2D smasher |
| Unity | Heavy toolchain for a single mini-game |

## Consequences

- Developers need Flutter/Dart on PATH (or use `%USERPROFILE%\flutter\bin` from a local SDK clone).
- Web builds are larger than a tiny Canvas app but share 100% of game code with mobile.
- Store release, privacy/COPPA, and localization are follow-up ADRs.

## Game design constraints (normative)

- Minimum tap target: germ radius 36px + 16px hit padding (~52px effective).
- At most **10** germs on screen; spawn interval **1.4s** by default.
- Visuals stay silly/cartoon—not scary medical imagery.
- No punitive game-over in v0; session ends when the child taps home.

## Technical shape

- `GermSmasherGame` (`FlameGame`) owns score, play state, overlays.
- `Germ` (`CircleComponent` + `TapCallbacks`) moves with bouncing velocity.
- `GermSpawner` (`Component`) spawns germs on a timer while playing.
- HUD/start screens are Flutter widgets via Flame `overlayBuilderMap`.

## Testing

- `flutter test` for spawner cap logic.
- Manual: Chrome web + one touch device before store work.
