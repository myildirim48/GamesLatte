//
//  GamesVC.swift
//  LatteGames
//
//  Created by YILDIRIM on 27.02.2023.
//

import UIKit

class GamesVC: UICollectionViewController {
    private let environment: Environment!
    
    required init?(coder:NSCoder) {
        self.environment = Environment(server: Server(), store: Store())
        super.init(coder: coder)
    }
    
    required init(environemnt: Environment, layout: UICollectionViewLayout) {
        self.environment = environemnt
        super.init(collectionViewLayout: layout)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }
}
