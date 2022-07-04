# Scrum for Fun

## Setup
First follow the [setup instructions](https://docs.flutter.dev/get-started/install) for Flutter.
Install vscode and the `Flutter` extension.  
Install git.  
In your desired directory run:
```
git clone https://github.com/HSMA-Adeptus-Mechanicus/app.git
cd app
```
This will clone the repository into the app directory and navigate into it.

On Windows run `explorer .` to open the directory in the explorer.  
If vscode is in your `PATH` you can also use `code .` to open the directory directly in vscode.

## Build and Install
### Android
Run
```
flutter build apk
```
Then you can copy the generated apk located at `build/app/outputs/flutter-apk/app-release.apk` to the Android phone then open the apk with the files app on your phone.
While installing you may first be asked to give permission to the files app to install apps. Additionally you will get a warning by Play Protect that the app's developer is not recognized and you have to select `Install Anyway`.
### IOS
Without a developer account the app can only be run in development mode while connected to a Mac.
To run it connect the IOS device to a Mac. Run `flutter run` and if asked select the IOS device.

## Development Rules
- Do not push into the branch `main`.
- When committing or pushing first check if the current branch is correct.

### Merge to main checklist
- The code has to be commented
- Merge `main` into the other branch
- Create pull request into `main` branch
- Review by another person