//
//  SubCategory.swift
//  Heady - Skill Assessment Test
//
//  Created by Romit on 29/03/20.
//  Copyright © 2020 Romit. All rights reserved.
//

import UIKit

protocol SubCategoriesDelegate {
	func didSelectAtSubCategory(category : Categories)
}

class SubCategories: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {

	var categoryDelegate : SubCategoriesDelegate?

	var categories : [Categories]?

	var category : Categories?
	{
		didSet{

			self.categories = OfflineDataManager.sharedInstance.retrieveMultipleCategories(categories: self.category!.child_categories!)

			self.reloadData()
		}
	}

	func setCollectionLayout()
	{
		let cellSize = CGSize(width:182 , height:74)

		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .horizontal
		layout.itemSize = cellSize
		layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
		layout.minimumLineSpacing = 1.0
		layout.minimumInteritemSpacing = 1.0
		self.setCollectionViewLayout(layout, animated: true)
	}

	override func awakeFromNib() {
		super.awakeFromNib()

		self.dataSource = self
		self.delegate = self

		self.setCollectionLayout()
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.categories!.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
		let lbl : UILabel = cell.viewWithTag(151) as! UILabel
		lbl.text = self.categories![indexPath.item].name
		return cell
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

		if(self.categoryDelegate != nil)
		{
			self.categoryDelegate?.didSelectAtSubCategory(category: self.categories![indexPath.item])
		}

	}
}
