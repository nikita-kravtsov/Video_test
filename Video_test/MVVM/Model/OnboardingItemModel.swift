//
//  OnboardingItemModel.swift
//  Video_test
//
//  Created by Никита on 7.06.25.
//

import Foundation

struct OnboardingItemModel: Identifiable {
    let id: Int
    let title: String
    let videoName: String
    let videoExtension: String
    
    var videoURL: URL? {
        Bundle.main.url(forResource: videoName, withExtension: videoExtension)
    }
}
