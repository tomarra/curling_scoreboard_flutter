# Curling Scoreboard

A simple Curling Scoreboard, written in Flutter, meant to be used in any curling club that has an electronic scoreboard.

## Project Setup

This project is a basic [Flutter](http://www.flutter.dev) application so [environment setup](https://docs.flutter.dev/get-started/install) can be found and followed on the main Flutter developer site.

After cloning the repo and opening the project in [VSCode](https://code.visualstudio.com/) you should be able to run the `Launch Web` target to see everything up and working.

## Making Releases

### Version Bump

This is handled by the [version_increment](https://github.com/tomarra/curling_scoreboard_flutter/actions/workflows/version_increment.yaml) workflow. This will automatically read the commits, create the [changelog](https://github.com/tomarra/curling_scoreboard_flutter/blob/main/CHANGELOG.md) and [release notes](https://github.com/tomarra/curling_scoreboard_flutter/blob/main/RELEASE_NOTES.md) and commit it all back to the `main` branch.

1. Remove the branch protection on `main` by changing the [branch protection rules](https://github.com/tomarra/curling_scoreboard_flutter/settings/branches). Just change the branch name pattern to something like `notmain`.
2. Go to the [version_increment action](https://github.com/tomarra/curling_scoreboard_flutter/actions/workflows/version_increment.yaml) and click on "Run Workflow". Ensure it is on the `main` branch and click "Run Workflow" to start it.
3. When the build completes, turn the branch protection back on by reverting the pattern to `main`
