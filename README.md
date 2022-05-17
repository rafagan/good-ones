# Good Ones
Project focused in presenting knowledge handling iOS PhotoKit and Google Photos API, along with SwiftUI (iOS 15) and MVVM architecture.

The project consists in four screens: 

* Onboarding: A small tutorial demo using SwiftUI TabView
* Setup: Choose between the camera roll and Google Photos. If you choose google, you must credentiate the app with your account (a safari window will open). In order to Google integration works you must have a 'GoogleService-Info.plist' file exported from your Google Cloud OAuth Credentials pannel, with propper configurations.
* CardCollection: Swipe right to favorite and left to dismiss. Every choice is save and the image will not appear again. If you choose Google Photos, every liked photo is downloaded and added to favorites smart album. Then, the algorithm tries to handle equality between images using a naive approach (based on image metadata) or with a perceptual hash approach (which is not working well currently).
* Congratulations: After every photo is categorized, a particle effect is shown together with a spring text animation.

![Demo](https://github.com/rafagan/good-ones/blob/master/demo.gif)

# Changelog:

    feat: Async image loading from photo library with slow and high quality
    fix: Code reorganization, better quality from camera roll
    feat: PhotoKit integration
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
