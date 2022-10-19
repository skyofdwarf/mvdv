//
//  PoweredCell.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/10/19.
//

import UIKit
import SnapKit
import Kingfisher
import RxSwift
import RxCocoa

class PoweredCell: UICollectionViewCell {
    private(set) var db = DisposeBag()
    
    let logoImageView = UIImageView(image: UIImage(named: "tmdb-logo-primary-full"))
    let label = UILabel()
    let linkButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        db = DisposeBag()
    }

    func setup() {
        label.text = Strings.Profile.powered
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = R.color.tmdbColorTertiaryLightGreen()
        label.textAlignment = .center
        
        linkButton.setTitle(Strings.Profile.mvdv, for: .normal)
        linkButton.setTitleColor(R.color.tmdbColorTertiaryLightGreen(), for: .normal)
        linkButton.titleLabel?.font = .preferredFont(forTextStyle: .caption2)
        linkButton.titleLabel?.textAlignment = .center
        
        let stackView = UIStackView(arrangedSubviews: [logoImageView, label, linkButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(48)
            $0.bottom.equalToSuperview().inset(24)
        }
    }
}

extension Reactive where Base: PoweredCell {
    var link: ControlEvent<Void> {
        base.linkButton.rx.tap
    }
}
