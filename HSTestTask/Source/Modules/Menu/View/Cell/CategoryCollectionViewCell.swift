//
//  CategoryCollectionViewCell.swift
//  HSTestTask
//
//  Created by Темирлан Кудайберген on 23.06.2023.
//

import UIKit
import SnapKit

final class CategoryCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CategoryCollectionViewCell"
    
    let categoryLabel: UILabel = {
        let categoryLabel = UILabel()
        categoryLabel.textAlignment = .center
        categoryLabel.textColor = UIColor.lightPink
        categoryLabel.font = UIFont.boldSystemFont(ofSize: 13)
        return categoryLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        style()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(withDrink drink: String) {
        categoryLabel.text = drink
    }
    
    private func style() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 15
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.borderColor
    }
    
    private func layout() {
        contentView.addSubview(categoryLabel)
        categoryLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(contentView)
            make.width.equalTo(70)
        }
    }
}
