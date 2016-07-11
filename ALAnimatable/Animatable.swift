//
//  Animatable.swift
//  ALAnimatable
//
//  Created by Albert Mata Guerra on 09/07/16.
//  Copyright © 2016 Albert Mata Guerra. All rights reserved.
//

import UIKit

extension UIView: Animatable { }

public protocol Animatable {
    
    func animateSubviews(from direction: AnimatableDirection, destination: AnimatableDestination,
                              speed: AnimatableSpeed, origin: AnimatableOrigin,
                              bouncing: Bool, excluding: Set<UIView>)
    
}

extension Animatable where Self: UIView {
    
    public func animateSubviews(from direction: AnimatableDirection, destination: AnimatableDestination = .In,
                                     speed: AnimatableSpeed = .Medium, origin: AnimatableOrigin = .Close,
                                     bouncing: Bool = true, excluding: Set<UIView> = []) {
        
        let atts = attributes(direction)
        // Filtering not hidden views is not only useful per se but helps dealing with issues regarding UILayoutSupport.
        let including = Set(subviews.filter({!$0.hidden})).subtract(excluding)
        let damping: CGFloat = bouncing ? 0.5 : 1
        
        if destination == .In {
            constraints.forEach { constraint in
                guard let firstItem = constraint.firstItem as? UIView, secondItem = constraint.secondItem as? UIView else { return }
                if including.isDisjointWith([firstItem, secondItem]) { return }
                if !atts.isDisjointWith([constraint.firstAttribute, constraint.secondAttribute]) {
                    constraint.constant += origin.rawValue * direction.screenSize() * self.sign(constraint, superview: self, direction: direction)
                }
            }
            setNeedsLayout()
        }
        
        delay(0.01) {
            UIView.animateWithDuration(speed.rawValue, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: 0, options: [], animations: {
                self.constraints.forEach { constraint in
                    guard let firstItem = constraint.firstItem as? UIView, secondItem = constraint.secondItem as? UIView else { return }
                    if including.isDisjointWith([firstItem, secondItem]) { return }
                    if !atts.isDisjointWith([constraint.firstAttribute, constraint.secondAttribute]) {
                        constraint.constant -= origin.rawValue * direction.screenSize() * self.sign(constraint, superview: self, direction: direction)
                    }
                }
                self.layoutIfNeeded()
                }, completion: nil)
        }
        
    }
    
    private func attributes(direction: AnimatableDirection) -> Set<NSLayoutAttribute> {
        if direction == .Left || direction == .Right {
            return Set([.CenterX, .CenterXWithinMargins, .Leading, .LeadingMargin, .Left, .LeftMargin, .Right, .RightMargin, .Trailing, .TrailingMargin])
        } else {
            return Set([.Bottom, .BottomMargin, .CenterY, .CenterYWithinMargins, .Top, .TopMargin])
        }
    }
    
    private func sign(constraint: NSLayoutConstraint, superview: UIView, direction: AnimatableDirection) -> CGFloat {
        guard let firstItem = constraint.firstItem as? UIView, secondItem = constraint.secondItem as? UIView else { return 0 }
        if firstItem == superview || firstItem.hidden { return -1 * direction.sign() }
        if secondItem == superview || secondItem.hidden { return 1 * direction.sign() }
        return 0
    }
    
    private func delay(delay: Double, closure: () -> ()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
}

public enum AnimatableSpeed: NSTimeInterval {
    case Quick = 0.5
    case Medium = 1.0
    case Slow = 2.0
}

public enum AnimatableOrigin: CGFloat {
    case Close = 1
    case Far = 2
    case ReallyFar = 3
}

public enum AnimatableDestination {
    case In, Out
}

public enum AnimatableDirection {
    case Left, Right, Top, Bottom
    
    func sign() -> CGFloat {
        switch self {
        case .Left, .Top: return -1
        case .Right, .Bottom: return 1
        }
    }
    
    func screenSize() -> CGFloat {
        switch self {
        case .Left, .Right: return UIScreen.mainScreen().bounds.width
        case .Top, .Bottom: return UIScreen.mainScreen().bounds.height
        }
    }
}

