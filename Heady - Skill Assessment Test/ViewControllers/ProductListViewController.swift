//
//  ProductListViewController.swift
//  Heady - Skill Assessment Test
//
//  Created by Romit on 29/03/20.
//  Copyright © 2020 Romit. All rights reserved.
//

import UIKit

class ProductListViewController: UITableViewController {

	var category : Categories?
	var products : [Product] = [];

    override func viewDidLoad() {
        super.viewDidLoad()

		self.title = category?.name

		self.loadData()
    }

	func loadData()
	{
//		let arr : [Popular] = OfflineDataManager.sharedInstance.retrieveProductsByRank()!
//		print(arr)

		if let array : [Product] = OfflineDataManager.sharedInstance.retrieveProductsByCategory(category_id: category!.id)
		{
			self.products = array;
			self.tableView.reloadData();
		}
	}
}

extension ProductListViewController
{
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

		return self.products.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

		let product : Product = products[indexPath.row]
		cell.textLabel?.text = product.name

		return cell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		let viewController : ProductDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "productDetailViewController") as! ProductDetailViewController
		viewController.product = self.products[indexPath.row];
		self.navigationController?.pushViewController(viewController, animated: true)
	}
}
