//
//  MovieDetailViewController.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/02/03.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay
import SnapKit
import Then
import Kingfisher
import Moya

class MovieDetailViewController: UIViewController {
    enum Section: Int, CaseIterable {
        case detail
        //case video
        case similar
        
        var title: String {
            switch self {
            case .detail: return Strings.MovieDetails.Section.detail
                //case .video: return "Videos"
            case .similar: return Strings.MovieDetails.Section.similar
            }
        }
    }

    enum Item: Hashable {
        case detail(MovieDetailResponse)
        case movie(Movie)
    }

    private var favoriteBarButton: UIBarButtonItem!
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    private var indicator: UIActivityIndicatorView!
    
    private var backgroundView: UIView!
    private var imageView: UIImageView!
    private var imageDefaultHeight: CGFloat = 0
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent  }
    
    private(set) var db = DisposeBag()
    var vm: MovieDetailViewModel!
    
    let actionRelay = PublishRelay<MovieDetailAction>()

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.clipsToBounds = true
        view.backgroundColor = .black
        
        setupNavigationBar()
        
        createCollectionView()
        createDataSource()
        createIndicator()
        
        bindViewModel()

        fetchDetail()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        updateBackdrop()
    }
    
    // MARK: - action triggers
    
    func fetchDetail() {
        actionRelay.accept(.ready)
    }
    
    func toggleFavorite() {
        actionRelay.accept(.toggleFavorite)
    }
}

// MARK: ViewModel

private extension MovieDetailViewController {
    func bindViewModel() {
        // inputs
        actionRelay
            .bind(to: vm.action)
            .disposed(by: db)
        
        // outputs
        vm.state.$fetching
            .drive(indicator.rx.isAnimating)
            .disposed(by: db)
        
        vm.state.$favorited
            .drive(rx.favorited)
            .disposed(by: db)
        
        vm.state.$backdrop
            .drive(onNext: { [weak self] in
                guard let url = $0 else { return }
                self?.imageView.kf.setImage(with: url)
            })
            .disposed(by: db)
        
        vm.state.$sections
            .drive(rx.dataSource)
            .disposed(by: db)
        
        // errors
        vm.error.emit(to: rx.error)
            .disposed(by: db)
        
        // events
        vm.event.emit(to: rx.event)
            .disposed(by: db)
    }
}

// MARK: UI

private extension MovieDetailViewController {
    func setupNavigationBar() {
        navigationItem.standardAppearance = .init().then {
            $0.configureWithTransparentBackground()
        }
        navigationItem.scrollEdgeAppearance = .init().then {
            $0.configureWithTransparentBackground()
        }
        
        navigationItem.rightBarButtonItem = createFavoriteToggleButton()
    }
    
    func createFavoriteToggleButton() -> UIBarButtonItem {
        let action = UIAction { [weak self] _ in
            self?.toggleFavorite()
        }
        
        favoriteBarButton = UIBarButtonItem(title: nil,
                                            image: UIImage(systemName: "star"),
                                            primaryAction: action,
                                            menu: nil)
       
        return favoriteBarButton
    }
    
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
        imageDefaultHeight = (view.bounds.width / 1.78)
        
        backgroundView = UIView().then {
            $0.backgroundColor = .black
            $0.frame = view.bounds
            
            imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            
            imageView.frame = $0.bounds.with { $0.size.height = imageDefaultHeight }
            
            $0.addSubview(imageView)
        }
        
        let layout = createLayout()
        collectionView = UICollectionView(frame:  view.bounds, collectionViewLayout: layout).then {
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            $0.delegate = self
            $0.indicatorStyle = .white
            $0.backgroundView = backgroundView
        }
    }
    
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { section, environment in
            switch Section(rawValue: section) {
            case .detail:
                let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                  heightDimension: .estimated(200))
                
                let item = NSCollectionLayoutItem(layoutSize: size)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitems: [item])
                return NSCollectionLayoutSection(group: group).then {
                    $0.contentInsets = NSDirectionalEdgeInsets(top: 18, leading: 18, bottom: 18, trailing: 18)
                }
            case .similar:
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
            default:
                return nil
            }
        }
    }
    
    func createDataSource() {
        let detailCellRegistration = UICollectionView.CellRegistration<MovieDetailCell, MovieDetailResponse> {
            (cell, indexPath, detail) in
            cell.configure(detail)
        }
        
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
            case .detail(let detail):
                return collectionView.dequeueConfiguredReusableCell(using: detailCellRegistration, for: indexPath, item: detail)
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
    
    func applyDataSource(sections: MovieDetailState.Sections) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()

        if let detail = sections.detail {
            snapshot.appendSections([.detail])
            snapshot.appendItems([.detail(detail)], toSection: Section.detail)
        }
        
        if let similar = sections.similar {
            snapshot.appendSections([.similar])
            snapshot.appendItems(similar.map(Item.movie), toSection: Section.similar)
        }

        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func updateBackdrop() {
        imageDefaultHeight = (view.bounds.width / 1.78)
        collectionView.contentInset = UIEdgeInsets(top: imageDefaultHeight - view.safeAreaInsets.top,
                                                   left: 0,
                                                   bottom: 0,//-imageDefaultHeight,
                                                   right: 0)
        updateBackdropHeight(defaultHeight: imageDefaultHeight, scrollView: collectionView)
    }
    
    func updateBackdropHeight(defaultHeight: CGFloat, scrollView: UIScrollView) {
        let y = scrollView.contentInset.top + scrollView.safeAreaInsets.top
        
        if scrollView.contentOffset.y < -y {
            let height = imageDefaultHeight + abs(y + scrollView.contentOffset.y)
            
            imageView.frame = scrollView.frame.with { $0.size.height = height }
        } else {
            let y = scrollView.contentOffset.y + y
                
            imageView.frame = scrollView.frame.with {
                $0.size.height = imageDefaultHeight
                $0.origin.y = -abs(y)
            }
        }
    }
    
    func updateFavorited(_ favorited: Bool) {
        favoriteBarButton.image = UIImage(systemName: favorited ? "star.fill": "star")
    }
}

// MARK: UICollectionViewDelegate

extension MovieDetailViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateBackdropHeight(defaultHeight: imageDefaultHeight, scrollView: scrollView)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard case .movie(let movie) = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        
        vm.send(action: .showDetail(movie))
    }
}

extension Reactive where Base: MovieDetailViewController {
    var favorited: Binder<Bool> {
        Binder(base) {
            $0.updateFavorited($1)
        }
    }
    
    var dataSource: Binder<MovieDetailState.Sections> {
        Binder(base) {
            $0.applyDataSource(sections: $1)
        }
    }
    
    var error: Binder<Error> {
        Binder(base) {
            if case let MoyaError.statusCode(response) = $1,
               let response = try? response.map(ErrorResponse.self) {
                print("error: \(response.status_message)")
            } else {
                print("error: \($1.localizedDescription)")
            }
        }
    }
    
    var event: Binder<MovieDetailEvent> {
        Binder(base) {
            base.alert(message: $1.description)
        }
    }
}
