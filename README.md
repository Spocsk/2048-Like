# 2048 - SwiftUI

A native iOS implementation of the classic 2048 sliding puzzle game, built entirely with SwiftUI and modern Swift concurrency patterns.

![iOS](https://img.shields.io/badge/iOS-15.0+-blue.svg)
![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)
![SwiftUI](https://img.shields.io/badge/SwiftUI-3.0-green.svg)
![License](https://img.shields.io/badge/license-MIT-lightgrey.svg)

## 📱 Screenshots

## ✨ Features

- **Smooth Animations**: Fluid tile movements using SwiftUI's `matchedGeometryEffect`
- **Gesture Controls**: Intuitive swipe gestures (up, down, left, right)
- **MVVM Architecture**: Clean separation of concerns with ViewModel pattern
- **2048 Game Logic**: Accurate implementation of original game rules
  - Tile merging when matching values collide
  - Score tracking
  - Random tile generation (2 or 4)
  - Game state management
- **Adaptive UI**: Beautiful color scheme matching original 2048 design
- **Pure SwiftUI**: No external dependencies or frameworks

## 🎮 How to Play

1. Swipe in any direction (up, down, left, right) to move all tiles
2. When two tiles with the same number touch, they merge into one
3. After every move, a new tile (2 or 4) appears in a random empty spot
4. The goal is to create a tile with the number 2048
5. The game ends when no more moves are possible

## 🏗️ Architecture

This project follows the **MVVM (Model-View-ViewModel)** pattern:

