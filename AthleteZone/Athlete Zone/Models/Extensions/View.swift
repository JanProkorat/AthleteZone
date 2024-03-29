//
//  View.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 07.12.2022.
//

import Foundation
import SwiftUI

extension View {
    func performAction(_ action: (() -> Void)?) {
        if let localAction = action {
            localAction()
        }
    }

    func performAction<T>(_ action: ((_ value: T) -> Void)?, value: T) {
        if let localAction = action {
            localAction(value)
        }
    }

    func performAction<T>(_ action: ((_ values: [T]) -> Void)?, values: [T]) {
        if let localAction = action {
            localAction(values)
        }
    }

    func roundedBackground(cornerRadius: CGFloat, color: ComponentColor = ComponentColor.menu) -> some View {
        return self
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .foregroundColor(Color(color.rawValue))
            )
    }

    func roundedBackground(cornerRadius: CGFloat, color: Color) -> some View {
        return self
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .foregroundColor(color)
            )
    }

    func roundedBackground(cornerRadius: CGFloat, color: ComponentColor, border: ComponentColor) -> some View {
        return self
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(Color(border.rawValue), lineWidth: 5)
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .foregroundColor(Color(color.rawValue))
                }
            )
    }

    func roundedBackground(cornerRadius: CGFloat, color: ComponentColor, border: ComponentColor, borderWidth: CGFloat) -> some View {
        return self
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(Color(border.rawValue), lineWidth: borderWidth)
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .foregroundColor(Color(color.rawValue))
                }
            )
    }

    func roundedBackground(cornerRadius: CGFloat, color: ComponentColor, border: Color) -> some View {
        return self
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(border, lineWidth: 5)
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .foregroundColor(Color(color.rawValue))
                }
            )
    }
}
