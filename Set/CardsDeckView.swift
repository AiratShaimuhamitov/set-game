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
        
//        let rows = Int((Double(cardViews.count) / 4.0).rounded(.awayFromZero))

        let cardsGrid = Grid(layout: .fixedCellSize(CGSize(width: 50.0, height: 70.0)), frame: self.bounds)
        
        for cardView in cardViews {
            let cardViewIndex = cardViews.firstIndex(of: cardView)!
            if let gridCell = cardsGrid[cardViewIndex] {
                cardView.frame = gridCell
                cardView.frame = cardView.frame.insetBy(dx: 4.0, dy: 4.0)
                addSubview(cardView)
            }
        }
    }
}

extension CardsGridView {
    private static let columnsMinimum = 3
}
