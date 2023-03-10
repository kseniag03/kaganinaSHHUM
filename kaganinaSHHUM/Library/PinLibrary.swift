//
//  PinLibrary.swift
//  kaganinaSHHUM
//

import UIKit

extension UIView {
    @discardableResult
    func pinTop(to superview: UIView, _ const: CGFloat = 0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = topAnchor.constraint(
            equalTo: superview.topAnchor,
            constant: CGFloat(const)
        )
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func pinTop(to side: NSLayoutYAxisAnchor, _ const: CGFloat = 0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = topAnchor.constraint(
            equalTo: side,
            constant: CGFloat(const)
        )
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func pinBottom(to superview: UIView, _ const: CGFloat = 0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = bottomAnchor.constraint(
            equalTo: superview.topAnchor,
            constant: CGFloat(const * -1)
        )
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func pinBottom(to side: NSLayoutYAxisAnchor, _ const: CGFloat = 0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = bottomAnchor.constraint(
            equalTo: side,
            constant: CGFloat(const * -1)
        )
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func pinLeft(to superview: UIView, _ const: CGFloat = 0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = leadingAnchor.constraint(
            equalTo: superview.leadingAnchor,
            constant: CGFloat(const)
        )
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func pinLeft(to side: NSLayoutXAxisAnchor, _ const: CGFloat = 0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = leadingAnchor.constraint(
            equalTo: side,
            constant: CGFloat(const)
        )
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func pinRight(to superview: UIView, _ const: CGFloat = 0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = trailingAnchor.constraint(
            equalTo: superview.trailingAnchor,
            constant: CGFloat(const * -1)
        )
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func pinRight(to side: NSLayoutXAxisAnchor, _ const: CGFloat = 0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = trailingAnchor.constraint(
            equalTo: side,
            constant: CGFloat(const * -1)
        )
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func pinWidth(to side: NSLayoutDimension, _ const: CGFloat = 0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = widthAnchor.constraint(
            equalTo: side,
            constant: CGFloat(const)
        )
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func pinHeight(to side: NSLayoutDimension, _ const: CGFloat = 0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = heightAnchor.constraint(
            equalTo: side,
            constant: CGFloat(const)
        )
        constraint.isActive = true
        return constraint
    }
}
