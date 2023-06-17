### Create project
```shell
flutter create --org <domain name> <project name>
flutter pub add firebase_core firebase_auth cloud_firestore shared_preferences another_flushbar intl flutter_dotenv
flutter pub add -d flutter_launcher_icons
```

### Setup firebase
```shell
npm install -g firebase-tools
firebase login
dart pub global activate flutterfire_cli
flutterfire configure --project=<project name>
```

### Set min android sdk version on app level gradle file
`/android/app/build.gradle`
```
android {
    .
    .
    defaultConfig {
        .
        .
        minSdkVersion 21
    }
}
```

### Set `.env` file on `pubspec.yaml`
```yaml
flutter:
  .
  .
  assets:
    - .env
```

### Get keys
```shell
keytool -list -v -keystore %USERPROFILE%\.android\debug.keystore -alias androiddebugkey -storepass android -keypass android
```

### Set icon options on `pubspec.yaml`
```yaml
flutter_launcher_icons:
  android: "launcher_icon"
  ios: true
  image_path: "assets/icons/icon.png"
  min_sdk_android: 16
  web:
    generate: true
    image_path: "assets/icons/icon.png"
    background_color: "#FFFFFFFF"
    theme_color: "#FF66BB6A"
```

### Run icon lib to set icons
```shell
flutter pub run flutter_launcher_icons
```

### Run in chrome
```shell
flutter run -d chrome
```
