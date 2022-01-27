//
//  MoviePosterCell.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/01/26.
//

import UIKit
import SnapKit

class MoviePosterCell: UICollectionViewCell {
    let label = UILabel()
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        imageView.kf.cancelDownloadTask()
    }

    func configure() {
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        
        contentView.addSubview(label)
        contentView.addSubview(imageView)        
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(10)
        }
        
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .body)
    }
}
