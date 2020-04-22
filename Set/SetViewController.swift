//
//  ViewController.swift
//  Set
//
//  Created by Айрат Шаймухамитов on 19.03.2020.
//  Copyright © 2020 Айрат Шаймухамитов. All rights reserved.
//

import UIKit

class SetViewController: UIViewController {
    
    private var game = SetGame()
    
    @IBOutlet private weak var scoreLabel: UILabel!

    @IBOutlet private weak var deckCountLabel: UILabel! {
        didSet {
            deckCountLabel.translatesAutoresizingMaskIntoConstraints = true
        }
    }

    @IBOutlet weak var gameView: UIView!
    var deckView: UIView?
    var discardPileView: UIView?
    
    lazy var animator = UIDynamicAnimator(referenceView: gameView)
    
    private var cardsGridFrame: CGRect {
        get {
            let bounds = gameView.bounds
            if bounds.height > bounds.width {
                let gridHeight = bounds.height * (1.0 - SetViewController.gridLeftOffsetRatio)
                return CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.width, height: gridHeight)
            } else {
                let gridOffset = bounds.width * SetViewController.gridLeftOffsetRatio
                return CGRect(x: bounds.origin.x + gridOffset, y: bounds.origin.y, width: bounds.width - gridOffset, height: bounds.height)
            }
        }
    }
    
    private var deckViewFrame: CGRect {
        get {
            let bounds = gameView.bounds
            if bounds.height > bounds.width {
                let gridHeight = bounds.height * (1.0 - SetViewController.gridLeftOffsetRatio)
                return CGRect(x: bounds.origin.x, y: bounds.origin.y + gridHeight, width: bounds.width / 2, height: bounds.height - gridHeight).insetBy(dx: SetViewController.deckCardInset, dy: SetViewController.deckCardInset)
            } else {
                let gridOffset = bounds.width * SetViewController.gridLeftOffsetRatio
                return CGRect(x: bounds.origin.x, y: bounds.origin.y, width: gridOffset, height: bounds.height / 2).insetBy(dx: SetViewController.deckCardInset, dy: SetViewController.deckCardInset)
            }
        }
    }
    
    private var discardPileViewFrame: CGRect {
        get {
            let bounds = gameView.bounds
            if bounds.height > bounds.width {
                let gridHeight = bounds.height * (1.0 - SetViewController.gridLeftOffsetRatio)
                return CGRect(x: bounds.origin.x + bounds.width / 2, y: bounds.origin.y + gridHeight, width: bounds.width / 2, height: bounds.height - gridHeight).insetBy(dx: SetViewController.deckCardInset, dy: SetViewController.deckCardInset)
            } else {
                let gridOffset = bounds.width * SetViewController.gridLeftOffsetRatio
                return CGRect(x: bounds.origin.x, y: bounds.origin.y + bounds.height / 2, width: gridOffset, height: bounds.height / 2).insetBy(dx: SetViewController.deckCardInset, dy: SetViewController.deckCardInset)
            }
        }
    }
    
    private var cardViews = [SetCard: CardView]()
    
    private func getCardView(for card: SetCard) -> CardView {
        if cardViews[card] == nil {
            cardViews[card] = createCardViewByCard(card)
        }

        return cardViews[card] ?? CardView()
    }
    
    @IBAction private func shuffleTheCards(_ sender: UIRotationGestureRecognizer) {
        switch sender.state {
        case .ended:
            game.shuffleThePlayingCards()
            updateViewFromModel()
        default:
            break
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        updateViewFromModel()
    }
    
    private func updateViewFromModel() {
        scoreLabel.text = "Score: \(game.score)"
        deckCountLabel.text = "Deck: \(game.deckCount)"
        
        for card in cardViews.keys {
            if !game.playingCards.contains(card) {
                animateRemoval(for: cardViews[card]!)
                if let index = cardViews.index(forKey: card) {
                    cardViews.remove(at: index)
                }
            }
        }
        
        var newCardsCount = 0
        let cardsGrid = getCardsGrid(in: cardsGridFrame, for: game.playingCards.count)
        for (index, card) in game.playingCards.enumerated() {
            if !cardViews.keys.contains(card) { newCardsCount += 1 }
            let cardView = getCardView(for: card)
            let cardFrame = cardsGrid[index]!
            animatePosition(for: cardView, position: cardFrame, animationDelay: Double(newCardsCount))
            outlineCardViewByCard(card)
        }
        
        drawDeckView()
        drawDiscarPile()
    }
    
    private func animateRemoval(for cardView: CardView) {
        let behavior = UIGravityBehavior()
        behavior.addItem(cardView)
        animator.addBehavior(behavior)
        
        Timer.scheduledTimer(withTimeInterval: SetViewController.AnimationConstants.gravityDuration, repeats: false, block: { timer in
            behavior.removeItem(cardView)
            behavior.dynamicAnimator?.removeBehavior(behavior)
           
            UIView.transition(with: cardView, duration: 0.1, options: [], animations: { cardView.isFaceDown = true })
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: SetViewController.AnimationConstants.toDiscardPileFrameDuration, delay: 0,
                options: [.curveEaseInOut],
                animations: {
                    cardView.frame = self.discardPileViewFrame
                },
                completion: { if $0 == .end {
                    if self.discardPileView == nil {
                        self.discardPileView = UIView(frame: self.discardPileViewFrame)
                        self.gameView.addSubview(self.discardPileView!)
                        self.drawDiscarPile()
                    }
                    cardView.removeFromSuperview()
                }
            })
        })
    }

    private func animatePosition(for cardView: CardView, position: CGRect, animationDelay: Double) {
        UIViewPropertyAnimator
            .runningPropertyAnimator(
                withDuration: SetViewController.AnimationConstants.positionDuration,
                delay: SetViewController.AnimationConstants.positionDuration * animationDelay,
                options: [.curveEaseInOut],
                animations: {
                    if cardView.isFaceDown {
                        cardView.transform = cardView.transform.rotated(by: CGFloat.pi / 2)
                    }
                    cardView.frame = position.insetBy(dx: SetViewController.cardInset, dy: SetViewController.cardInset)
                },
                completion: { if $0 == .end {
                    if cardView.isFaceDown {
                        UIView.transition(with: cardView, duration: SetViewController.AnimationConstants.cardSwipeDuration, options: [.transitionFlipFromLeft], animations: { cardView.isFaceDown = false })
                    }
                }}
        )
        
        gameView.addSubview(cardView)
    }
    
    private func getCardsGrid(in frame: CGRect, for cardsCount: Int) -> Grid {
        var offset = 0.0
        var rowCount = 0
        var columnCount = 0
        var cardWidth = CGFloat(0)
        var cardHeight = CGFloat(0)
        
        while rowCount * columnCount < cardsCount {
            cardWidth = frame.width / (CGFloat(cardsCount).squareRoot() + CGFloat(offset))
            cardHeight = cardWidth / SetViewController.cardWidthToHeightRatio
            columnCount = Int(frame.width / cardWidth)
            rowCount = Int(frame.height / cardHeight)
            offset += 0.02
        }
        
        return Grid(layout: .fixedCellSize(CGSize(width: cardWidth, height: cardHeight)), frame: frame)
    }
    
    @objc private func touchCard(_ sender: UITapGestureRecognizer) {
        if let cardView = sender.view as? CardView {
            if let card = cardViews.first(where: { $0.value == cardView })?.key {
                if let index = game.playingCards.firstIndex(of: card) {
                    game.chooseCard(at: index)
                    updateViewFromModel()
                    
                    if game.selectedCards.count > 0 && game.selectedCards.allSatisfy(game.matchedCards.contains) {
                        game.removeMatchedAndTakeCards()
                    }
                }
            }
        }
    }
    
    @objc private func dealMoreCardsTouch(_ sender: UITapGestureRecognizer) {
        game.removeMatchedAndTakeCards()
        updateViewFromModel()
    }
    
    private func createCardViewByCard(_ card: SetCard) -> CardView? {
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
        cardView.layer.cornerRadius = SetViewController.cardCornerRadius
        cardView.transform = cardView.transform.rotated(by: -CGFloat.pi / 2)
        
        let touch = UITapGestureRecognizer(target: self, action: #selector(touchCard))
        cardView.addGestureRecognizer(touch)
        
        cardView.backgroundColor = .systemBackground
        cardView.frame = deckViewFrame
        return cardView
    }
    
    private func outlineCardViewByCard(_ card: SetCard) {
        let cardView = getCardView(for: card)
        
        cardView.layer.borderColor = UIColor.gray.cgColor
        cardView.layer.borderWidth = SetViewController.borderWidth - 1
        cardView.layer.masksToBounds = true
        
        if game.selectedCards.contains(card) {
            cardView.layer.borderColor = UIColor.blue.cgColor
            cardView.layer.borderWidth = SetViewController.borderWidth
        }
        if game.matchedCards.contains(card) {
            cardView.layer.borderColor = UIColor.green.cgColor
            cardView.layer.borderWidth = SetViewController.borderWidth
        }
        if game.unmatchedCards.contains(card) {
            cardView.layer.borderColor = UIColor.red.cgColor
            cardView.layer.borderWidth = SetViewController.borderWidth
        }
    }
    
    private func drawDeckView() {
        if deckView == nil {
            deckView = UIView(frame: deckViewFrame)
            gameView.addSubview(deckView!)
        }
        
        if let deckView = deckView {
            deckView.layer.cornerRadius = SetViewController.cardCornerRadius
            deckView.layer.borderWidth = SetViewController.borderWidth
            deckView.layer.masksToBounds = true
            deckView.frame = deckViewFrame
            
            if game.deckCount > 0 {
                deckView.backgroundColor = .red
                deckView.layer.borderColor = UIColor.yellow.cgColor
            } else {
                deckView.backgroundColor = .systemBackground
                deckView.layer.borderColor = UIColor.gray.cgColor
            }
            
            let touch = UITapGestureRecognizer(target: self, action: #selector(dealMoreCardsTouch))
            deckView.addGestureRecognizer(touch)
        }
    }
    
    private func drawDiscarPile() {
        if let discardPileView = discardPileView {
            discardPileView.layer.cornerRadius = SetViewController.cardCornerRadius
            discardPileView.layer.borderColor = UIColor.yellow.cgColor
            discardPileView.layer.borderWidth = SetViewController.borderWidth
            discardPileView.layer.masksToBounds = true
            discardPileView.frame = discardPileViewFrame
            discardPileView.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
            discardPileView.layer.zPosition = 10
        }
    }
}

extension SetViewController {
    private static let cardCornerRadius = CGFloat(8.0)
    private static let borderWidth = CGFloat(2.0)
    private static let gridLeftOffsetRatio = CGFloat(0.15)
    private static let deckCardInset = CGFloat(10.0)
    private static let cardWidthToHeightRatio = CGFloat(5.0 / 8.0)
    private static let cardInset = CGFloat(4.0)
    
    private struct AnimationConstants {
        static let positionDuration = 0.4
        static let cardSwipeDuration = 0.5
        static let gravityDuration = 1.5
        static let toDiscardPileFrameDuration = 1.5
    }
}

