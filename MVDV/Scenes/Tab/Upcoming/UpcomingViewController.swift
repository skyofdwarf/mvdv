//
//  UpcomingViewController.swift
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

class UpcomingViewController: UIViewController {
    enum Section: Int, CaseIterable {
        case upcoming
        
        var title: String {
            switch self {
                case .upcoming: return "Upcoming"
            }
        }
    }
    
    enum Item: Hashable {
        case movie(Movie)
    }
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    private var indicator: UIActivityIndicatorView!
    
    private(set) var db = DisposeBag()
    let vm: UpcomingViewModel
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent  }
    
    init(vm: UpcomingViewModel) {
        self.vm = vm
        
        super.init(nibName: nil, bundle: nil)
        
        title = Strings.Common.Upcoming.title
        
        self.tabBarItem = UITabBarItem(title: Strings.Common.Upcoming.title,
                                       image: UIImage(systemName: "film"),
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
        
        createCollectionView()
        createDataSource()
        createIndicator()
        
        bindViewModel()
        
        Observable.just(UpcomingAction.ready)
            .bind(to: vm.action)
            .disposed(by: db)
    }
}

// MARK: ViewModel

private extension UpcomingViewController {
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

extension UpcomingViewController: UICollectionViewDelegate {
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


// MARK: UI

private extension UpcomingViewController {
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
                case .upcoming:
                    return Self.createMovieBackdropSection()
                default:
                    return nil
            }
        }
    }
    
    static func createMovieBackdropSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize).then {
                $0.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
            }
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalWidth(1/1.78))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        return NSCollectionLayoutSection(group: group)
    }
    
    func createDataSource() {
        let upcomingMovieCellRegistration = UICollectionView.CellRegistration<UpcomingMovieCell, Movie> {
            [weak self] (cell, indexPath, movie) in
            guard let self = self else { return }
            
            cell.label.text = movie.title
            
            let sizes: [String] = self.vm.imageConfiguration.backdrop_sizes
            let sizeIndex: Int = (sizes.firstIndex(of: "w780") ??
                                  sizes.firstIndex(of: "w1280") ??
                                  sizes.firstIndex(of: "w300") ??
                                  sizes.firstIndex(of: "original") ??
                                  max(0, sizes.count - 1))
            
            guard let baseUrl = URL(string: self.vm.imageConfiguration.secure_base_url),
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
            
            switch identifier {
                case .movie(let movie):
                    return collectionView.dequeueConfiguredReusableCell(using: upcomingMovieCellRegistration, for: indexPath, item: movie)
            }
        }
    }
    
    func applyDataSource(sections: UpcomingState.Sections) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(sections.movies.map(Item.movie), toSection: .upcoming)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func showEvent(_ event: UpcomingEvent) {
        switch event {
            case .alert(let msg):
                alert(message: msg)
        }
    }
}

extension Reactive where Base: UpcomingViewController {
    var dataSource: Binder<UpcomingState.Sections> {
        Binder(base) {
            $0.applyDataSource(sections: $1)
        }
    }
    
    var event: Binder<UpcomingEvent> {
        Binder(base) {
            $0.showEvent($1)
        }
    }
}
