//
//  Constants.swift
//  Notes
//
//  Created by Divyansh Jain on 24/12/19.
//  Copyright © 2019 Divyansh Jain. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    public static let searchMinCharacter = 2
    
    enum DBTables: String {
        case notes = "Notes"
        case tag = "Tag"
    }
    
    enum PrefKeys: String {
        case isFirstLaunch = "isFirstLaunch"
    }
}

struct UIConstants {
    
    public static let sidePadding: CGFloat = 20
    public static let verticalPadding: CGFloat = 12
    public static let betweenPadding: CGFloat = 4
    public static let labelHeight: CGFloat = 44
    public static let buttonHeight: CGFloat = 44
    public static let cornerRadius: CGFloat = 8
    public static let iconSize: CGSize = .init(width: 24, height: 24)
    public static let pickerHeight: CGFloat = 72
    
    enum Image: String {
        case filter = "filter"
    }
    
}
