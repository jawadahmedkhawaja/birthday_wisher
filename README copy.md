# Birthday Surprise — Flutter

A mobile Flutter recreation of the flow shown in the supplied reference video.

## Flow

1. Passcode screen
2. "I made something special for you" screen
3. Letter from the heart
4. Birthday cake / blow the candles screen

## Configuration

Edit `.env`:

```env
YOUR_NAME=Alex
HER_NAME=Sunshine
BIRTHDAY=2000-02-14
```

The app converts `BIRTHDAY` from `YYYY-MM-DD` into the keypad passcode `DDMMYYYY`.

Example:

`2000-02-14` → `14022000`

You can also edit the letter text in `.env`.

## Run

```bash
flutter pub get
flutter run
```

Build an APK:

```bash
flutter build apk --release
```

## Important

`.env` values are bundled into a Flutter app. They are configuration, not a secure secret. Anyone who extracts the APK can potentially recover them. For a birthday-surprise lock this is fine; do not use it for real authentication or sensitive credentials.
