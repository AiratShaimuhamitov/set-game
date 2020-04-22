//
//  ViewController.swift
//  Concentration Stanford
//
//  Created by Айрат Шаймухамитов on 23.02.2020.
//  Copyright © 2020 Айрат Шаймухамитов. All rights reserved.
//

import UIKit

class ConcentrationViewController: UIViewController {
    
    private lazy var game = Concentration(numberOPairsOfCards: numberOPairsOfCards)
    
    var numberOPairsOfCards : Int {
        (cardButtons.count + 1) / 2
    }
    
    @IBAction private func startGameTouch(_ sender: UIButton) {
        game = Concentration(numberOPairsOfCards: (cardButtons.count + 1) / 2)
        randomThemeIndex = emojiThemes.count.arc4random
        emojiChoices = emojiThemes[randomThemeIndex]
        updateViewFromModel()
    }
    
    @IBOutlet private weak var flipCountLabel: UILabel!
    @IBOutlet private weak var scoreLabel: UILabel!
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        }
    }
    
    private func updateViewFromModel() {
        if cardButtons != nil {
            for index in cardButtons.indices {
                let button = cardButtons[index]
                let card = game.cards[index]
                if card.isFaceUp {
                    button.setTitle(emoji(for: card), for: UIControl.State.normal)
                    button.backgroundColor = .white
                } else {
                    button.setTitle("", for: UIControl.State.normal)
                    button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
                }
            }
            
            flipCountLabel.text = "Flips: \(game.tapCount)"
            scoreLabel.text = "Score: \(game.score)"
        }
    }
    
    var theme: [String]? {
        didSet {
            emojiChoices = theme ?? []
            emoji = [:]
            updateViewFromModel()
        }
    }
    
    private var emojiThemes = [
        ["🐶", "🐱", "🐰", "🦊", "🐻", "🐵", "🦁", "🐼", "🐷"],
        ["🍏", "🍊", "🍋", "🍌", "🍉", "🍇", "🍓", "🍑", "🥥"],
        ["⚽️", "🏀", "🥎", "🥊", "🏒", "⛸", "🎿", "🏊‍♂️", "🏂"],
        ["😄", "😎", "🤯", "😏", "🥳", "🥰", "🥴", "😵", "😇"],
        ["🚗", "🚆", "🚄", "🚁", "🛸", "⛴", "🏎", "🚀", "🚲"],
        ["🇧🇬", "🇾🇪", "🇬🇪", "🇹🇷", "🇮🇹", "🇧🇷", "🇦🇺", "🇬🇧", "🇪🇸"],
    ]
    
    private lazy var randomThemeIndex = emojiThemes.count.arc4random
    private lazy var emojiChoices = emojiThemes[randomThemeIndex]
    
    private var emoji = [ConcentrationCard: String]()
    
    private func emoji(for card: ConcentrationCard) -> String {
        if emoji[card] == nil, emojiChoices.count > 0 {
            emoji[card] = emojiChoices.remove(at: emojiChoices.count.arc4random)
        }
        
        return emoji[card] ?? "?"
    }
}
