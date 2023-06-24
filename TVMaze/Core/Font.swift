//
//  Font.swift
//  TVMaze
//
//  Created by bruno on 24/06/23.
//

import Foundation
import SwiftUI

/*
 This table is was created with the design team
 Apple weight| Figma weight
 ultraLight  |          100
 thin        |          200
 light       |          300
 regular     |          400
 medium      |          500
 semibold    |          600
 bold        |          700
 heavy       |          800
 black       |          900 and above
**/

enum CustomFontName: String {
    case montserrat = "Montserrat"
    case rubik = "Rubik"
}

extension Font {
    /// Used to set the Montserrat font to the component
    /// - Parameters:
    ///   - size: size of the font
    ///   - weight: weight of the font, that can be (`regular` - `.w400`), (`medium` - `.w500`), (`bold` - `.w700`)
    /// - Returns: Font object
    static func primary(_ size: FontSize, weight: Font.Weight = .regular) -> Font {
        .createCustom(CustomFontName.montserrat.rawValue, fixedSize: size, weight: weight)
    }
    
    /// Used to set the Rubik font to the component
    /// - Parameters:
    ///   - size: size of the font
    ///   - weight: weight of the font, that can be (`regular` - `.w400`), (`medium` - `.w500`), (`bold` - `.w700`)
    /// - Returns: Font object
    static func secondary(_ size: FontSize, weight: Font.Weight = .regular) -> Font {
        .createCustom(CustomFontName.rubik.rawValue, fixedSize: size, weight: weight)
    }

    private static func createCustom(
        _ name: String,
        fixedSize: FontSize,
        weight: Font.Weight
    ) -> Font {
        let fontName: String = "\(name)-Regular"
        return Font
            .custom(fontName, fixedSize: fixedSize.rawValue)
            .weight(weight)
    }
}
