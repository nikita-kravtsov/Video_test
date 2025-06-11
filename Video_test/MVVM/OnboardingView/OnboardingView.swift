//
//  OnboardingView.swift
//  Video_test
//
//  Created by Никита on 7.06.25.
//

import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    
    var body: some View {
        TabView(selection: $viewModel.currentPage) {
            ForEach(viewModel.items) { item in
                OnboardingPageView(viewModel: viewModel, item: item)
                    .tag(item.id)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .ignoresSafeArea()
        .onAppear {
            UIApplication.shared.isIdleTimerDisabled = true
        }
        .onDisappear {
            UIApplication.shared.isIdleTimerDisabled = false
        }
    }
}
