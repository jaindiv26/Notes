//
//  Constants.swift
//  Notes
//
//  Created by Divyansh Jain on 24/12/19.
//  Copyright © 2019 Divyansh Jain. All rights reserved.
//

import Foundation
import UIKit

struct UIConstants {

    public static let sidePadding: CGFloat = 12
    public static let verticalPadding: CGFloat = 12
    public static let betweenPadding: CGFloat = 4
    public static let buttonHeight: CGFloat = 44
    public static let cornerRadius: CGFloat = 8
    public static let iconSize: CGSize = .init(width: 24, height: 24)
    
    enum Image: String {
        case feedOutline = "feed_outline"
        case feedFilled = "feed_filled"
        case bookmarkOutline = "bookmark_outline"
        case bookmarkFilled = "bookmark_filled"
        case profileOutline = "profile_outline"
        case profileFilled = "profile_filled"
        case shareOutline = "share_outline"
        case google = "google_icon"
        case app = "logo"
        case bgLaunch = "launchScreen"
    }
    
}
