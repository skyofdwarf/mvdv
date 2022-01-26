//
//  HomeViewController.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/01/20.
//

import UIKit
import Then
import SnapKit

class HomeViewController: UIViewController {
    enum SectionHeaderElementKind: String {
        case header
    }
    
    lazy var collectionView: UICollectionView = createCollectionView()
    lazy var dataSource: UICollectionViewDiffableDataSource<Int, Int> = createDataSource()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        tabBarItem = UITabBarItem(title: Strings.Common.Title.home,
                                  image: UIImage(systemName: "house"),
                                  tag: 0)
        view.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDataSource()
    }
}


private extension HomeViewController {
    func createCollectionView() -> UICollectionView {
        return UICollectionView(frame:  view.bounds, collectionViewLayout: createLayout()).then {
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            $0.backgroundColor = .darkGray
        }
    }
    
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { section, environment in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                  heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize).then {
                $0.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            }
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8),
                                                   heightDimension: .fractionalHeight(0.35))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            return NSCollectionLayoutSection(group: group).then {
                $0.orthogonalScrollingBehavior = .continuous
                
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                        heightDimension: .estimated(60))
                let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                                elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                $0.boundarySupplementaryItems = [sectionHeader]
            }
        }
    }
    
    func createDataSource() -> UICollectionViewDiffableDataSource<Int, Int> {
        let cellRegistration = UICollectionView.CellRegistration<MoviePosterCell, Int> {
            (cell, indexPath, identifier) in
            cell.contentView.layer.borderColor = UIColor.white.cgColor
            cell.contentView.layer.borderWidth = 1
            cell.contentView.layer.cornerRadius = 5
            cell.contentView.backgroundColor = .lightGray
            
            cell.label.textColor = .white
            cell.label.textAlignment = .center
            cell.label.font = UIFont.preferredFont(forTextStyle: .title1)
            
            cell.label.text = "\(indexPath.section), \(indexPath.item)"
        }
        
        return UICollectionViewDiffableDataSource<Int, Int>(collectionView: collectionView) {
            (collectionView, indexPath, identifier) in
            
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }.then {
            let headerRegistration = UICollectionView.SupplementaryRegistration<MovieHeaderView>(elementKind: UICollectionView.elementKindSectionHeader) {
                (supplementaryView, string, indexPath) in
                
                
                supplementaryView.backgroundColor = .lightGray
                supplementaryView.layer.borderColor = UIColor.white.cgColor
                supplementaryView.layer.borderWidth = 1
                supplementaryView.label.text = "\(string) for section \(indexPath.section)"
            }
            
            $0.supplementaryViewProvider = { (view, kind, index) in
                print("header kind: \(kind)")
                return self.collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: index)
            }
        }
    }
    
    func configureDataSource() {
        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
        var identifierOffset = 0
        let itemsPerSection = 30
        for section in 0..<5 {
            snapshot.appendSections([section])
            let maxIdentifier = identifierOffset + itemsPerSection
            snapshot.appendItems(Array(identifierOffset..<maxIdentifier))
            identifierOffset += itemsPerSection
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
