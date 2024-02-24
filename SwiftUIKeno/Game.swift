//
//  Game.swift
//  SwiftUIKeno
//
//  Created by Jeffrey Kereakoglow on 8/23/23.
//

import Foundation

struct Game {
    let gameIdentifier: UInt
    let bonus: UInt
    let numbers: [UInt]
    let date: Date
    
    static let game = Game(
        gameIdentifier: 2608931,
        bonus: 0,
        numbers: [9,
                  14,
                  16,
                  18,
                  21,
                  28,
                  32,
                  33,
                  35,
                  41,
                  45,
                  48,
                  49,
                  52,
                  60,
                  62,
                  71,
                  73,
                  77,
                  78],
        date: Date()
    )

}

