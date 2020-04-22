//
//  Card.swift
//  Concentration Stanford
//
//  Created by Айрат Шаймухамитов on 23.02.2020.
//  Copyright © 2020 Айр ат Шаймухамитов. All rights reserved.
//

import Foundation

struct ConcentrationCard : Hashable {
    var isFaceUp = false
    var isMatched = false
    private var identifier: Int
    
    private static var identifierFactory = 0
    
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init() {
        identifier = ConcentrationCard.getUniqueIdentifier()
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    static func == (lhs: ConcentrationCard, rhs: ConcentrationCard) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
