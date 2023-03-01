//
//  UIView+Ext.swift
//  LatteGames
//
//  Created by YILDIRIM on 28.02.2023.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
}
