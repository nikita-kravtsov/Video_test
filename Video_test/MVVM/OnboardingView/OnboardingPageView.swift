//
//  OnboardingPageView.swift
//  Video_test
//
//  Created by Никита on 7.06.25.
//

import SwiftUI
import AVKit
import Combine

struct OnboardingPageView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    let item: OnboardingItemModel
    
    var body: some View {
        ZStack {
            VideoPlayerView(player: viewModel.players[viewModel.currentPage])
                .ignoresSafeArea()
                .onAppear {
                    viewModel.isPlaying = true
                }
                .onDisappear {
                    viewModel.reset(page: viewModel.currentPage)
                }

            VStack {
                Spacer()
                
                Text(item.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()
                    .shadow(color: .black, radius: 3, x: 0, y: 2)
                
                VStack {
                    HStack {
                        MutedButton(isTapped: $viewModel.isMuted)
                            .padding(.horizontal, 40)
                            .padding(.bottom, 30)
                        PlayButton(isPlay: $viewModel.isPlaying)
                            .padding(.horizontal, 40)
                            .padding(.bottom, 30)
                    }
                    
                    HStack {
                        Button(action: viewModel.previousPage) {
                            Text("Previous")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal, 40)
                        .padding(.bottom, 30)
                        Button(action: viewModel.nextPage) {
                            Text("Next")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal, 40)
                        .padding(.bottom, 30)
                    }
                }
            }
        }
    }
}
