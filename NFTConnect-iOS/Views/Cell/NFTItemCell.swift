//
//  NFTItemCell.swift
//  NFTConnect-iOS
//
//  Created by Gianni Hong on 2024/1/23.
//

import UIKit
import Kingfisher

class NFTItemCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    private func setupView() {
        // Customization
    }
    
    func setData(name: String, imageURL: String) {
        let url = URL(string: imageURL)
        imageView.kf.setImage(with: url)
        nameLabel.text = name
    }
}
