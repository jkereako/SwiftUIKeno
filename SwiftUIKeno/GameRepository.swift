//
//  GameRepository.swift
//  SwiftUIKeno
//
//  Created by Jeffrey Kereakoglow on 2/7/24.
//

import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

struct NumberModel {
    let number: Int32
    let frequency: Double
}

struct GameModel {
    let bonus: Int32
    let frequency: Double
}

final class GameRepository {
    private let client: APIProtocol
    
    init(client: APIProtocol) {
        self.client = client
    }
    
    func hotNumbers() async throws -> [NumberModel] {
        let response = try await client.hotNumbers()
        
        switch response {
        case .ok(let okResponse):
            switch okResponse.body {
            case .json(let draw):
                return draw.hotNumbers.map {
                    NumberModel(
                        number: $0.winningNumber,
                        frequency: $0.drawFrequency
                    )
                }

            }
            
        case .undocumented(statusCode: let statusCode, _):
            throw NetworkError.unexpectedResponse(statusCode: statusCode)
        }
    }
    
    func coldNumbers() async throws -> [NumberModel] {
        let response = try await client.hotNumbers()
        
        switch response {
        case .ok(let okResponse):
            switch okResponse.body {
            case .json(let draw):
                return draw.hotNumbers.map {
                    NumberModel(
                        number: $0.winningNumber,
                        frequency: $0.drawFrequency
                    )
                }

            }
            
        case .undocumented(statusCode: let statusCode, _):
            throw NetworkError.unexpectedResponse(statusCode: statusCode)
        }
    }
    
    func latestDraw() async throws {
        let response = try await client.latestDraw()
        
        switch response {
        case .ok(let okResponse):
            switch okResponse.body {
            case .json(let draw):
                draw.
                print(draw)
            }
            
        case .undocumented(statusCode: let statusCode, _):
            throw NetworkError.unexpectedResponse(statusCode: statusCode)
        }
    }
}

private extension GameRepository {
    enum NumberTemperature {
        case hot
        case cold
    }
    
    func hotColdNumbers(temperature: NumberTemperature) async throws -> [NumberModel] {
        let response = try await client.hotNumbers()
        switch response {
        case .ok(let okResponse):
            switch okResponse.body {
            case .json(let draw):
                switch temperature {
                case .hot:
                    return draw.hotNumbers.map {
                        NumberModel(
                            number: $0.winningNumber,
                            frequency: $0.drawFrequency
                        )
                    }
                case .cold:
                    return draw.coldNumbers.map {
                        NumberModel(
                            number: $0.winningNumber,
                            frequency: $0.drawFrequency
                        )
                    }
                }
            }
            
        case .undocumented(statusCode: let statusCode, _):
            throw NetworkError.unexpectedResponse(statusCode: statusCode)
        }
    }
}
