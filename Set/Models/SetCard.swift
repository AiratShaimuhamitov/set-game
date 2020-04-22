//
//  Card.swift
//  Set
//
//  Created by Айрат Шаймухамитов on 19.03.2020.
//  Copyright © 2020 Айрат Шаймухамитов. All rights reserved.
//

import Foundation

struct SetCard : Hashable {
    private var identifier: Int
    
    var attributes: [Int] {
        return [number, color, shape, shading]
    }
    
    private(set) var number: Int
    private(set) var color: Int
    private(set) var shape: Int
    private(set) var shading: Int
    
    private static var identifierFactory = 0
    
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init(number: Int, color: Int, shape: Int, shading: Int) {
        identifier = SetCard.getUniqueIdentifier()
        
        self.number = number
        self.color = color
        self.shape = shape
        self.shading = shading
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    static func == (lhs: SetCard, rhs: SetCard) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
