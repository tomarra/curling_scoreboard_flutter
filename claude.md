# Curling Scoreboard Flutter

A Flutter-based electronic scoreboard application designed for use in curling clubs to track, manage, and display game scores in real-time.

## Key Features

- **Game Setup** - Configure team names, colors, player count (2 or 4), number of ends, and which team has the hammer
- **Score Tracking** - Enter scores for each end with automatic hammer evaluation based on curling rules
- **Two Display Layouts**:
  - Baseball-style grid layout
  - Traditional curling club scoreboard format
- **Game Timer** - Tracks elapsed time and shows time over/under the allocated time per end
- **Game State Display** - Shows current scores, end number, team colors, and hammer indicator
- **Game Completion** - Automatic detection when game ends with final score dialog

## Project Structure

- **Models** (`lib/models/`) - `CurlingGame`, `CurlingTeam`, `CurlingEnd` for game state
- **Widgets** (`lib/widgets/`) - Scoreboard layouts, score entry dialogs, settings, app bar controls

## Dependencies

- Flutter SDK
- Material Design 3
- intl (internationalization)
- material_segmented_control
