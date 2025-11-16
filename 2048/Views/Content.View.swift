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
            ForEach(self.game.tileGrid, id: \.self) { rowTiles in
                HStack {
                    ForEach(rowTiles, id: \.self) { tile in
                        ZStack {
                            RoundedRectangle(
                                cornerRadius: 5,
                                style: .continuous
                            )
                            .fill(.ultraThinMaterial)
                            .background(
                                self.game
                                    .getColorFromTileValue(
                                        tile.value
                                    )
                            )
                            .frame(width: 90, height: 90)
                            .padding(0)
                            if !tile.isEmpty {
                                Text("\(tile.value)").font(Font.largeTitle)
                                    .bold()
                                    .foregroundStyle(Color.black)
                            }
                        }

                    }
                }
                .padding(.vertical, 1)

            }
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
