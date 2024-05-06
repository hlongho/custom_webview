## Features

Custom webview to improve feature
- Fix open link pdf in android device
- Add list url and open default launcher

## Usage
Add library to project
```
flutter pub add custom_webview
```

List url and open default launcher
```
List<String> urlLauncher = [
    'https://play.google.com',
    'https://apps.apple.com'
];
  
```
Use widget
```
CustomWebView(
    'https://pub-e1c1c97ce246453790aed20554092539.r2.dev/ATTACHMENTS/a0G1e000005dbx6EAA/Tho%CC%82ng-bao-cap-nhat-phien-ba-1.0.4.pdf',
    urlLauncher: urlLauncher
)
```