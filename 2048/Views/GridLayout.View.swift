//
//  GridLayout.swift
//  2048
//
//  Created by Dylan on 16/11/2025.
//

import SwiftUI

struct GridLayout: View {
    var body: some View {
        VStack(spacing: 2) {
            ForEach(0..<4, id: \.self) { _ in
                HStack(spacing: 2) {
                    ForEach(0..<4, id: \.self) { _ in
                        ZStack {
                            RoundedRectangle(
                                cornerRadius: 10,
                                style: .continuous
                            )
                            .fill(.ultraThinMaterial)
                            .frame(width: 90, height: 90)
                        }
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    GridLayout()
}
