//
//  UIView.swift
//  Reminder
//
//  Created by Mert Ozseven on 17.01.2025.
//

import UIKit

extension UIView {

    /// Add dismiss keyboard gesture to view
    func addDismissKeyboardGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(UIView.endEditing))
        tapGesture.cancelsTouchesInView = false
        addGestureRecognizer(tapGesture)
    }

    /// A comprehensive utility method to simplify and streamline the setup of Auto Layout constraints programmatically.
    ///
    /// - Parameters:
    ///   - top: Constrains the top anchor to the specified `NSLayoutYAxisAnchor`. Defaults to `nil`.
    ///   - paddingTop: Padding from the top anchor. Defaults to `0`.
    ///   - bottom: Constrains the bottom anchor to the specified `NSLayoutYAxisAnchor`. Defaults to `nil`.
    ///   - paddingBottom: Padding from the bottom anchor. Defaults to `0`.
    ///   - leading: Constrains the leading anchor to the specified `NSLayoutXAxisAnchor`. Defaults to `nil`.
    ///   - paddingLeading: Padding from the leading anchor. Defaults to `0`.
    ///   - trailing: Constrains the trailing anchor to the specified `NSLayoutXAxisAnchor`. Defaults to `nil`.
    ///   - paddingTrailing: Padding from the trailing anchor. Defaults to `0`.
    ///   - safeArea: If `true`, uses safe area anchors for top, bottom, leading, and trailing. Defaults to `false`.
    ///   - centerX: Constrains the centerX anchor to the specified `NSLayoutXAxisAnchor`. Defaults to `nil`.
    ///   - paddingCenterX: Offset for the centerX anchor. Defaults to `0`.
    ///   - centerY: Constrains the centerY anchor to the specified `NSLayoutYAxisAnchor`. Defaults to `nil`.
    ///   - paddingCenterY: Offset for the centerY anchor. Defaults to `0`.
    ///   - width: Fixed width constraint. If `0`, no width constraint is applied. Defaults to `0`.
    ///   - height: Fixed height constraint. If `0`, no height constraint is applied. Defaults to `0`.
    ///   - dynamicWidth: Constrains width using another `NSLayoutDimension`. Defaults to `nil`.
    ///   - dynamicHeight: Constrains height using another `NSLayoutDimension`. Defaults to `nil`.
    ///   - aspectRatio: Aspect ratio (width divided by height). Overrides width and height if specified. Defaults to `nil`.
    ///   - priority: Priority for constraints. Defaults to `.required`.
    ///
    func setupAnchors(
        top: NSLayoutYAxisAnchor? = nil,
        paddingTop: CGFloat = 0,
        bottom: NSLayoutYAxisAnchor? = nil,
        paddingBottom: CGFloat = 0,
        leading: NSLayoutXAxisAnchor? = nil,
        paddingLeading: CGFloat = 0,
        trailing: NSLayoutXAxisAnchor? = nil,
        paddingTrailing: CGFloat = 0,
        safeArea: Bool = false,
        centerX: NSLayoutXAxisAnchor? = nil,
        paddingCenterX: CGFloat = 0,
        centerY: NSLayoutYAxisAnchor? = nil,
        paddingCenterY: CGFloat = 0,
        width: CGFloat = 0,
        height: CGFloat = 0,
        dynamicWidth: NSLayoutDimension? = nil,
        dynamicHeight: NSLayoutDimension? = nil,
        aspectRatio: CGFloat? = nil,
        priority: UILayoutPriority = .required
    ) {
        translatesAutoresizingMaskIntoConstraints = false

        if let top = top {
            let anchor = safeArea ? superview?.safeAreaLayoutGuide.topAnchor ?? top : top
            let constraint = topAnchor.constraint(equalTo: anchor, constant: paddingTop)
            constraint.priority = priority
            constraint.isActive = true
        }

        if let bottom = bottom {
            let anchor = safeArea ? superview?.safeAreaLayoutGuide.bottomAnchor ?? bottom : bottom
            let constraint = bottomAnchor.constraint(equalTo: anchor, constant: -paddingBottom)
            constraint.priority = priority
            constraint.isActive = true
        }

        if let leading = leading {
            let anchor = safeArea ? superview?.safeAreaLayoutGuide.leadingAnchor ?? leading : leading
            let constraint = leadingAnchor.constraint(equalTo: anchor, constant: paddingLeading)
            constraint.priority = priority
            constraint.isActive = true
        }

        if let trailing = trailing {
            let anchor = safeArea ? superview?.safeAreaLayoutGuide.trailingAnchor ?? trailing : trailing
            let constraint = trailingAnchor.constraint(equalTo: anchor, constant: -paddingTrailing)
            constraint.priority = priority
            constraint.isActive = true
        }

        if let centerX = centerX {
            let constraint = centerXAnchor.constraint(equalTo: centerX, constant: paddingCenterX)
            constraint.priority = priority
            constraint.isActive = true
        }

        if let centerY = centerY {
            let constraint = centerYAnchor.constraint(equalTo: centerY, constant: paddingCenterY)
            constraint.priority = priority
            constraint.isActive = true
        }

        if width != 0 {
            let constraint = widthAnchor.constraint(equalToConstant: width)
            constraint.priority = priority
            constraint.isActive = true
        }

        if height != 0 {
            let constraint = heightAnchor.constraint(equalToConstant: height)
            constraint.priority = priority
            constraint.isActive = true
        }

        if let dynamicWidth = dynamicWidth {
            let constraint = widthAnchor.constraint(equalTo: dynamicWidth)
            constraint.priority = priority
            constraint.isActive = true
        }

        if let dynamicHeight = dynamicHeight {
            let constraint = heightAnchor.constraint(equalTo: dynamicHeight)
            constraint.priority = priority
            constraint.isActive = true
        }

        if let aspectRatio = aspectRatio {
            let constraint = widthAnchor.constraint(equalTo: heightAnchor, multiplier: aspectRatio)
            constraint.priority = priority
            constraint.isActive = true
        }
    }

}
