//
//  MVThemeQuickUsing.swift
//  GasChat
//
//  Created by Martin Yin on 8/26/2015.
//  Copyright (c) 2015 Lngtop. All rights reserved.
//

import UIKit

func MVThemeColor(colorKey: String) -> UIColor {
    return MVThemeManager.theme().colorWithName(colorKey)
}

func MVThemeFont(fontKey: String) -> UIFont {
    return MVThemeManager.theme().fontWithName(fontKey)
}

func MVThemeImage(imageKey: String) -> UIImage {
    return MVThemeManager.theme().imageWithName(imageKey)
}
