//
//  FavoritesVC.swift
//  LatteGames
//
//  Created by YILDIRIM on 27.02.2023.
//

import UIKit
class FavoritesVC: UICollectionViewController {

    private let environment: Environment!
    private let favoritesViewModel: FavoriteVM!

    required init(environment: Environment,layout:UICollectionViewLayout) {
        self.environment = environment
        self.favoritesViewModel = FavoriteVM(environemnt: environment)
        super.init(collectionViewLayout:layout)
    }

    required init?(coder: NSCoder) {
        self.environment = Environment(server: Server(), store: Store())
        self.favoritesViewModel = FavoriteVM(environemnt: environment)
        super.init(coder:coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let datasource = generateDatasource()
        favoritesViewModel.configureDataSource(with: datasource)

        configureCollectionView()
    }

    //MARK: -  Private

    private func configureCollectionView() {
        collectionView.backgroundColor = .systemBackground
        collectionView.register(GameCell.self, forCellWithReuseIdentifier: GameCell.reuseId)
    }

    private func generateDatasource() -> GamesDataSource {

        let datasource = GamesDataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GameCell.reuseId, for: indexPath) as! GameCell
            cell.favoritesButton.isSelected = self.environment.store.viewContext.hasPersistenceId(for: itemIdentifier)
            cell.gameData = itemIdentifier
            cell.delegate = self

            return cell
        }
        return datasource
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let selectedGame = favoritesViewModel.
    }
}

//MARK: - GameCell Delegate
extension FavoritesVC: GameCellDelegate {
    func gameCellFavoriteButtonTapped(cell: GameCell) {
        guard let game = cell.gameData else { return }
        presentAlertWithStateChange(message: .deleteGame(with: game)) { [weak self] status in
            guard let self = self, let environment = self.environment else { return }
            if status { environment.store.toggleStorage(for: game, completion: {_ in})}
        }
    }
}
