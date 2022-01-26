//
//  HomeViewController.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/01/20.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa
import RxRelay
import Accelerate
import Kingfisher

class HomeViewController: UIViewController {
    enum SectionHeaderElementKind: String {
        case header
    }

    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<HomeSection, HomeItem>!
    private var indicator: UIActivityIndicatorView!
    
    private(set) var db = DisposeBag()
    let vm = HomeViewModel()
    
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
        
        createCollectionView()
        createDataSource()
        createIndicator()
        
        bindViewModel()

        Observable.just(HomeAction.ready)
            .bind(to: vm.action)
            .disposed(by: db)
    }
}

// MARK: ViewModel

private extension HomeViewController {
    func bindViewModel() {
        vm.state.$fetching
            .drive(indicator.rx.isAnimating)
            .disposed(by: db)
        
        vm.state.$data
            .drive(rx.dataSource)
            .disposed(by: db)
    }
}


// MARK: UI

private extension HomeViewController {
    func createIndicator() {
        indicator = UIActivityIndicatorView(style: .large).then {
            view.addSubview($0)
            
            $0.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
            
            $0.tintColor = .red
            $0.hidesWhenStopped = true
        }
    }
    
    func createCollectionView() {
        let layout = createLayout()
        collectionView = UICollectionView(frame:  view.bounds, collectionViewLayout: layout).then {
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
    
    func createDataSource() {
        let genreCellRegistration = UICollectionView.CellRegistration<MoviePosterCell, Genre> {
            (cell, indexPath, genre) in
            cell.label.text = genre.name
        }
        
        let movieCellRegistration = UICollectionView.CellRegistration<MoviePosterCell, Movie> {
            [weak self] (cell, indexPath, movie) in
            guard let self = self else { return }
            
            cell.label.text = movie.title
            
            let sizes: [String] = self.vm.state.imageConfiguration.poster_sizes
            let sizeIndex: Int = (sizes.firstIndex(of: "w185") ??
                                  sizes.firstIndex(of: "w342") ??
                                  sizes.firstIndex(of: "w500") ??
                                  sizes.firstIndex(of: "w780") ??
                                  sizes.firstIndex(of: "original") ??
                                  sizes.firstIndex(of: "w154") ??
                                  0)
            
            guard let baseUrl = URL(string: self.vm.state.imageConfiguration.secure_base_url),
                  sizes.count > sizeIndex,
                  let posterPath = movie.poster_path
            else { return }
            
            let imageUrl = baseUrl
                .appendingPathComponent(sizes[sizeIndex])
                .appendingPathComponent(posterPath)
            cell.imageView.kf.setImage(with: imageUrl)
        }
        
        dataSource = UICollectionViewDiffableDataSource<HomeSection, HomeItem>(collectionView: collectionView) {
            (collectionView, indexPath, identifier) in
            
            switch identifier {
                case .genre(let genre):
                    return collectionView.dequeueConfiguredReusableCell(using: genreCellRegistration, for: indexPath, item: genre)
                case .movie(let movie):
                    return collectionView.dequeueConfiguredReusableCell(using: movieCellRegistration, for: indexPath, item: movie)
            }
        }.then {
            let headerRegistration = UICollectionView.SupplementaryRegistration<MovieHeaderView>(elementKind: UICollectionView.elementKindSectionHeader) {
                (view, kind, indexPath) in
                
                guard let section = HomeSection(rawValue: indexPath.section) else { return }
                view.label.text = section.title
            }
            
            $0.supplementaryViewProvider = { (cv, kind, indexPath) in               
                return cv.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
            }
        }
    }
    
    func applyDataSource(data: [HomeSection: [HomeItem]]) {
        var snapshot = NSDiffableDataSourceSnapshot<HomeSection, HomeItem>()
        
        snapshot.appendSections(HomeSection.allCases)
        
        HomeSection.allCases.forEach {
            guard let items = data[$0] else { return }
            snapshot.appendItems(items, toSection: $0)
        }
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension Reactive where Base: HomeViewController {
    var dataSource: Binder<[HomeSection: [HomeItem]]> {
        Binder(base) {
            $0.applyDataSource(data: $1)
        }
    }
}
