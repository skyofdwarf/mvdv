//
//  MovieHeaderView.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/01/26.
//

import UIKit
import SnapKit

class MovieHeaderView: UICollectionReusableView {
    let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func configure() {
        addSubview(label)
        
        label.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
    }
}

