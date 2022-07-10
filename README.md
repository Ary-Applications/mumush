# mumush

Mumush app.

## Getting Started

This project is the Mumush Festival Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Assets

The `assets` directory houses images, fonts, and any other files you want to
include with your application.

The `assets/images` directory contains [resolution-aware
images](https://flutter.dev/docs/development/ui/assets-and-images#resolution-aware).


## Steps to use after cloning the project

### Run the generator

Use the [watch] flag to watch the files' system for edits and rebuild as necessary.

```git
flutter packages pub run build_runner watch
```

if you want the generator to run one time and exits use

```git
flutter packages pub run build_runner build
```

generate icons for when the launcher icon changes
```
flutter pub run flutter_launcher_icons:main
```

### Problems with the generation?

Make sure you always Save your files before running the generator, if that does not work you can always try to clean and rebuild.

```git
flutter packages pub run build_runner clean
```

If there are conflicting outputs use

```git
flutter pub run build_runner watch --delete-conflicting-outputs
```

For more information [build_runner documentation](https://pub.dev/packages/build_runner)