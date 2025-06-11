//
//  MutedButton.swift
//  Video_test
//
//  Created by Никита on 8.06.25.
//

import SwiftUI

struct MutedButton: View {
    @Binding var isTapped: Bool
    
    @State private var isMuted = false
    @State private var isPulsating = false
    
    var body: some View {
        Button(action: {
            isTapped.toggle()
            withAnimation(Animation.spring()) {
                isMuted = isTapped
            }
            withAnimation(Animation.spring().repeatForever().delay(0.5)) {
                isPulsating = true
            }
            
        }, label: {
            ZStack {
                Circle()
                    .frame(width: 60, height: 60)
                    .foregroundColor(Color.gray.opacity(0.5))
                    .overlay(
                        Image(systemName: isMuted ? "speaker.slash.fill" : "speaker.fill")
                            .font(.system(.largeTitle))
                            .foregroundColor(isMuted ? .red : .white)
                    )
                Circle()
                    .trim(from: 0, to: isMuted ? 1 : 0.0001)
                    .stroke(lineWidth: 5)
                    .frame(width: 80, height: 80)
                    .foregroundColor(.red)
                    .scaleEffect(isPulsating ? 1 : 0.7)
                    .opacity(isMuted ? 1 : 0)
            }
        })
        .buttonStyle(PlainButtonStyle())
    }
}
