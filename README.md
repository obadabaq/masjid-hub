# Masjidhub

Home Masjid companian app.

### To run the app

- Create a file called `lib/secrets.dart`
- Get secrets from Google cloud project connected to Takva account firebase.
- Copy the block of code below and add the secrets.
- Run `flutter pub get`
- Run `flutter run`

```yaml
final String iOSKey = '';
final String androidKey = '';
final String androidSHA = '';
```

### TODOS:

- [ ] Flutter Compass uses a unmaintained library. Please update when there is a good alternative. It will also reduce the bundle size by a huge margin.
- [ ] Get app to release in appstore and playstore
- [ ] Update the [translations](https://docs.google.com/spreadsheets/d/1ypC_bat53ujimu695gepNVpOMiFzQ6wYH3io5sxhBHs/edit?usp=sharing) with actual translations. Download the file as csv and replace `assets/translations`
- [ ] Responsiveness for tablet

### Requested Features:

- We should have a place for them to contact us incase of errors.
- We should have a way for user to resync Home Masjid device data.

### Releasing Test app for Android:

- Increment build number on pubspec.yaml and xcode project
- We are using app distribution for android. 
- Run `flutter build apk --release`
- Drag and drop the release.apk into firebase app distribution, add release notes and ship.

### Releasing Test app for iOS:

- Increment build number on pubspec.yaml and xcode project
- We are testflight for iOS. 
- Click on Archive project on Xcode and upload the beta

### FAQs:

1. During Remote Of mode, why is the ayah highlighting not synced with the audio?
This is happeing because the surah timestamps are incorrect. At the time of writing we only have Meshary timestamps, that too aren't all correct for all Surahs. To learn more on how to update surah timestamps, check these [guidelines](https://docs.google.com/document/d/1Z9yE5R5B_LSewIZq3pBtnMs2u0f6ucEnVg864_jhBxk/edit?usp=sharing).
