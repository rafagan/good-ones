# Good Ones
Project focused in presenting knowledge handling iOS PhotoKit and Google Photos API, along with SwiftUI (iOS 15) and MVVM architecture.

The project consists in four screens: 

* Onboarding: A small tutorial demo using SwiftUI TabView
* Setup: Choose between the camera roll and Google Photos. If you choose google, you must credentiate the app with your account (a safari window will open). In order to Google integration works you must have a 'GoogleService-Info.plist' file exported from your Google Cloud OAuth Credentials pannel, with propper configurations.
* CardCollection: Swipe right to favorite and left to dismiss. Every choice is save and the image will not appear again. If you choose Google Photos, every liked photo is downloaded and added to favorites smart album. Then, the algorithm tries to handle equality between images using a naive approach (based on image metadata) or with a perceptual hash approach (which is not working well currently).
* Congratulations: After every photo is categorized, a particle effect is shown together with a spring text animation.

![Demo](https://github.com/rafagan/good-ones/blob/master/demo.gif)

# Task list
- [ ] Improve perceptual hash detection
- [X] Add heuristics to detect duplicates
- [X] Download image to favorites smart album
- [X] Rotate landscape photos
- [X] Build a repository version with UserDefaults
- [X] Improve async photo loading
- [X] Integrate Google Photos
- [X] Auth with Google Cloud
- [X] Build a setup screen to select provider
- [X] Build a introduction screen
- [X] Remove card animation and flow
- [X] Add haptics and sounds
- [X] Show feedback effect when starve photo list
- [X] Work with favorites and dismisses
- [X] Build card animations
- [X] Organize architecture layers with SwiftUI and MVVM

# Changelog (recent commits first):

    feat: Check duplicates in naive approach and using perceptual hash, save images in gallery as favorites, fetch favorites to compare, remove google photos processed pictures
Moving to part 3, the algorithm challenge, I used my last hours to build a photo duplication recognizer. To make a Proof of Concept, I considered only the Favorites smart library as templates to match (because probably all the downloaded Google Photos are there at this moment). Then I compared the favorite creation date (which I've set with the same value from Google Photos) with the creation date from my photo which came from cloud. After I integrated another library to make perceptual hash between images to check similarity, but I don't tested it enought to make it nice to use, thus I turned off for now.

    feat: Download image favorited from Google to ios gallery and add to local favorites
The final mandatory issue built was the image download and addition to local favorites when the provider is Google Photos

    fix: Landscape photos, some minor refactors
Time to fixes: some photos are capture in landscape mode and appears ugly in cards, making then shorter in height. Detecting landscape images and rotating them improved the experience.

    feat: Google Photos integration
Finally, the Google Photos integration. The Google Cloud authentication process is usually very painfull task to accomplish. Fortunatelly, I'm currently working with another API integrations with then, so the auth process was softer. The photo consuming from API also was easy because of the time spent organizing things in MVVM layers and in CameraRollProvider.

    feat: OnboardingView, SetupView, refactor in camera loading
Build the Setup and Onboarding screen, also working in a new Repository layer to persist data, like onboarding done and pictures already categorized. The architecture considerer future test implementations and more interesting databases, like Realm or Core Data (I've kept then off considering the challenge scope). Moving some business rules from the CardCollection screen to Setup Screen helped me to solve a lot of bugs and prepare the future to the Google Photos integration

    feat: Async image loading from photo library with slow and high quality
    fix: Code reorganization, better quality from camera roll
    feat: PhotoKit integration
After completing the main screens, I started moving my atention to the model layer, specially the Camera Roll image fetching. After this sprint, the project began to gain robustness
    
    feat: Navigation, congratulations effects
The congratulation screen with particle effects and spring animation

    feat: Feedbacks
After the animations are finished, I invested some time to improve the interaction experience by putting vibration effects (haptics) and sounds

    ui: Remove card animation
    feat: remove itens after choice
    ui: favorite and dismiss icons and animation.
    ui: Card Cell View Animation
One of the things that gave me the most headache and the need for experimentation in the whole project: making subtle animations with a good user experience. I thought of Tinder as a reference and did some research on YouTube to find inspiration.

    ui: Card Cell View
Starting the card cells and the Picture entity, the only entity from the entire application

    feat: Organizing MVVM layers, showing a image
First photo provider layers, beginning with a test Local Provider, which gets photos from Assets.xcassets and helped a lot to build the screen scaffolds
