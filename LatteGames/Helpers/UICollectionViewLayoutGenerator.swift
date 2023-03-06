//
//  UICollectionViewLayoutGenerator.swift
//  LatteGames
//
//  Created by YILDIRIM on 27.02.2023.
//

import UIKit

struct UICollectionViewLayoutGenerator {
    enum CollectionViewStyle{
    case paginated, search, favorites
        
        var suplementaryViewKindForStyle: String {
            switch self {
            case .paginated:
                return LoaderReusableView.elementKind
            case .search:
                return SearchReusableView.elementKind
            case .favorites:
                return ""
            }
        }
        
        var heightForViewKind: CGFloat {
            switch self {
            case .paginated:
                return CGFloat(60.0)
            case .search:
                return CGFloat(35.0)
            case .favorites:
                return CGFloat(43.0)
            }
        }
        
        var alignForViewKind: NSRectAlignment {
            switch self {
            case .paginated:
                return .bottom
            case .search:
                return .top
            case .favorites:
                return .none
            }
        }

    }
    
    enum SectionLayoutKind: Int,CaseIterable {
        case list
        
        func columnCount(for width: CGFloat) -> Int{
            let wideMode = width > 800
            let narrowMode = width < 420
            
            switch self {
            case .list :
                return wideMode ? 3 : narrowMode ? 1 : 2
            }
        }
    }
    
    static func generateLayoutForStyle(_ style: CollectionViewStyle) -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let sectionLayoutKind = SectionLayoutKind(rawValue: sectionIndex)!
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let itemInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
            item.contentInsets = itemInsets
            
            let columns = sectionLayoutKind.columnCount(for: layoutEnvironment.container.effectiveContentSize.width)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(180))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columns)
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 10
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 5)
            
            if style != .favorites {
                let suplemantaryItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(style.heightForViewKind))
                let suplemantaryItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: suplemantaryItemSize, elementKind: style.suplementaryViewKindForStyle, alignment: style.alignForViewKind)
                section.boundarySupplementaryItems = [suplemantaryItem]
            }
            
            return section
        }
    }
    //MARK: - Resources layout
    
    enum ResourceSection: Int, CaseIterable {
        case alltimeBest, alltimeBestMultiplayer, lastyearPopular, lastmonthReleased
        
        var sectionTitle: String {
            switch self {
                case .alltimeBest: return "All Time Best's "
                case .alltimeBestMultiplayer: return "All Time Multiplayers Best"
                case .lastyearPopular: return "Popular in 2022"
            case .lastmonthReleased: return "Released in last month"
            }
        }
        
        func columnCount(for width: CGFloat) -> Int {
            let wideMode = width > 800
            let narrowMode = width < 420
            
            switch self {
            case .alltimeBest, .alltimeBestMultiplayer, .lastyearPopular, .lastmonthReleased:
                    return wideMode ? 3 : narrowMode ? 1 : 2
            }
        }
        
        var groupSize: (width: NSCollectionLayoutDimension, height: NSCollectionLayoutDimension) {
            switch self {
                case .alltimeBest: return (width: .absolute(350), height: .absolute(150))
                case .lastyearPopular: return (width: .fractionalWidth(0.90), height: .fractionalHeight(0.27))
            case .lastmonthReleased: return (width: .fractionalWidth(0.85), height: .fractionalHeight(0.20))
                case .alltimeBestMultiplayer: return (width: .fractionalWidth(0.90), height: .fractionalHeight(0.18))
            }
        }
    }
    
    static func resourcesCollectionViewLayout() -> UICollectionViewLayout {
        
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let sectionLayoutKind = ResourceSection(rawValue: sectionIndex)!
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let sectionGroupSize = sectionLayoutKind.groupSize
            let groupSize = NSCollectionLayoutSize(widthDimension: sectionGroupSize.width, heightDimension: sectionGroupSize.height)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.interGroupSpacing = 20
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
            
            let titleSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
            let titleSupplementary = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: titleSize, elementKind: TitleReusableView.elementKind, alignment: .top)
            section.boundarySupplementaryItems = [titleSupplementary]
        
            return section
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        config.scrollDirection = .vertical
        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: config)
        
        return layout
    }
}
