//
//  MenuView.swift
//  HSTestTask
//
//  Created by Темирлан Кудайберген on 23.06.2023.
//

import UIKit

final class MenuView: UIView {
    
//    MARK: UI
    
    private let cityLabel: UILabel = {
        let cityLabel = UILabel()
        cityLabel.font = UIFont.systemFont(ofSize: 17)
        cityLabel.text = "Москва"
        return cityLabel
    }()
    
    private let cityPickerButton: UIButton = {
        let cityPickerButton = UIButton()
        cityPickerButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        cityPickerButton.tintColor = .black
        return cityPickerButton
    }()
    
    lazy var bannerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: 300, height: 115)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    lazy var categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: 88, height: 32)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    var coctailListTableView = UITableView()
    
//    MARK: Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: Setup
    
    private func configureUI() {
        bannerCollectionView.register(
            BannerCollectionViewCell.self,
            forCellWithReuseIdentifier: BannerCollectionViewCell.identifier
        )
        
        categoryCollectionView.register(
            CategoryCollectionViewCell.self,
            forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier
        )
        
        coctailListTableView.register(
            CoctailListTableViewCell.self,
            forCellReuseIdentifier: CoctailListTableViewCell.identifier
        )
        coctailListTableView.layer.cornerRadius = 15
        coctailListTableView.clipsToBounds = true
        coctailListTableView.backgroundColor = .clear
    }
    
    private func layout() {
        addSubview(bannerCollectionView)
        addSubview(categoryCollectionView)
        addSubview(coctailListTableView)
        addSubview(cityLabel)
        addSubview(cityPickerButton)
        
        bannerCollectionView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(7)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(112)
        }
        
        categoryCollectionView.snp.makeConstraints {
            $0.top.equalTo(bannerCollectionView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(32)
        }
        
        coctailListTableView.snp.makeConstraints {
            $0.top.equalTo(categoryCollectionView.snp.bottom).offset(24)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        cityLabel.snp.makeConstraints {
            $0.top.equalTo(bannerCollectionView.snp.top).offset(-39)
            $0.leading.equalToSuperview().offset(16)
        }
        
        cityPickerButton.snp.makeConstraints {
            $0.top.equalTo(bannerCollectionView.snp.top).offset(-39)
            $0.leading.equalTo(cityLabel.snp.trailing).offset(8)
        }
    }
}

