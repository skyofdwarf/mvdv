//
//  GenreCell.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/01/27.
//

import UIKit
import SnapKit

class GenreCell: UICollectionViewCell {
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        contentView.layer.borderColor = UIColor.white.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .black
        
        contentView.addSubview(label)
        
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(10)
        }
        
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 1
        label.baselineAdjustment = .alignCenters
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
    }
}
