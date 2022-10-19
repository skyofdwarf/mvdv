//
//  MovieBackdropCell.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/01/28.
//

import UIKit
import SnapKit

class MovieBackdropCell: UICollectionViewCell {
    let label = UILabel()
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.kf.cancelDownloadTask()
    }

    func setup() {
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
        label.textColor = R.color.tmdbColorTertiaryLightGreen()
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
    }
}
