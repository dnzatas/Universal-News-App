#  Universal News App


<div style="text-align: center;">
  <img src="appIcon.png" alt="App Icon" width="100" height="100">
</div>


## Overview

The News App is an iOS application that allows users to stay up-to-date with the latest news from various sources. It utilizes the News API to fetch news articles and provides features such as searching, categorizing, viewing article details, and supporting a dark mode. The project follows the MVVM (Model-View-ViewModel) architectural pattern and incorporates Firebase and Kingfisher as third-party libraries.

## Features

- **News Feed**: The app displays a feed of news articles retrieved from the News API.
- **Search Functionality**: Users can search for specific news articles based on keywords or topics.
- **Categorized News**: News articles are categorized into various sections like sports, politics, entertainment, etc.
- **Article Details**: Users can view detailed information about a news article by tapping on it.
- **Dark Mode**: The app supports both light and dark modes for user convenience.

## Screen Recording

Include screen record different aspects of app, such as the main news feed, search functionality, article details view, and the dark mode.

![UNIntroduce](https://github.com/dnzatas/Universal-News-App/assets/125405921/b152bf9b-7a44-4952-99f2-62d25a2d1f33)

## Installation

1. Clone this repository to your local machine.

```bash
git clone https://github.com/your-username/news-app.git

```

## Configuration

Before running the app, you'll need to configure Firebase and the News API.

## Firebase Configuration

1. Create a Firebase project on the Firebase Console.
2. Add your iOS app to the Firebase project and follow the setup instructions to obtain the Firebase configuration plist file.
3. Place the Firebase configuration plist file (GoogleService-Info.plist) in the project's root directory.

## News API Configuration

1. Get an API key from the News API website.
2. Open the Constants.swift file in the project and replace the placeholder with your News API key.

```swift
static let apiKey = "YOUR_NEWS_API_KEY"
```

## Dependencies

- Firebase: Used for authentication, analytics, and other features.
- Kingfisher: A library for downloading and caching images.

