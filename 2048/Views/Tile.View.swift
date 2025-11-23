//
//  Tile.swift
//  2048
//
//  Created by Dylan on 16/11/2025.
//

import SwiftUI

struct TileView: View {

    var tile: Tile
    var bgColor: Color = .white

    init(
        tile: Tile = Tile(
            id: UUID(),
            value: 2,
            position: .init(row: 0, col: 0),
            isEmpty: false
        ),
        bgColor: Color = Color.teal
    ) {
        self.tile = tile
        self.bgColor = bgColor
    }

    var body: some View {
        ZStack {
            RoundedRectangle(
                cornerRadius: 10,
                style: .continuous
            )
            .fill(self.bgColor)
            .frame(width: 90, height: 90)
            if !self.tile.isEmpty {
                Text("\(self.tile.value)")
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(Color.white)
            }
        }
    }
}

#Preview {
    TileView()
}
