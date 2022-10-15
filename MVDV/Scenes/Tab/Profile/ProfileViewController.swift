//
//  ProfileViewController.swift
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

class ProfileViewController: UIViewController {
    enum Section: Int, CaseIterable {
        case profile
        case favorites
        
        var title: String {
            switch self {
            case .profile: return Strings.Profile.Section.profile
            case .favorites: return Strings.Profile.Section.favorites
                
            }
        }
    }
    
    enum Item: Hashable {
        case unauthenticated
        case authentication(Authentication)
        case movie(Movie)
    }
    
    private var indicator: UIActivityIndicatorView!
    
    private var unbindButton: UIBarButtonItem!
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    private let actionRelay = PublishRelay<ProfileAction>()
    
    private(set) var db = DisposeBag()
    let vm: ProfileViewModel
    
    init(vm: ProfileViewModel) {
        self.vm = vm
        
        super.init(nibName: nil, bundle: nil)
        
        self.tabBarItem = UITabBarItem(title: Strings.Common.Profile.title,
                                       image: UIImage(systemName: "person.crop.circle"),
                                       tag: 0)
        
        if #available(iOS 14, *) {
            navigationItem.backButtonDisplayMode = .minimal
        } else {
            navigationItem.backButtonTitle = ""
        }
        
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
        
        self.unbindButton = UIBarButtonItem(title: Strings.Common.unbind, style: .done, target: nil, action: nil)
        
        navigationItem.rightBarButtonItem = unbindButton
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        createCollectionView()
        createDataSource()
        createIndicator()
        
        bindViewModel()
        
        fetchProfileIfNeeded()
    }
    
    func fetchProfileIfNeeded() {
        if vm.state.authenticated {
            actionRelay.accept(.fetch)
        }
    }
    
    func showEvent(_ event: ProfileEvent) {
        switch event {
        case .alert(let msg):
            alert(message: msg)
        }
    }
    
    func processError(_ error: Error) {
        alert(message: error.localizedDescription)
    }
    
    func changeLayout(authenticated: Bool) {
        navigationItem.rightBarButtonItem = authenticated ? unbindButton: nil
    }
    
    func applyDataSource(sections: ProfileState.Sections) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        
        snapshot.appendSections(Section.allCases)
        
        if let authentication = sections.profile {
            snapshot.appendItems([Item.authentication(authentication)], toSection: .profile)
        } else {
            snapshot.appendItems([Item.unauthenticated], toSection: .profile)
        }
        
        snapshot.appendItems(sections.favorites.map(Item.movie), toSection: .favorites)
        
        dataSource.apply(snapshot, animatingDifferences: false)
        
        // TODO: show empty list
    }
}

// MARK: ViewModel

private extension ProfileViewController {
    func bindViewModel() {
        // inputs
        
        unbindButton.rx.tap
            .map { _ in ProfileAction.unbind }
            .bind(to: vm.action)
            .disposed(by: db)
        
        actionRelay
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
        
        vm.error
            .emit(to: rx.error)
            .disposed(by: db)
    }
}


// MARK: UI

private extension ProfileViewController {
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
            $0.keyboardDismissMode = .onDrag
        }
    }
    
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { section, environment in
            switch Section(rawValue: section) {
            case .profile:
                return Self.createProfileSection()
            case .favorites:
                return Self.createMoviePosterSection()
            default:
                return nil
            }
        }
    }
    
    static func createMoviePosterSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalWidth((0.3*6/4)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .flexible(10)
        
        return NSCollectionLayoutSection(group: group).then {
            $0.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 5, trailing: 10)
            $0.interGroupSpacing = 10
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                    heightDimension: .estimated(50))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                            elementKind: UICollectionView.elementKindSectionHeader,
                                                                            alignment: .top,
                                                                            absoluteOffset: CGPoint(x: 10, y: 0))
            $0.boundarySupplementaryItems = [sectionHeader]
        }
    }
    
    static func createProfileSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count:1)
        
        return NSCollectionLayoutSection(group: group)
    }
    
    func createDataSource() {
        let movieCellRegistration = UICollectionView.CellRegistration<MoviePosterCell, Movie> {
            [weak self] (cell, indexPath, movie) in
            guard let self = self else { return }
            
            let posterUrl = movie.poster(with: self.vm.imageConfiguration)
            
            cell.label.text = movie.title
            cell.imageView.kf.setImage(with: posterUrl)
        }
        
        let emptyProfileCellRegistration = UICollectionView.CellRegistration<ProfileCell, Void> {
            [weak self] (cell, indexPath, _) in
            guard let self else { return }
            
            cell.configure(with: nil)
            
            cell.rx.autenticate
                .withUnretained(self) { (self, _) in ProfileAction.authenticate(self) }
                .bind(to: self.actionRelay)
                .disposed(by: cell.db)
        }
        
        let profileCellRegistration = UICollectionView.CellRegistration<ProfileCell, Authentication> {
            (cell, indexPath, authentication) in
            
            cell.configure(with: authentication)
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) {
            (collectionView, indexPath, identifier) in
            
            switch identifier {
            case .unauthenticated:
                return collectionView.dequeueConfiguredReusableCell(using: emptyProfileCellRegistration, for: indexPath, item: ())
            case .authentication(let authentication):
                return collectionView.dequeueConfiguredReusableCell(using: profileCellRegistration, for: indexPath, item: authentication)
            case .movie(let movie):
                return collectionView.dequeueConfiguredReusableCell(using: movieCellRegistration, for: indexPath, item: movie)
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
}

extension ProfileViewController: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        view.window ?? UIWindow()
    }
}
 
// MARK: UICollectionViewDelegate

extension ProfileViewController: UICollectionViewDelegate {
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

extension Reactive where Base: ProfileViewController {
    var dataSource: Binder<ProfileState.Sections> {
        Binder(base) {
            $0.applyDataSource(sections: $1)
        }
    }
    
    var event: Binder<ProfileEvent> {
        Binder(base) {
            $0.showEvent($1)
        }
    }
    
    var error: Binder<Error> {
        Binder(base) {
            $0.processError($1)
        }
    }
    
    var authenticated: Binder<Bool> {
        Binder(base) {
            $0.changeLayout(authenticated: $1)
        }
    }
}

