//
//  NFTDetailView.swift
//  NFTConnect-iOS
//
//  Created by Gianni Hong on 2024/1/26.
//

import UIKit
import Kingfisher

protocol NFTDetailViewProtocol {
    func openLink()
}

class NFTDetailView: UIView {
    var containerStackView: UIStackView!
    var imageView: UIImageView!
    var nameLabel: UILabel!
    var descriptionLabel: UILabel!
    var linkButton: UIButton!
    var imageViewRatioConstraint: NSLayoutConstraint?
    var delegate: NFTDetailViewProtocol?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        containerStackView = UIStackView()
        containerStackView.axis = .vertical
        containerStackView.spacing = 10.0
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView = UIImageView()
        containerStackView.addArrangedSubview(imageView)
        imageViewRatioConstraint = imageView.heightAnchor.constraint(equalTo: containerStackView.widthAnchor, multiplier: 1.0)
        
        nameLabel = UILabel()
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
        containerStackView.addArrangedSubview(nameLabel)
        descriptionLabel = UILabel()
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        descriptionLabel.font = UIFont.systemFont(ofSize: 14.0)
        containerStackView.addArrangedSubview(descriptionLabel)
        
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(containerStackView)
        
        let contentLayoutGuide = scrollView.contentLayoutGuide
        let frameLayoutGuide = scrollView.frameLayoutGuide
        var constraints = [
            containerStackView.topAnchor.constraint(equalTo: contentLayoutGuide.topAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: contentLayoutGuide.bottomAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: contentLayoutGuide.leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: contentLayoutGuide.trailingAnchor),
            containerStackView.widthAnchor.constraint(equalTo: frameLayoutGuide.widthAnchor)
        ]
        
        linkButton = UIButton()
        linkButton.backgroundColor = .blue
        linkButton.setTitle("Open Web", for: .normal)
        linkButton.translatesAutoresizingMaskIntoConstraints = false
        linkButton.addTarget(self, action: #selector(linkButtonTapped), for: .touchUpInside)
        addSubview(scrollView)
        addSubview(linkButton)
        constraints.append(contentsOf: [
            self.leadingAnchor.constraint(equalTo: linkButton.leadingAnchor, constant: -20),
            self.trailingAnchor.constraint(equalTo: linkButton.trailingAnchor, constant: 20),
            self.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor)
        ])
        
        let views = ["scrollView": scrollView, "linkButton": linkButton]
        let verticalFormatString = "V:|-[scrollView]-10-[linkButton]-20-|"
        let visualFormatConstraints = NSLayoutConstraint.constraints(withVisualFormat: verticalFormatString, metrics: nil, views: views as [String : Any])
        constraints.append(contentsOf: visualFormatConstraints)
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func setData(nft: NFT) {
        let imageURL = URL(string: nft.image.originalURL)
        KF.url(imageURL).onSuccess { result in
            self.imageViewRatioConstraint?.isActive = false
            let ratio = result.image.size.height / result.image.size.width
            self.imageViewRatioConstraint = self.imageView.heightAnchor.constraint(equalTo: self.containerStackView.widthAnchor, multiplier: ratio)
            self.imageViewRatioConstraint?.isActive = true
            self.layoutIfNeeded()
        }.set(to: imageView)
        nameLabel.text = nft.name
        descriptionLabel.text = nft.description
    }
    
    @objc func linkButtonTapped(sender: UIButton) {
        delegate?.openLink()
    }
}
