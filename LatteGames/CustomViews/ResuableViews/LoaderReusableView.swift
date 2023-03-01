//
//  LoaderReusableView.swift
//  LatteGames
//
//  Created by YILDIRIM on 28.02.2023.
//

import UIKit
class LoaderReusableView: UICollectionReusableView {
    
    static let elementKind = "loader-reusable-kind"
    static let reuseIdentifier = "loader-reusable-id"
    
    let containerView = UIView()
    let activityIndicator = UIActivityIndicatorView()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    func configure() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        activityIndicator.startAnimating()
        
        addSubview(containerView)
        containerView.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 60.0),
            activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
    }
}
