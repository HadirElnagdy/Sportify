# The Sports App

Welcome to The Sports App, your ultimate destination for all things sports-related! This iOS application provides a seamless experience for exploring different sports, leagues, and team details. Whether you're a die-hard fan or just looking to stay updated, The Sports App has got you covered.

## Features

### Main Screen

The main screen features two tabs:

1. **Sports Tab**: This tab displays four available sports - Football, Basketball, Cricket, and Tennis. Each sport is represented by its respective icon and name in a CollectionView. Selecting a sport navigates the user to the Leagues ViewController.
   
2. **Favorite Leagues Tab**: This tab allows users to view their favorite leagues. CoreData is utilized to store and manage favorite leagues. Users can view league details by tapping on a row. If the user is online, they can navigate to the LeagueDetailsViewController; otherwise, an alert is displayed indicating no internet connection.

### Leagues ViewController

The Leagues ViewController is a TableViewController with a title "Leagues". Each row presents a custom view comprising the league logo (circular), league name, and tapping on a row navigates the user to the LeagueDetailsViewController.

### LeagueDetails ViewController

The LeagueDetails ViewController provides comprehensive information about a specific league. 

- **Favorite Addition**: Users can add the league to their favorites by tapping the button located at the top right corner.
- **Upcoming Events**: Displays upcoming events with details such as event name, date, and time.
- **Latest Results**: Provides the latest results with details of teams, scores, date, and time.
- **Teams**: Allows users to explore teams associated with the league through a horizontal view. Tapping on a team's image directs the user to the TeamDetails ViewController. Compositional layout is implemented for smooth orthogonal scrolling.

### TeamDetails ViewController

The TeamDetails ViewController presents detailed information about a specific team, ensuring an elegant and informative UI.

## Technologies Used

- **CoreData**: Utilized for managing favorite leagues.
- **Compositional Layout**: Implemented for orthogonal scrolling in the Teams section.

## Installation

To run The Sports App on your iOS device:

1. Clone this repository.
2. Open the project in Xcode.
3. Build and run the project on your preferred iOS device or simulator.

## Feedback

We are constantly working on improving The Sports App to provide the best user experience. If you have any feedback, suggestions, or bug reports, please feel free to reach out to us.

Thank you for choosing The Sports App! Enjoy exploring the exciting world of sports! 🏀⚽🏏🎾
