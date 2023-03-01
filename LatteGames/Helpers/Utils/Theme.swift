//
//  Theme.swift
//  LatteGames
//
//  Created by YILDIRIM on 28.02.2023.
//

import UIKit
struct Theme {
    
    struct fonts {
        static let titleSize = CGFloat(18.0)
        static let titleWeight : UIFont.Weight = .semibold
        static let titleDescriptor = UIFont.systemFont(ofSize: titleSize, weight: titleWeight).fontDescriptor.withDesign(.rounded)
        static let titleFont: UIFont = Theme.fonts.titleDescriptor == nil ? .systemFont(ofSize: titleSize,weight: titleWeight) : UIFont(descriptor: Theme.fonts.titleDescriptor!, size: 0.0)
        static let desriptionFont = UIFont.preferredFont(forTextStyle: .caption2).withSize(12)
        
    }
}
