//
//  PlayButton.swift
//  Video_test
//
//  Created by Никита on 7.06.25.
//

import SwiftUI

struct PlayButton: View {
    @Binding var isPlay: Bool
    
    var body: some View {
        Button(action: {
            isPlay.toggle()
        }) {
            Image(systemName: isPlay ? "pause.fill" : "play.fill")
                .font(.system(.largeTitle))
                .frame(width: 60, height: 60)
                .foregroundColor(.white)
                .background(Circle().fill(Color.gray.opacity(0.5)))
        }
    }
}
