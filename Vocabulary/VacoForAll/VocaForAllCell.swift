//
//  VocaForAllCell.swift
//  Vocabulary
//
//  Created by apple on 2020/07/30.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import PoingVocaSubsystem
import PoingDesignSystem
import SnapKit
import RxSwift
import RxCocoa
import SDWebImage

class VocaForAllCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: VocaForAllCell.self)

    enum Constant {
        enum VocaImage {
            static let length: CGFloat = 166
        }
        enum Count {
            static let length: CGFloat = 32
        }
        static let imageRadius: CGFloat = 12
    }

    lazy var vocaImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.layer.cornerRadius = Constant.VocaImage.length * 0.5
        view.backgroundColor = .lightGray
        return view
    }()
    lazy var numberLable: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.layer.cornerRadius = Constant.Count.length * 0.5
        label.textColor = .white
        label.backgroundColor = .brightSkyBlue
        label.font = UIFont.QuicksandBold(size: 14)
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 26)
        label.numberOfLines = 0
        label.textColor = .darkIndigo
        return label
    }()
    lazy var authorContentView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .slateGrey
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    lazy var authorImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "icPicture")
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 24 * 0.5
        return imageView
    }()
    lazy var baseView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 32
        view.layer.shadow(
            color: .greyblue20,
            alpha: 1,
            x: 0,
            y: 10,
            blur: 60,
            spread: 0)
        view.backgroundColor = .white
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        vocaImageView.sd_cancelCurrentImageLoad()
        authorImageView.sd_cancelCurrentImageLoad()
    }

    func configure(content: EveryVocaContent) {
        titleLabel.text = content.folderName
        authorLabel.text = content.userName

        if let urlImage = URL(string: content.photoUrl) {
            vocaImageView.sd_imageTransition = .fade
            vocaImageView.sd_setImage(with: urlImage)
        }

        if let userPhotoUrlString = content.userPhotoUrl, let userPhotoUrl = URL(string: userPhotoUrlString) {
            authorImageView.sd_imageTransition = .fade
            authorImageView.sd_setImage(with: userPhotoUrl) { [weak self] (image, error, _, _) in
                guard error == nil else {
                    self?.authorImageView.image = UIImage(named: "emptyFace")
                    return
                }
            }
        } else {
            authorImageView.image = UIImage(named: "emptyFace")
        }

        numberLable.text = "\(content.count)"
    }

    func configure(folder: Folder) {
        titleLabel.text = folder.name
    }

    func configureLayout() {
        backgroundColor = .clear
        clipsToBounds = false
        
        contentView.addSubview(baseView)
        baseView.addSubview(vocaImageView)
        baseView.addSubview(numberLable)
        baseView.addSubview(titleLabel)
        baseView.addSubview(authorContentView)
        authorContentView.addSubview(authorImageView)
        authorContentView.addSubview(authorLabel)

        baseView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(contentView)
            make.leading.equalTo(contentView).offset(16)
            make.trailing.equalTo(contentView).offset(-16)
        }

        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(baseView.snp.leading).offset(32)
            make.top.equalTo(baseView.snp.top).offset(32)
            make.trailing.equalTo(baseView).offset(-(Constant.VocaImage.length * 0.5) - 32)
        }

        authorContentView.snp.makeConstraints { (make) in
            make.leading.equalTo(baseView.snp.leading).offset(32)
            make.trailing.equalTo(baseView.snp.trailing).offset(-32)
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
        }
        authorImageView.snp.makeConstraints { (make) in
            make.leading.top.bottom.equalTo(authorContentView)
            make.width.height.equalTo(24)
        }
        authorLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(authorImageView.snp.trailing).offset(8)
            make.trailing.equalTo(authorContentView.snp.trailing).offset(-8)
            make.centerY.equalTo(authorImageView)
        }

        vocaImageView.snp.makeConstraints { (make) in
            make.height.width.equalTo(Constant.VocaImage.length)
            make.bottom.equalTo(baseView.snp.bottom).offset(-32)
            make.trailing.equalTo(baseView.snp.trailing).offset(-32)
        }

        numberLable.snp.makeConstraints { (make) in
            make.top.equalTo(vocaImageView).offset(8)
            make.trailing.equalTo(vocaImageView).offset(-8)
            make.width.height.equalTo(Constant.Count.length)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
