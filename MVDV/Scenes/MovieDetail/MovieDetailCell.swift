//
//  MovieDetailCell.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/02/08.
//

import UIKit

class MovieDetailCell: UICollectionViewCell {
    let titleLabel = UILabel()
    let overviewLabel = UILabel()
    let releaseDateLabel = UILabel()
    let genresLabel = UILabel()
    let runtimeLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func setup() {
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        releaseDateLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        runtimeLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        overviewLabel.font = UIFont.preferredFont(forTextStyle: .body)
        genresLabel.font = UIFont.preferredFont(forTextStyle: .caption2)
        
        titleLabel.numberOfLines = 0
        overviewLabel.numberOfLines = 0
        
        _ = R.color.tmdbColorTertiaryLightGreen()?.then {
            titleLabel.textColor = $0
            releaseDateLabel.textColor = $0
            runtimeLabel.textColor = $0
            overviewLabel.textColor = $0
            genresLabel.textColor = $0
        }
        
        _ = UIStackView().then { sv in
            sv.axis = .vertical
            sv.alignment = .leading
            sv.spacing = 8
            
            contentView.addSubview(sv)
            sv.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            let runtimeAndDateView = UIStackView().then {
                $0.axis = .horizontal
                $0.spacing = 8
                
                $0.addArrangedSubview(releaseDateLabel)
                $0.addArrangedSubview(runtimeLabel)
            }
            
            sv.addArrangedSubview(titleLabel)
            sv.addArrangedSubview(runtimeAndDateView)
            sv.addArrangedSubview(genresLabel)
            sv.addArrangedSubview(overviewLabel)
        }
    }
    
    func configure(_ detail: MovieDetailResponse) {
        titleLabel.text = detail.original_title
        releaseDateLabel.text = detail.release_date
        runtimeLabel.text = detail.runtime.map { String(format: "%0.1fh", Float($0) / 60) } ?? nil
        overviewLabel.text = detail.overview
        genresLabel.text = detail.genres.map(\.name).joined(separator: ", ")
    }
}
