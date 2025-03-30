# Turn Up

**Turn Up** is a minimal, distraction-free music and podcast player designed specifically for drivers. Unlike traditional streaming apps like Spotify or YouTube Music, Turn Up provides an interface tailored for safe use on the road—even in cars without built-in displays.

---

## Table of Contents

1. [Project Overview](#project-overview)
2. [Features](#features)
3. [Technologies Used](#technologies-used)
4. [Architecture](#architecture)
5. [Setup Instructions](#setup-instructions)
6. [Future Improvements](#future-improvements)
7. [Team](#team)
8. [License](#license)

---

## Project Overview

Most drivers today listen to music or podcasts during their drives. However, many cars do not have built-in touch displays, forcing users to interact with their phones — something that is both illegal and dangerous while driving.

**Turn Up** addresses this issue by offering a distraction-free audio player with intuitive, gesture-based controls. Users can enjoy a hands-free experience with a clean and simple UI, reducing the need for screen interaction while on the road.

---

## Features

- **Gesture Controls**
  - **Swipe Right**: Play next song  
  - **Swipe Left**: Play previous song  
  - **Swipe Up**: Open playlist and tap to select any song  

- **Tap Controls**
  - **Single Tap**: Play/pause the current track

- **Voice Controls**
  - **Pause/Continue**: stops or resumes the current track
  - **Play ...**: plays a specific song or playlist
  - **Previous/Next**: skips tracks through the current playlist
  - **Party**: unlocks a secret playlist, it is an easter egg

- **Always-Visible Time**
  - Clock is always visible at the top of the screen for convenience  

- **Minimal Interface**
  - Only one main screen with essential controls, no distractions  

---

## Technologies Used

- **Frontend**: SwiftUI
- **Frameworks**: AVFoundation, UIKit, Foundation, Speech, Combine
- **Tools**: Xcode, Git  

---

## Architecture

The project uses the **MVVM (Model-View-ViewModel)** pattern to clearly separate:

- **Model** – Handles data and audio logic  
- **ViewModel** – Manages state and user interaction logic  
- **View** – Displays the interface and reacts to user input  

This ensures maintainability, testability, and clean code organization.

---

## Setup Instructions

1. Make sure you have XCode installed on your computer.
2. Copy the link of the repository:
https://git.fhict.nl/I524517/turnup
3. Open a terminal and navigate to the desired directory.
4. to clone the project, use this command 
```bash
   git clone https://git.fhict.nl/I524517/turnup
   ```
5. Now you can open the project in XCode and see it in the preview, or build it on your device.

## Future Improvements

Throughout the develop and define phases of the project, several future implementations were considered:

- **Playlist Importing**  
  Allow users to import their own playlists from preferred streaming platforms (e.g., Spotify, Apple Music).

- **Gesture Commands via Camera**  
  Introduce support for navigating the app using hand gestures recognized by the device’s camera.

- **Interactive Tutorial**  
  Provide an onboarding tutorial demonstrating gesture and voice commands when the app is first downloaded.

- **Wake Word Activation**  
  Implement a wake word (e.g., “Hey, TurnUp”) for voice commands, so the app listens only when prompted—preventing accidental commands while driving.

---

## Team

- **Kalina Bacheva**  
  Student Number: 5165067

- **Yordan Markov**  
  Student Number: 5056136

---

## License

This project is licensed under the [MIT License](LICENSE). See the `LICENSE` file for more details.
