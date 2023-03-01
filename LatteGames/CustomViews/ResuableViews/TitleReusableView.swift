//
//  TitleReusableView.swift
//  LatteGames
//
//  Created by YILDIRIM on 28.02.2023.
//

import UIKit
class TitleReusableView: UICollectionReusableView {
    
    static let elementKind = "title-reusable-kind"
    static let reuseIdentifier = "title-reuse-identifier"

    let label = LatteLabel(textAligment: .left, font: Theme.fonts.titleFont)

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    func configure() {
        let inset = CGFloat(10)
        addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            label.topAnchor.constraint(equalTo: topAnchor, constant: inset)
        ])
    }
}
