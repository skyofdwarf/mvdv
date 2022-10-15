//
//  ProfileCell.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/10/15.
//

import UIKit
import SnapKit
import Kingfisher
import RxSwift
import RxCocoa

class ProfileCell: UICollectionViewCell {
    let profileImageView = UIImageView()
    let accountLabel = UILabel()
    let autenticateButton = UIButton(type: .system)
    
    private(set) var db = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        profileImageView.kf.cancelDownloadTask()
        db = DisposeBag()
    }

    func setup() {
        let containerView = UIView()
        
        containerView.addSubview(accountLabel)
        containerView.addSubview(profileImageView)
        containerView.addSubview(autenticateButton)
        contentView.addSubview(containerView)
        
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 50
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.borderWidth = 2
        profileImageView.clipsToBounds = true
        
        profileImageView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.size.equalTo(CGSize(width: 100, height: 100))
        }
        
        accountLabel.numberOfLines = 0
        accountLabel.textColor = R.color.tmdbColorTertiaryLightGreen()
        accountLabel.textAlignment = .center
        accountLabel.font = UIFont.preferredFont(forTextStyle: .body)
        accountLabel.text = "Unauthenticated"
        
        accountLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(profileImageView.snp.bottom).offset(8)
            $0.bottom.equalTo(containerView.snp.bottom)
        }
        
        autenticateButton.setTitle("Bind Account", for: .normal)
        autenticateButton.setTitleColor(R.color.tmdbColorTertiaryLightGreen(), for: .normal)
        autenticateButton.isHidden = true
        
        autenticateButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(profileImageView.snp.bottom).offset(8)
            $0.bottom.equalTo(containerView.snp.bottom)
        }
        
        containerView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func configure(with authentication: Authentication?) {
        autenticateButton.isHidden = authentication != nil
        accountLabel.isHidden = authentication == nil
        
        profileImageView.image = UIImage(systemName: "person.crop.circle")
        
        if let authentication {
            accountLabel.text = authentication.accountId
            
            if let gravatarHash = authentication.gravatarHash,
               let url = URL(string: "https://www.gravatar.com/avatar/\(gravatarHash)?s=256") {
                profileImageView.kf.setImage(with: url)
            }
        }
    }
}

extension Reactive where Base: ProfileCell {
    var autenticate: ControlEvent<Void> {
        base.autenticateButton.rx.tap
    }
}
