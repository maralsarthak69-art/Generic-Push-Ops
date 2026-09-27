# Generic Push Ops

A Flutter push-up counter that uses a device's proximity sensor to count
repetitions. Workout sessions are stored locally with Hive.

## Features

- Counts a repetition when the proximity sensor changes from far to near.
- Announces the current count with text-to-speech.
- Saves completed sets with their date, repetition count, and duration.
- Shows workout history and a chart of the last seven days.

## Run locally

Install Flutter and the dependencies, then run the app on a device with a
proximity sensor:

```sh
flutter pub get
flutter run
```

The proximity sensor and text-to-speech features depend on platform support;
emulators or devices without a proximity sensor may not count repetitions.

## Validate

```sh
flutter analyze
flutter test
```
