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
    enum Section: Int, CaseIterable {
        case nowPlaying
        case genres
        case trending
        case popuplar
        case topRated
        
        var title: String {
            switch self {
                case .nowPlaying: return "Now Playing"
                case .genres: return "Genres"
                case .trending: return "Trending"
                case .popuplar: return "Popular"
                case .topRated: return "Top Rated"
            }
        }
    }
    
    enum Item: Hashable {
        case genre(Genre)
        case movie(Movie)
    }

    enum SectionHeaderElementKind: String {
        case header
    }

    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    private var indicator: UIActivityIndicatorView!
    
    private(set) var db = DisposeBag()
    let vm = HomeViewModel()
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent  }

    init() {
        super.init(nibName: nil, bundle: nil)
        
        title = "ㅁㅂㄷㅂ"
        
        tabBarItem = UITabBarItem(title: Strings.Common.Home.title,
                                  image: UIImage(systemName: "house"),
                                  tag: 0)
        if #available(iOS 14, *) {
            navigationItem.backButtonDisplayMode = .minimal
        } else {
            navigationItem.backButtonTitle = ""
        }
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "info.circle.fill"),
                                                            style: .plain,
                                                            target: nil,
                                                            action: nil)
        navigationItem.standardAppearance = UINavigationBarAppearance().then {
            $0.backgroundColor = R.color.tmdbColorPrimaryDarkBlue()
            $0.titleTextAttributes = [
                .foregroundColor: R.color.tmdbColorTertiaryLightGreen()!,
                .font: UIFont.boldSystemFont(ofSize: 24),
            ]
        }
        navigationItem.scrollEdgeAppearance = UINavigationBarAppearance().then {
            $0.configureWithTransparentBackground()
            $0.titleTextAttributes = [
                .foregroundColor: R.color.tmdbColorTertiaryLightGreen()!,
                .font: UIFont.boldSystemFont(ofSize: 24),
            ]
        }
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
        
        vm.state.$sections
            .drive(rx.dataSource)
            .disposed(by: db)
        
        vm.event
            .emit(to: rx.event)
            .disposed(by: db)
    }
}

// MARK: UICollectionViewDelegate

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath),
              case .movie(let movie) = item,
              let size = vm.state.imageConfiguration.backdrop_sizes.last
        else {
            return
        }
        
        guard let baseUrl = URL(string: vm.state.imageConfiguration.secure_base_url),
              let posterPath = movie.backdrop_path
        else { return }
        
        let imageUrl = baseUrl
            .appendingPathComponent(size)
            .appendingPathComponent(posterPath)
        
        let vc = MovieDetailViewController().then {
            $0.vm = MovieDetailViewModel(imageConfiguration: vm.state.imageConfiguration,
                                         movieId: movie.id,
                                         backdrop: imageUrl)
        }
        navigationController?.pushViewController(vc, animated: true)
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
            
            $0.delegate = self
            $0.backgroundColor = .black
        }
    }
    
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { section, environment in
            switch Section(rawValue: section) {
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
        
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) {
            (collectionView, indexPath, identifier) in
            
            guard let section = Section(rawValue: indexPath.section) else { return nil }
                        
            switch identifier {
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
                
                guard let section = Section(rawValue: indexPath.section) else { return }
                view.label.text = section.title
            }
            
            $0.supplementaryViewProvider = { (cv, kind, indexPath) in               
                return cv.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
            }
        }
    }
    
    func applyDataSource(sections: HomeState.Sections) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        
        snapshot.appendSections(Section.allCases)
        
        snapshot.appendItems(sections.nowPlaying.map(Item.movie), toSection: .nowPlaying)
        snapshot.appendItems(sections.genres.map(Item.genre), toSection: .genres)
        snapshot.appendItems(sections.trending.map(Item.movie), toSection: .trending)
        snapshot.appendItems(sections.popuplar.map(Item.movie), toSection: .popuplar)
        snapshot.appendItems(sections.topRated.map(Item.movie), toSection: .topRated)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func showEvent(_ event: HomeEvent) {
        switch event {
            case .alert(let msg):
                let alert = UIAlertController(title: Strings.Common.Alert.title,
                                              message: msg,
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: Strings.Common.Alert.ok, style: .default))
                present(alert, animated: true, completion: nil)
        }
    }
}

extension Reactive where Base: HomeViewController {
    var dataSource: Binder<HomeState.Sections> {
        Binder(base) {
            $0.applyDataSource(sections: $1)
        }
    }
    
    var event: Binder<HomeEvent> {
        Binder(base) {
            $0.showEvent($1)
        }
    }
}
