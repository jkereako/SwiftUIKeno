//
//  GameViewModel.swift
//  SwiftUIKeno
//
//  Created by Jeffrey Kereakoglow on 8/23/23.
//

import Foundation
import SwiftUI
import OpenAPIRuntime
import OpenAPIURLSession
import Dependencies
import ComposableArchitecture

/*
struct MockClient: APIProtocol {
    func getLatestDraw(_ input: Operations.getLatestDraw.Input) async throws ->
    Operations.getLatestDraw.Output {
        
        return .ok(
            Operations.getLatestDraw.Output.Ok(
                body: .json(.init(drawNumber: 100, bonus: 100, drawDate: "2024-01-01", activePromotions: <#T##[OpenAPIObjectContainer]#>, winningNumbers: <#T##[Int32]#>, resultsSequence: <#T##Operations.getLatestDraw.Output.Ok.Body.jsonPayload.resultsSequencePayload#>)
                           )
            )
        )
    }
    
    func getDrawByNumber(_ input: Operations.getDrawByNumber.Input) async throws ->
    Operations.getDrawByNumber.Output {
        <#code#>
    }
    
    func getDrawByDateRange(_ input: Operations.getDrawByDateRange.Input) async throws ->
    Operations.getDrawByDateRange.Output {
        <#code#>
    }
    
    func getHotNumbers(_ input: Operations.getHotNumbers.Input) async throws ->
    Operations.getHotNumbers.Output {
        <#code#>
    }
}
*/

enum NetworkError: Error {
    case unexpectedResponse(statusCode: Int)
}


final class KenoRepository {
    private let client: PublicAPIProtocol
    
    init(client: PublicAPIProtocol) {
        self.client = Client(
            serverURL: try! Servers.server1(),
            transport: URLSessionTransport()
        )
    }
    
    func latestDraw() async throws {
        let response = try await client.getLatestDraw()
        
        switch response {
        case .ok(let okResponse):
            switch okResponse.body {
            case .json(let draw):
                print(draw)
            }
            
        case .undocumented(statusCode: let statusCode, _):
            throw NetworkError.unexpectedResponse(statusCode: statusCode)
        }
    }
}


final class GameViewModel: ObservableObject {
    @Published var title: String
    @Published var numbers: [UInt]
    @Published var gameDate: String
    @Published var bonusText: String
    
    private let game: Game
    private let dateFormatter = DateFormatter()
    
    init(game: Game) {
        title = "Game #\(game.gameIdentifier)"
        
        if game.bonus > 1 {
            bonusText = "Bonus = \(game.bonus)x"
        } else {
            bonusText = "No bonus"
        }
        
        dateFormatter.dateStyle = .short
        
        gameDate = dateFormatter.string(from: game.date)
        numbers = game.numbers
        
        self.game = game
    }
    
    func select(number: UInt) {
        print("\(number) selected")
    }
}
