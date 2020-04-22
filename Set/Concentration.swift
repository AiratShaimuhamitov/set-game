//
//  Concentration.swift
//  Concentration Stanford
//
//  Created by Айрат Шаймухамитов on 23.02.2020.
//  Copyright © 2020 Айрат Шаймухамитов. All rights reserved.
//

import Foundation

class Concentration {
    
    private(set) var cards = [ConcentrationCard]()
    
    private(set) var tapCount = 0
    
    private(set) var score = 0
    
    private var indexOfOneAndOnlyOneFaceUpCard: Int? {
        get {
            return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    private var facedUpCardsIndecies = [Int]()
    
    func chooseCard(at index: Int) {
        if !cards[index].isMatched {
            tapCount += 1
            
            if let matchedIndex = indexOfOneAndOnlyOneFaceUpCard, matchedIndex != index {
                // check if cards match
                if cards[matchedIndex] == cards[index] {
                    cards[matchedIndex].isMatched = true
                    cards[index].isMatched = true
                    score += 2
                } else {
                    if facedUpCardsIndecies.contains(index) {
                        if (score > 0) {
                            score -= 1
                        }
                    } else {
                        facedUpCardsIndecies.append(index)
                    }
                }
                cards[index].isFaceUp = true
            } else {
                indexOfOneAndOnlyOneFaceUpCard = index
               
                if !facedUpCardsIndecies.contains(index) {
                    facedUpCardsIndecies.append(index)
                }
            }
        }
    }
    
    init(numberOPairsOfCards: Int) {
        for _ in 0..<numberOPairsOfCards {
            let card = ConcentrationCard()
            cards += [card, card]
        }
        shuffleTheCards()
    }
    
    func shuffleTheCards() {
        for _ in cards.indices {
            let firstRandomIndex = cards.count.arc4random
            let secondRandomIndex = cards.count.arc4random
            cards.swapAt(firstRandomIndex, secondRandomIndex)
        }
    }
}


extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
