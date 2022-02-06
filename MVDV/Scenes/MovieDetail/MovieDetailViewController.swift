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
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<MovieDetailSection, MovieDetailResponse>!
    private var indicator: UIActivityIndicatorView!
    
    private(set) var db = DisposeBag()
    var vm: MovieDetailViewModel!
    
    private var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.clipsToBounds = true
        view.backgroundColor = .black
        
        imageView = UIImageView().then {
            $0.contentMode = .scaleAspectFill
            
            view.addSubview($0)
            
            $0.snp.makeConstraints { make in
                make.top.leading.trailing.equalToSuperview()
                make.height.equalTo(300)
            }
        }
        
        createCollectionView()
        createDataSource()
        createIndicator()
        
        bindViewModel()

        Observable.just(MovieDetailAction.ready)
            .bind(to: vm.action)
            .disposed(by: db)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

// MARK: ViewModel

private extension MovieDetailViewController {
    func bindViewModel() {
        vm.state.$fetching
            .drive(indicator.rx.isAnimating)
            .disposed(by: db)
        
        vm.state.$backdrop
            .drive(onNext: { [weak self] in
                guard let url = $0 else { return }
                self?.imageView.kf.setImage(with: url)
            })
            .disposed(by: db)
        
        vm.state.$detail
            .drive(rx.dataSource)
            .disposed(by: db)
        
        vm.error.emit(to: rx.error)
            .disposed(by: db)
        
        vm.event.emit(to: rx.event)
            .disposed(by: db)
    }
}
// MARK: UI

private extension MovieDetailViewController {
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
            
            $0.backgroundColor = .clear
            $0.contentInset = UIEdgeInsets(top: 300, left: 0, bottom: 0, right: 0)
            
        }
    }
    
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { section, environment in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                  heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .fractionalHeight(1))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            return NSCollectionLayoutSection(group: group)
        }
    }
    
    func createDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, MovieDetailResponse> {
            (cell, indexPath, genre) in
            //cell.label.text = genre.title
        }
        
        dataSource = UICollectionViewDiffableDataSource<MovieDetailSection, MovieDetailResponse>(collectionView: collectionView) {
            (collectionView, indexPath, identifier) in
            
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
    }
    
    func applyDataSource(detail: MovieDetailResponse?) {
        var snapshot = NSDiffableDataSourceSnapshot<MovieDetailSection, MovieDetailResponse>()

        snapshot.appendSections(MovieDetailSection.allCases)
        
        if let detail = detail {
            snapshot.appendItems([detail], toSection: MovieDetailSection.detail)
        } else {
            snapshot.appendItems([], toSection: MovieDetailSection.detail)
        }
//
//        HomeSection.allCases.forEach { section in
//            guard let items = data[section] else { return }
//            let sectionedItems = items.map { SectionedItem(section: section, item: $0) }
//            snapshot.appendItems(sectionedItems, toSection: section)
//        }
//
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension Reactive where Base: MovieDetailViewController {
    var dataSource: Binder<MovieDetailResponse?> {
        Binder(base) {
            $0.applyDataSource(detail: $1)
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
            switch $1 {
                case .alert(let msg):
                    print("event: \(msg)")
            }
        }
    }
}

