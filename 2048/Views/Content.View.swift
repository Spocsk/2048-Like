//
//  ContentView.swift
//  2048
//
//  Created by Dylan on 10/11/2025.
//

import SwiftUI

struct ContentView: View {

    @ObservedObject var game: GameViewModel = GameViewModel()

    init() {
        game.createRandomTile()
    }

    var dragGesture: some Gesture {
        DragGesture().onEnded({ value in
            print(
                "\(self.getGestureDirection(translation: value.translation))\n"
            )
            let direction = self.getGestureDirection(
                translation: value.translation
            )
            withAnimation {
                self.game.moveTile(direction: direction)
                game.createRandomTile()
            }
        })
    }

    var body: some View {
        VStack {
            Text("2048").font(Font.largeTitle).bold().fontWidth(.expanded)
                .padding(.vertical, 50)

            let tiles = self.game.getAllTiltes()

            ZStack {
                GridLayout()
                ForEach(tiles, id: \.self.id) { tile in
                    TileView(
                        tile: tile,
                        bgColor: self.game.getColorFromTileValue(tile.value)
                    )
                    .position(
                        x: CGFloat(tile.position.col) * 92 + 60,
                        y: CGFloat(tile.position.row) * 92 + 78
                    )

                }
            }
            .padding()
            

            Button("New Game") {
                self.game.resetGame()
                self.game.createRandomTile()
            }
            .font(Font.title2).bold().fontWidth(.expanded)
            .padding(.vertical, 50)

        }
        .padding()
        .gesture(dragGesture)
    }

    func getGestureDirection(translation: CGSize) -> GestureDirection {
        if abs(translation.width) > abs(translation.height) {
            return translation.width > 0
                ? GestureDirection.right
                : GestureDirection.left
        } else {
            return translation.height > 0
                ? GestureDirection.down : GestureDirection.up
        }
    }

}

#Preview {
    ContentView()
}
