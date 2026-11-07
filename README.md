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

For GitHub Pages, pass the subpath: `flutter build web --release --base-href "/germ-smasher/"`.

## GitHub Pages

1. Repo **Settings → Pages → Build and deployment → Source: GitHub Actions** (free accounts need a **public** repo for Pages).
2. Push to `main` or run workflow **Deploy to GitHub Pages** manually.
3. Play at [https://stephanusnicopratama.github.io/germ-smasher/](https://stephanusnicopratama.github.io/germ-smasher/).

## Test

```bash
flutter test
```

## Play

1. Tap the large **play** button.
2. Tap moving germs to smash them; the score increases.
3. **Home** returns to the start screen; **mute** toggles sound (SFX can be wired later).
