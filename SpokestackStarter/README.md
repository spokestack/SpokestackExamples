# Spokestack Starter

Hi, and welcome to the Spokestack start app (in the loosest sense of the term). This is the companion code for our iOS [getting started guide](https://spokestack.io/docs/iOS/getting-started), created so you don't have to read its code snippets in isolation.

You should be able to clone this project, move a few things around if you have multiple activities, and have a simple voice-controlled app up and running in short order. That's how we made the [Spokestack RSS Reader](https://github.com/spokestack/SpokestackExamples/tree/develop/SpokestackRSSReader) app, which demostrates a much more sophisticated usage of Spokestack. 

Due to the nature of this app, it might not be updated as frequently as the Spokestack library itself, so always check dependency versions to ensure you have the latest and greatest for your own app.

We've included a few details in code comments in this project, but check out the [Spokestack documentation](https://spokestack.io/docs/) for a lot more information.

There are several functions in the `SpokestackController` that remain unimplemented with placeholders. Consider using them as your starting point for exploring how to begin using Spokestack!

## CocoaPods

Because Spokestack is distributed using the CocoaPods dependency manager, you should [install it](https://cocoapods.org/) before using the starter project. However, this starter project includes the dependencies already installed. Once CocoaPods is installed, run `pod install && open SpokestackStarter.xcworkspace` to install Spokestack and open the XCode workspace.

---
## Wakeword models

The starter project is configured to use the demo `AppleWakewordRecognizer`, which features a configurable wakeword. To use the demo "Spokestack" wakeword using the TensorFlowLite wakeword recognizer, download the following TensorFlow Lite models and add them to the project. 
- [detect](https://d3dmqd7cy685il.cloudfront.net/model/wake/spokestack/detect.lite)
- [encode](https://d3dmqd7cy685il.cloudfront.net/model/wake/spokestack/encode.lite)
- [filter](https://d3dmqd7cy685il.cloudfront.net/model/wake/spokestack/filter.lite)
