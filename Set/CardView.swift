//
//  SquareShapeView.swift
//  Set
//
//  Created by Айрат Шаймухамитов on 29.03.2020.
//  Copyright © 2020 Айрат Шаймухамитов. All rights reserved.
//

import UIKit

@IBDesignable
class CardView: UIView {
    
    var color: Color = .purple
    var number: Number = .three
    var shading: Shading = .empty
    var shape: Shape = .squiggle
    
    init(shape: Shape, shading: Shading, color: Color, number: Number) {
        self.shape = shape
        self.shading = shading
        self.color = color
        self.number = number
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func draw(_ rect: CGRect) {
        color.uiColor.setStroke()
        var rectsToDraw = [CGRect]()
        
        switch number {
        case .one:
            rectsToDraw.append(CGRect(x: rect.origin.x, y: rect.origin.y + rect.height / 3, width: rect.width, height: rect.height / 3))
        case .two:
            rectsToDraw.append(CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.width, height: rect.height / 2))
            rectsToDraw.append(CGRect(x: rect.origin.x, y: rect.origin.y + rect.height / 2, width: rect.width, height: rect.height / 2))
        case .three:
            rectsToDraw.append(CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.width, height: rect.height / 3))
            rectsToDraw.append(CGRect(x: rect.origin.x, y: rect.origin.y + rect.height / 3, width: rect.width, height: rect.height / 3))
            rectsToDraw.append(CGRect(x: rect.origin.x, y: rect.origin.y + 2 * rect.height / 3, width: rect.width, height: rect.height / 3))
        }
        
        let shapePath = UIBezierPath()
        for rectToDraw in rectsToDraw {
            drawShape(in: rectToDraw, withPath: shapePath)
        }
        drawShading(in: rect, withPath: shapePath)
    }
    
    private func drawShape(in rect: CGRect, withPath path: UIBezierPath) {
        switch shape {
        case .oval:
            drawOval(in: rect, withPath: path)
        case .diamond:
            drawDiamond(in: rect, withPath: path)
        case .squiggle:
            drawSquiggle(in: rect, withPath: path)
        }
        path.stroke()
    }
    
    private func drawOval(in rect: CGRect, withPath path: UIBezierPath) {
        let width = rect.width
        let height = rect.height

        let radius = width * 0.20
        let offset = CGFloat(0.75)
        let origin = CGPoint(x: width * (1 - offset), y: rect.origin.y + height / 2)
        path.move(to: CGPoint(x: width * offset - radius, y: origin.y + radius))
        path.addArc(withCenter: CGPoint(x: origin.x, y: origin.y), radius: radius, startAngle: .pi/2, endAngle: -.pi/2, clockwise: true)
        path.addLine(to: CGPoint(x: width * offset - radius, y: origin.y - radius))
        path.addArc(withCenter: CGPoint(x: width * offset, y: origin.y), radius: radius, startAngle: -.pi/2, endAngle: .pi/2, clockwise: true)
        path.addLine(to: CGPoint(x: origin.x, y: origin.y + radius))
    }
    
    private func drawDiamond(in rect: CGRect, withPath path: UIBezierPath) {
        let offset = CGFloat(rect.height * 0.1)
        
        path.move(to: CGPoint(x: offset, y: rect.origin.y + rect.height / 2))
        path.addLine(to: CGPoint(x: rect.width / 2, y: rect.origin.y + offset))
        path.addLine(to: CGPoint(x: rect.width - offset, y: rect.origin.y + rect.height / 2))
        path.addLine(to: CGPoint(x: rect.width / 2, y: rect.origin.y + rect.height - offset))
        path.close()
    }
    
    private func drawSquiggle(in rect: CGRect, withPath path: UIBezierPath) {
        let width = rect.width
        let height = rect.height
        path.move(to: CGPoint(x: width * 0.94545, y: rect.origin.y + height * 0.21429))
        path.addCurve(to: CGPoint(x: width * 0.57273, y: rect.origin.y + height * 0.77143),
                           controlPoint1: CGPoint(x: width * 1.02182, y: rect.origin.y + height * 0.52714),
                           controlPoint2: CGPoint(x: width * 0.81545, y: rect.origin.y + height * 0.86857))
        
        path.addCurve(to: CGPoint(x: width * 0.24545, y: rect.origin.y + height * 0.75714),
                           controlPoint1: CGPoint(x: width * 0.47545, y: rect.origin.y + height * 0.73286),
                           controlPoint2: CGPoint(x: width * 0.38364, y: rect.origin.y + height * 0.6))
        
        path.addCurve(to: CGPoint(x: width * 0.04545, y: rect.origin.y + height * 0.57143),
                           controlPoint1: CGPoint(x: width * 0.08727, y: rect.origin.y + height * 0.93714),
                           controlPoint2: CGPoint(x: width * 0.04909, y: rect.origin.y + height * 0.83286))
        
        path.addCurve(to: CGPoint(x: width * 0.32727, y: rect.origin.y + height * 0.17143),
                           controlPoint1: CGPoint(x: width * 0.04182, y: rect.origin.y + height * 0.31429),
                           controlPoint2: CGPoint(x: width * 0.17364, y: rect.origin.y + height * 0.13857))
        
        path.addCurve(to: CGPoint(x: width * 0.80909, y: rect.origin.y + height * 0.2),
                           controlPoint1: CGPoint(x: width * 0.53818, y: rect.origin.y + height * 0.21714),
                           controlPoint2: CGPoint(x: width * 0.56273, y: rect.origin.y + height * 0.45000))
        
        path.addCurve(to: CGPoint(x: width * 0.94545, y: rect.origin.y + height * 0.21429),
                           controlPoint1: CGPoint(x: width * 0.86636, y: rect.origin.y + height * 0.14286),
                           controlPoint2: CGPoint(x: width * 0.91727, y: rect.origin.y + height * 0.09857))
    }
    
    private func drawShading(in rect: CGRect, withPath path: UIBezierPath) {
        path.addClip()
        switch shading {
        case .solid:
            color.uiColor.setFill()
            path.fill()
        case .striped:
            let stridePath = UIBezierPath()
            for width in stride(from: 0, to: rect.width, by: 3) {
                stridePath.move(to: CGPoint(x: width, y: 0))
                stridePath.addLine(to: CGPoint(x: width, y: rect.height))
            }
            stridePath.stroke()
        default:
            break
        }
    }
}

enum Shading: Int {
    case solid, striped, empty
}

enum Shape: Int {
    case diamond, oval, squiggle
}

enum Number: Int {
    case one, two, three
}

enum Color: Int {
    case red, green, purple
    
    var uiColor: UIColor {
        get {
            switch self {
            case .red:
                return UIColor.red
            case .green:
                return UIColor(red: 34.0/255.0, green: 139.0/255.0, blue: 34.0/255.0, alpha: 1)
            case .purple:
                return UIColor(red: 138.0/255.0, green: 43.0/255.0, blue: 226.0/255.0, alpha: 1)
            }
        }
    }
}
