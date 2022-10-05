//
//  FavoritesViewController.swift
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
import AuthenticationServices

class FavoritesViewController: UIViewController {
    enum Section: Int, CaseIterable {
        case favorites
        
        var title: String {
            switch self {
            case .favorites: return "Favorites"
            }
        }
    }
    
    enum Item: Hashable {
        case movie(Movie)
    }
    
    private var indicator: UIActivityIndicatorView!
    
    private var authenticationGuideView: UIView!
    private var authenticationButton: UIButton!
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    private let fetchRelay = PublishRelay<Void>()
    
    private(set) var db = DisposeBag()
    let vm: FavoritesViewModel
    
    init(vm: FavoritesViewModel) {
        self.vm = vm
        
        super.init(nibName: nil, bundle: nil)
        
        self.tabBarItem = UITabBarItem(title: Strings.Common.Favorites.title,
                                       image: UIImage(systemName: "star"),
                                       tag: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        createIndicator()
        createCollectionView()
        createDataSource()
        createAuthenticationGuide()
        
        bindViewModel()
    }
    
    func showEvent(_ event: FavoritesEvent) {
        switch event {
        case .alert(let msg):
            alert(message: msg)
        }
    }
    
    func changeLayout(authenticated: Bool) {
        authenticationGuideView.isHidden = authenticated
    }
    
    func applyDataSource(sections: FavoritesState.Sections) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(sections.movies.map(Item.movie), toSection: .favorites)
        
        dataSource.apply(snapshot, animatingDifferences: false)
        
        // TODO: show empty list
    }
}

// MARK: ViewModel

private extension FavoritesViewController {
    func bindViewModel() {
        // inputs
        
        let authenticate = authenticationButton.rx.tap
            .map { [weak self] in FavoritesAction.authenticate(self) }
        
        let fetch = fetchRelay
            .map { FavoritesViewModel.Action.fetch }
        
        Observable<FavoritesAction>.merge([authenticate, fetch])
            .bind(to: vm.action)
            .disposed(by: db)
        
        // outputs
        
        vm.state.$fetching
            .drive(indicator.rx.isAnimating)
            .disposed(by: db)
        
        vm.state.$authenticated
            .drive(rx.authenticated)
            .disposed(by: db)
        
        vm.state.$sections
            .drive(rx.dataSource)
            .disposed(by: db)
        
        vm.event
            .emit(to: rx.event)
            .disposed(by: db)
    }
}


// MARK: UI

private extension FavoritesViewController {
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
    
    func createAuthenticationGuide() {
        // authentication button
        authenticationButton = UIButton(type: .custom).then {
            $0.setTitle("Authenticate", for: .normal)
            $0.layer.borderWidth = 1
            $0.layer.borderColor = R.color.tmdbColorTertiaryLightGreen()?.cgColor
            $0.layer.cornerRadius = 10
            $0.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
            
        }
        
        // container view
        authenticationGuideView = UIView().then {
            $0.backgroundColor = .black
        }
        
        // layout
        authenticationGuideView.addSubview(authenticationButton)
        self.view.addSubview(authenticationGuideView)
        
        authenticationButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        authenticationGuideView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
            $0.keyboardDismissMode = .onDrag
        }
    }
    
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { section, environment in
            switch Section(rawValue: section) {
            case .favorites:
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
}

extension FavoritesViewController: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        view.window ?? UIWindow()
    }
}
 
// MARK: UICollectionViewDelegate

extension FavoritesViewController: UICollectionViewDelegate {
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

extension Reactive where Base: FavoritesViewController {
    var dataSource: Binder<FavoritesState.Sections> {
        Binder(base) {
            $0.applyDataSource(sections: $1)
        }
    }
    
    var event: Binder<FavoritesEvent> {
        Binder(base) {
            $0.showEvent($1)
        }
    }
    
    var authenticated: Binder<Bool> {
        Binder(base) {
            $0.changeLayout(authenticated: $1)
        }
    }
}

