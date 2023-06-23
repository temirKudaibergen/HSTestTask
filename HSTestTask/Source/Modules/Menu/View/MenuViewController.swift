//
//  MenuViewController.swift
//  HammersSystemTestApp
//
//  Created by Темирлан Кудайберген on 23.06.2023.
//

import UIKit
import SnapKit

final class MenuViewController: UIViewController {
    
//    MARK: Properties
    
    var presenter: MenuPresenterInput?
    private var prevIndex = 0
    private var menuView: MenuView!
    
//    MARK: Lifecyle
    
    override func loadView() {
        super.loadView()
        menuView = MenuView()
        menuView.bannerCollectionView.dataSource = self
        menuView.bannerCollectionView.delegate = self
        menuView.categoryCollectionView.dataSource = self
        menuView.categoryCollectionView.delegate = self
        menuView.coctailListTableView.dataSource = self
        menuView.coctailListTableView.delegate = self
        view = menuView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        callPresenter()
    }
    
//    MARK: Setup
    
    private func callPresenter() {
        presenter?.getData()
        presenter?.getImage()
    }
    
    private func style() {
        view.backgroundColor = .systemGray6
    }
}

// MARK: - UICollectionViewDataSource

extension MenuViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView === menuView.bannerCollectionView {
            return 3
        } else {
            return presenter?.numberOfCategories() ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView === menuView.bannerCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCollectionViewCell.identifier, for: indexPath) as? BannerCollectionViewCell else {
                return UICollectionViewCell()
            }
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as? CategoryCollectionViewCell,
                  let category = presenter?.categoryModel(at: indexPath.row) else {
                return UICollectionViewCell()
            }
            cell.configure(withDrink: category)
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate

extension MenuViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if collectionView === menuView.categoryCollectionView,
           let category = presenter?.categoryModel(at: indexPath.row),
           let index = presenter?.firstIndexOfDrink(with: category)  {
            menuView.coctailListTableView.scrollToRow(at: IndexPath(row: index, section: 0), at: .top, animated: false)
        }
    }
}

// MARK: - UITableViewDataSource

extension MenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfDrinks() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CoctailListTableViewCell.identifier, for: indexPath) as? CoctailListTableViewCell,
              let drink = presenter?.drinkModel(at: indexPath.row) else {
            return UITableViewCell()
        }
        cell.configure(withDrink: drink)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 210
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView === menuView.coctailListTableView else {
            return
        }
        
        if let firstIndex = menuView.coctailListTableView.indexPathsForVisibleRows?.first?.row,
           let drink = presenter?.drinkModel(at: firstIndex),
           let category = drink.category,
           let indexOfCategory = presenter?.indexOfCategory(category) {
            
            menuView.categoryCollectionView.scrollToItem(
                at: IndexPath(row: indexOfCategory, section: 0),
                at: [.centeredVertically, .centeredHorizontally],
                animated: false
            )
            if let cell = menuView.categoryCollectionView.cellForItem(at: IndexPath(row: prevIndex, section: 0)) {
                cell.contentView.backgroundColor = .white
                cell.contentView.layer.borderWidth = 1
                (cell as? CategoryCollectionViewCell)?.categoryLabel.textColor = UIColor.lightPink
            }
            
            if let cell = menuView.categoryCollectionView.cellForItem(at: IndexPath(row: indexOfCategory, section: 0)) {
                prevIndex = indexOfCategory
                cell.contentView.backgroundColor = UIColor.categoryBackgroundColor
                cell.contentView.layer.borderWidth = 0
                (cell as? CategoryCollectionViewCell)?.categoryLabel.textColor = UIColor.standardPink
            }
        }
        
        if scrollView.contentOffset.y >= 100 {
            menuView.categoryCollectionView.snp.remakeConstraints { make in
                make.top.equalTo(menuView.bannerCollectionView)
                make.leading.equalTo(view).offset(16)
                make.trailing.equalTo(view)
                make.height.equalTo(32)
            }
            
            UIView.animate(withDuration: 0.2, animations: {
                self.menuView.bannerCollectionView.isHidden = true
                self.view.layoutIfNeeded()
            })
            
        } else {
            menuView.categoryCollectionView.snp.remakeConstraints { make in
                make.top.equalTo(menuView.bannerCollectionView.snp.bottom).offset(24)
                make.leading.equalTo(view).offset(16)
                make.trailing.equalTo(view)
                make.height.equalTo(32)
            }
            
            UIView.animate(withDuration: 0.2, animations: {
                self.menuView.bannerCollectionView.isHidden = false
                self.view.layoutIfNeeded()
            })
        }
    }
}

// MARK: - MenuPresenterOutput

extension MenuViewController: MenuPresenterOutput {
    func reloadTableView() {
        DispatchQueue.main.async {
            self.menuView.coctailListTableView.reloadData()
            self.menuView.categoryCollectionView.reloadData()
        }
    }
}

