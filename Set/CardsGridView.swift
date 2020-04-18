//
//  CardsDeckView.swift
//  Set
//
//  Created by Айрат Шаймухамитов on 11.04.2020.
//  Copyright © 2020 Айрат Шаймухамитов. All rights reserved.
//

import UIKit

class CardsGridView: UIView {
    
    var cardViews = [CardView]() { didSet { setNeedsDisplay(); setNeedsLayout() } }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsDisplay()
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.subviews.forEach { $0.removeFromSuperview() }
        
        var offest = 0.0
        var cellCount = 0
        var cardsGrid: Grid?
        
        while cellCount < cardViews.count {
            let width = self.bounds.width / (CGFloat(cardViews.count).squareRoot() + CGFloat(offest))
            let height = width / CardsGridView.cardWidthToHeightRatio
            
            cardsGrid = Grid(layout: .fixedCellSize(CGSize(width: width, height: height)), frame: self.bounds)
            cellCount = cardsGrid!.cellCount
            offest += 0.02
        }
        
        for cardView in cardViews {
            let cardViewIndex = cardViews.firstIndex(of: cardView)!
            if let gridCell = cardsGrid![cardViewIndex] {
                cardView.frame = gridCell
                cardView.frame = cardView.frame.insetBy(dx: CardsGridView.cardInset, dy: CardsGridView.cardInset)
                addSubview(cardView)
            }
        }
    }
}

extension CardsGridView {
    private static let cardWidthToHeightRatio = CGFloat(5.0 / 8.0)
    private static let cardInset = CGFloat(4.0)
}
