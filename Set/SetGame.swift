//
//  Set.swift
//  Set
//
//  Created by Айрат Шаймухамитов on 19.03.2020.
//  Copyright © 2020 Айрат Шаймухамитов. All rights reserved.
//

import Foundation

public class SetGame {
    private var deck = [Card]()
    var deckCount: Int { deck.count }
    
    private(set) var selectedCards = [Card]()
    private(set) var playingCards = [Card]()
    private(set) var matchedCards = [Card]()
    var unmatchedCards: [Card] {
        return selectedCards.count == setCardsCount ? selectedCards.filter {!matchedCards.contains($0)} : []
    }
    
    private(set) var score = 0
    
    // set game constants taken from rules
    private let setCardsCount = 3
    private let attributesCount = 3
    private let initialPlayingCardsCount = 12
    
    init() {
        generateCards()
        playingCards += deck[0..<initialPlayingCardsCount]
        deck.removeFirst(initialPlayingCardsCount)
    }
    
    private func generateCards() {
        for number in 0..<attributesCount {
            for color in 0..<attributesCount {
                for shape in 0..<attributesCount {
                    for shading in 0..<attributesCount {
                        let card = Card(number: color, color: number, shape: shape, shading: shading)
                        self.deck.append(card)
                    }
                }
            }
        }
        shuffleTheDeckCards()
    }
    
    public func shuffleThePlayingCards() {
        for _ in playingCards.indices {
            playingCards.swapAt(playingCards.count.arc4random, playingCards.count.arc4random)
        }
    }
    
    private func shuffleTheDeckCards() {
        for _ in deck.indices {
            deck.swapAt(deck.count.arc4random, deck.count.arc4random)
        }
    }
    
    public func chooseCard(at index: Int) {
        if playingCards.count > index && !matchedCards.contains(playingCards[index]) {
            if selectedCards.count == setCardsCount {
                selectedCards.removeAll()
            }
            if selectedCards.contains(playingCards[index]) {
                selectedCards.remove(at: selectedCards.firstIndex(of: playingCards[index])!)
            } else {
                selectedCards.append(playingCards[index])
                if selectedCards.count == setCardsCount {
                    if validate(set: selectedCards) {
                        matchedCards += selectedCards
                        score += Score.matched
                    } else {
                        score -= Score.unmatched
                    }
                    return
                }
            }
            let mathcedCardsToRemove = playingCards.filter { matchedCards.contains($0) }
            if mathcedCardsToRemove.count > 0 {
                removeMatchedAndTakeCards()
            }
        }
    }
    
    public func removeMatchedAndTakeCards() {
        if selectedCards.count == setCardsCount {
            selectedCards.removeAll()
        }
        if deck.count >= setCardsCount {
            let cardsToRemove = playingCards.filter { matchedCards.contains($0) }
            if cardsToRemove.count > 0 {
                for cardToRemove in cardsToRemove {
                    let index = playingCards.firstIndex(of: cardToRemove)!
                    playingCards[index] = deck.removeFirst()
                }
            } else {
                playingCards += deck[0..<setCardsCount]
                deck.removeFirst(setCardsCount)
            }
        } else {
            playingCards.removeAll { matchedCards.contains($0) }
        }
    }
    
    private func validate(set cards: [Card]) -> Bool {
        for attributeIndex in 0...attributesCount {
            let specificAttributes = cards.map { $0.attributes[attributeIndex] }

            if !(specificAttributes.allTheSame || specificAttributes.allUnique) {
                return false
            }
        }
        
        return true
    }
}

extension SetGame {
    private struct Score {
        static let matched = 3
        static let unmatched = 5
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return Int(arc4random_uniform(UInt32(abs(self))))
        }
        return 0
    }
}

extension Array where Element: Hashable {
    var allUnique: Bool {
        if let firstItem = self.first {
            return self.allSatisfy { $0 == firstItem }
        }
        return true
    }
    
    var allTheSame : Bool {
        let set = Set(self)
        if set.count == self.count {
            return true
        }
        return false
    }
}
