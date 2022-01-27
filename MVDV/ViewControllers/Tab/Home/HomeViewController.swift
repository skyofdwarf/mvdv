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

struct SectionedItem: Hashable {
    let section: HomeSection
    let item: HomeItem
}

class HomeViewController: UIViewController {
    enum SectionHeaderElementKind: String {
        case header
    }

    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<HomeSection, SectionedItem>!
    private var indicator: UIActivityIndicatorView!
    
    private(set) var db = DisposeBag()
    let vm = HomeViewModel()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        title = "ㅁㅂㄷㅂ"
        
        tabBarItem = UITabBarItem(title: Strings.Common.Title.home,
                                  image: UIImage(systemName: "house"),
                                  tag: 0)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "info.circle.fill"),
                                                            style: .plain,
                                                            target: nil,
                                                            action: nil)
            .then { $0.tintColor = R.color.tmdbColorTertiaryLightGreen() }
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
            
            $0.color = R.color.tmdbColorTertiaryLightGreen()
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
            
            $0.backgroundColor = .black
        }
    }
    
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { section, environment in
            switch HomeSection(rawValue: section) {
                case .genres:
                    return Self.createGenreSection()
                    
                case .nowPlaying:
                    return Self.createMovieBackdropSection()
                    
                default:
                    return Self.createMoviePosterSection()
            }
        }
    }
    
    static func createMovieBackdropSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalWidth(1/1.78))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        return NSCollectionLayoutSection(group: group).then {
            $0.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0)
            $0.orthogonalScrollingBehavior = .paging
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                    heightDimension: .estimated(50))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                            elementKind: UICollectionView.elementKindSectionHeader,
                                                                            alignment: .top,
                                                                            absoluteOffset: CGPoint(x: 10, y: 0))
            //sectionHeader.extendsBoundary = false
            $0.boundarySupplementaryItems = [sectionHeader]
        }
    }
    
    static func createMoviePosterSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4),
                                               heightDimension: .fractionalWidth(0.4*1.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        return NSCollectionLayoutSection(group: group).then {
            $0.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 5, trailing: 10)
            $0.interGroupSpacing = 10
            $0.orthogonalScrollingBehavior = .continuous
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                    heightDimension: .estimated(50))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                            elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            $0.boundarySupplementaryItems = [sectionHeader]
        }
    }
    
    static func createGenreSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(100),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(100),
                                               heightDimension: .absolute(30))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        return NSCollectionLayoutSection(group: group).then {
            $0.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 5, trailing: 10)
            $0.interGroupSpacing = 10
            $0.orthogonalScrollingBehavior = .continuous
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                    heightDimension: .estimated(50))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                            elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            $0.boundarySupplementaryItems = [sectionHeader]
        }
    }
    
    func createDataSource() {
        let genreCellRegistration = UICollectionView.CellRegistration<GenreCell, Genre> {
            (cell, indexPath, genre) in
            cell.label.text = genre.name
        }
        
        let moviePosterCellRegistration = UICollectionView.CellRegistration<MoviePosterCell, Movie> {
            [weak self] (cell, indexPath, movie) in
            guard let self = self else { return }
            
            cell.label.text = movie.title
            
            let sizes: [String] = self.vm.state.imageConfiguration.poster_sizes
            let sizeIndex: Int = (sizes.firstIndex(of: "w342") ??
                                  sizes.firstIndex(of: "w500") ??
                                  sizes.firstIndex(of: "w780") ??
                                  sizes.firstIndex(of: "original") ??
                                  sizes.firstIndex(of: "w185") ??
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
        
        let movieBackdropCellRegistration = UICollectionView.CellRegistration<MovieBackdropCell, Movie> {
            [weak self] (cell, indexPath, movie) in
            guard let self = self else { return }
            
            cell.label.text = movie.title
            
            let sizes: [String] = self.vm.state.imageConfiguration.backdrop_sizes
            let sizeIndex: Int = (sizes.firstIndex(of: "w780") ??
                                  sizes.firstIndex(of: "w1280") ??
                                  sizes.firstIndex(of: "w300") ??
                                  sizes.firstIndex(of: "original") ??
                                  max(0, sizes.count - 1))
            
            guard let baseUrl = URL(string: self.vm.state.imageConfiguration.secure_base_url),
                  sizes.count > sizeIndex,
                  let posterPath = movie.backdrop_path
            else { return }
            
            let imageUrl = baseUrl
                .appendingPathComponent(sizes[sizeIndex])
                .appendingPathComponent(posterPath)
            cell.imageView.kf.setImage(with: imageUrl)
        }
        
        dataSource = UICollectionViewDiffableDataSource<HomeSection, SectionedItem>(collectionView: collectionView) {
            (collectionView, indexPath, identifier) in
            
            guard let section = HomeSection(rawValue: indexPath.section) else { return nil }
                        
            switch identifier.item {
                case .genre(let genre):
                    return collectionView.dequeueConfiguredReusableCell(using: genreCellRegistration, for: indexPath, item: genre)
                case .movie(let movie):
                    switch section {
                        case .nowPlaying:
                            return collectionView.dequeueConfiguredReusableCell(using: movieBackdropCellRegistration, for: indexPath, item: movie)
                        default:
                            return collectionView.dequeueConfiguredReusableCell(using: moviePosterCellRegistration, for: indexPath, item: movie)
                    }
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
        var snapshot = NSDiffableDataSourceSnapshot<HomeSection, SectionedItem>()
        
        snapshot.appendSections(HomeSection.allCases)
        
        HomeSection.allCases.forEach { section in
            guard let items = data[section] else { return }
            let sectionedItems = items.map { SectionedItem(section: section, item: $0) }
            snapshot.appendItems(sectionedItems, toSection: section)
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
