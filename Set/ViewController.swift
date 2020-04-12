//
//  ViewController.swift
//  Set
//
//  Created by Айрат Шаймухамитов on 19.03.2020.
//  Copyright © 2020 Айрат Шаймухамитов. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var game = SetGame()
    
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var deckCountLabel: UILabel!

    @IBOutlet private weak var cardsDeckView: CardsGridView!

    @IBAction private func dealMoreCardsSwipe(_ sender: Any) {
        game.removeMatchedAndTakeCards()
        updateViewFromModel()
    }
    
    @IBAction private func shuffleTheCards(_ sender: Any) {
        game.shuffleThePlayingCards()
        updateViewFromModel()
    }
    
    @IBOutlet private weak var moreCardsButton: UIButton!

    @IBAction private func moreCardsTouch(_ sender: UIButton) {
        game.removeMatchedAndTakeCards()
        updateViewFromModel()
    }
    
    @IBAction private func newGameTouch(_ sender: UIButton) {
        game = SetGame()
        updateViewFromModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateViewFromModel()
    }
    
    private func updateViewFromModel() {
        let playingCards = game.playingCards
        let cardViews = playingCards.map { getCardViewByCard($0) }.compactMap { $0 }
        
        cardsDeckView.cardViews = cardViews
        scoreLabel.text = "Score: \(game.score)"
        deckCountLabel.text = "Deck: \(game.deckCount)"
    }
    
    @objc private func touchCard(_ sender: UITapGestureRecognizer) {
        if let cardView = sender.view as? CardView {
            let touchedCardIndex = cardsDeckView.cardViews.firstIndex(of: cardView)
            if let index = touchedCardIndex {
                game.chooseCard(at: index)
                updateViewFromModel()
            }
        }
    }
    
    private func getCardViewByCard(_ card: Card) -> CardView? {
        guard let shape = Shape(rawValue: card.shape) else {
            print("Can't find shape for index = \(card.shape)")
            return nil
        }
        guard let shading = Shading(rawValue: card.shading) else {
            print("Can't find shading for index = \(card.shading)")
            return nil
        }
        guard let number = Number(rawValue: card.number) else {
            print("Can't find number for index = \(card.number)")
            return nil
        }
        guard let color = Color(rawValue: card.color) else {
            print("Can't find color for index = \(card.color)")
            return nil
        }
        
        let cardView: CardView = CardView(shape: shape, shading: shading, color: color, number: number)
        cardView.layer.cornerRadius = 6.0
        
        cardView.layer.borderColor = UIColor.gray.cgColor
        cardView.layer.borderWidth = 1.0
        
        if game.selectedCards.contains(card) {
            cardView.layer.borderColor = UIColor.blue.cgColor
            cardView.layer.borderWidth = 2.0
        }
        if game.matchedCards.contains(card) {
            cardView.layer.borderColor = UIColor.green.cgColor
            cardView.layer.borderWidth = 2.0
        }
        if game.unmatchedCards.contains(card) {
            cardView.layer.borderColor = UIColor.red.cgColor
            cardView.layer.borderWidth = 2.0
        }
        
        let touch = UITapGestureRecognizer(target: self, action: #selector(touchCard))
        cardView.addGestureRecognizer(touch)
        
        cardView.backgroundColor = .white
        return cardView
    }
}

