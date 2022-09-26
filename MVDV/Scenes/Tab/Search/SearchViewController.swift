//
//  SearchViewController.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/01/21.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa
import RxRelay
import Accelerate
import Kingfisher

class SearchViewController: UIViewController {
    enum Section: Int, CaseIterable {
        case movies
        
        var title: String {
            switch self {
            case .movies: return "Movies"
            }
        }
    }
    
    enum Item: Hashable {
        case movie(Movie)
    }
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    private var indicator: UIActivityIndicatorView!
    private var searchBar: UISearchBar!
    
    private let queryRelay = PublishRelay<String?>()
    
    private(set) var db = DisposeBag()
    let vm: SearchViewModel
    
    init(vm: SearchViewModel) {
        self.vm = vm
        
        super.init(nibName: nil, bundle: nil)
        
        self.tabBarItem = UITabBarItem(title: Strings.Common.Search.title,
                                       image: UIImage(systemName: "magnifyingglass"),
                                       tag: 0)
        
        if #available(iOS 14, *) {
            navigationItem.backButtonDisplayMode = .minimal
        } else {
            navigationItem.backButtonTitle = ""
        }
        
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
        
        createSearchBar()
        createCollectionView()
        createDataSource()
        createIndicator()
        
        bindViewModel()
        
        // TODO: bind button event with fetch action
        //        Observable.just(SearchAction.search)
        //            .bind(to: vm.action)
        //            .disposed(by: db)
    }
}

// MARK: ViewModel

private extension SearchViewController {
    func bindViewModel() {
        // inputs
        self.queryRelay
            .map { SearchAction.search(query: $0) }
            .bind(to: vm.action)
            .disposed(by: db)
        
        // outputs
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

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath),
              case .movie(let movie) = item,
              let size = vm.imageConfiguration.backdrop_sizes.last
        else {
            return
        }
        
        guard let baseUrl = URL(string: vm.imageConfiguration.secure_base_url),
              let posterPath = movie.backdrop_path
        else { return }
        
        let imageUrl = baseUrl
            .appendingPathComponent(size)
            .appendingPathComponent(posterPath)
        
        let vm = MovieDetailViewModel(imageConfiguration: vm.imageConfiguration,
                                     movieId: movie.id,
                                     backdrop: imageUrl)
        let vc = MovieDetailViewController(vm: vm)
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("text: \(searchBar.text)")
        
        searchBar.resignFirstResponder()
        
        let query = searchBar.text
        self.queryRelay.accept(query)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// MARK: UI

private extension SearchViewController {
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
   
    func createSearchBar() {
        searchBar = UISearchBar()
        searchBar.barTintColor = R.color.tmdbColorTertiaryLightGreen()
        searchBar.tintColor = R.color.tmdbColorTertiaryLightGreen()
        searchBar.searchTextField.textColor = .white
        searchBar.delegate = self
        
        navigationItem.titleView = searchBar
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
            $0.keyboardDismissMode = .onDrag
        }
    }
    
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { section, environment in
            switch Section(rawValue: section) {
                case .movies:
                    return Self.createMoviePosterSection()
                default:
                    return nil
            }
        }
    }
    
    static func createMoviePosterSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalWidth(0.5*1.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(10)
        
        return NSCollectionLayoutSection(group: group).then {
            $0.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 5, trailing: 10)
            $0.interGroupSpacing = 10
        }
    }
    
    func createDataSource() {
        let movieCellRegistration = UICollectionView.CellRegistration<MoviePosterCell, Movie> {
            [weak self] (cell, indexPath, movie) in
            guard let self = self else { return }
            
            let posterUrl = movie.poster(with: self.vm.imageConfiguration)
            
            cell.label.text = movie.title
            cell.imageView.kf.setImage(with: posterUrl)
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) {
            (collectionView, indexPath, identifier) in
            
            switch identifier {
                case .movie(let movie):
                    return collectionView.dequeueConfiguredReusableCell(using: movieCellRegistration, for: indexPath, item: movie)
            }
        }
    }
    
    func applyDataSource(sections: SearchState.Sections) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(sections.movies.map(Item.movie), toSection: .movies)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func showEvent(_ event: SearchEvent) {
        switch event {
            case .alert(let msg):
                alert(message: msg)
        }
    }
}

extension Reactive where Base: SearchViewController {
    var dataSource: Binder<SearchState.Sections> {
        Binder(base) {
            $0.applyDataSource(sections: $1)
        }
    }
    
    var event: Binder<SearchEvent> {
        Binder(base) {
            $0.showEvent($1)
        }
    }
}

