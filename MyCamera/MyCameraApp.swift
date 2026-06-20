//
//  MyCameraApp.swift
//  MyCamera
//
//  Created by Kit Sitou on 6/18/26.
//

import SwiftUI
import SwiftData

@main
struct MyCameraApp: App {
    var body: some Scene {
        WindowGroup {
            FeedView()
        }
        .modelContainer(for:ProgressEntryModel.self)
    }
}
