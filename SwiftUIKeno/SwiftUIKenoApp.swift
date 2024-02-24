//
//  SwiftUIKenoApp.swift
//  SwiftUIKeno
//
//  Created by Jeffrey Kereakoglow on 8/15/23.
//

import SwiftUI

@main
struct SwiftUIKenoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: GameViewModel(game: Game.game))
//                .environmentObject(GameViewModel)
        }
    }
}
