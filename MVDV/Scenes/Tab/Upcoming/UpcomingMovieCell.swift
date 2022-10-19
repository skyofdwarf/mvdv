//
//  UpcomingMovieCell.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/02/17.
//

import UIKit
import SnapKit

class UpcomingMovieCell: UICollectionViewCell {
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
        contentView.addSubview(imageView)
        contentView.addSubview(label)
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        label.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview().inset(10)
            $0.top.greaterThanOrEqualTo(contentView.snp.top).offset(10)
        }
        
        label.numberOfLines = 0
        label.textColor = R.color.tmdbColorTertiaryLightGreen()
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
    }
}
