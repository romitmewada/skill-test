//
//  ViewController.swift
//  Heady - Skill Assessment Test
//
//  Created by Romit on 29/03/20.
//  Copyright © 2020 Romit. All rights reserved.
//

import UIKit

class CategoriesViewController: UITableViewController {

	var categoryArray : [Categories] = [];
	var activityIndicator : UIActivityIndicatorView?

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.

		self.title = "Categories"

		WebService.requestJSONData(responseHandler: { (response) in

			self.loadData();

		}) { (error) in

			self.loadData();
		}
	}

	func loadData()
	{
		if let array : [Categories] = OfflineDataManager.sharedInstance.retrieveCategories()
		{
			self.categoryArray = array;
			self.tableView.reloadData();
			self.activityIndicator?.stopAnimating()
		}
	}
}

//TableView DataSource & Delegate
extension CategoriesViewController
{
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

		return self.categoryArray.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		cell.textLabel?.text = self.categoryArray[indexPath.row].name
		return cell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		let viewController : ProductListViewController = self.storyboard?.instantiateViewController(withIdentifier: "productListViewController") as! ProductListViewController
		viewController.category = self.categoryArray[indexPath.row];
		self.navigationController?.pushViewController(viewController, animated: true)
	}
}
