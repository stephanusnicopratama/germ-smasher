# Germ Smasher

Tap-to-squash cartoon germs — a simple 2D game for ages 4–6. Built with **Flutter + Flame**. Web is for quick testing; the same project targets iOS/Android later.

See [docs/adr/0001-flutter-flame-germ-smasher.md](docs/adr/0001-flutter-flame-germ-smasher.md).

## Prerequisites

Flutter SDK on your PATH, or run with `%USERPROFILE%\flutter\bin\flutter.bat` if you installed the SDK under your user profile.

Enable web once:

```bash
flutter config --enable-web
```

## Run locally (web)

From the repository root:

```bash
flutter pub get
flutter run -d chrome
```

## Build web

```bash
flutter build web
```

Output: `build/web/`.

## Test

```bash
flutter test
```

## Play

1. Tap the large **play** button.
2. Tap moving germs to smash them; the score increases.
3. **Home** returns to the start screen; **mute** toggles sound (SFX can be wired later).
