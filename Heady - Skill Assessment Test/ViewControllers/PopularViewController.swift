//
//  ProductListViewController.swift
//  Heady - Skill Assessment Test
//
//  Created by Romit on 29/03/20.
//  Copyright © 2020 Romit. All rights reserved.
//

import UIKit

class PopularViewController: UITableViewController {

	var popular : [Popular]?

	var selectedArray : [[String : Any]]?
	var selectedIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()

		self.reloadData()
    }

	func reloadData()
	{
		if let array : [Popular] = OfflineDataManager.sharedInstance.retrieveProductsByRank()
		{
			if(array.count > 0)
			{
				self.popular = array;

				self.updateRightBarButton(ranking: self.popular![self.selectedIndex].ranking!)

				if let value : [[String : Any]] = self.popular![self.selectedIndex].products as? [[String : Any]]
				{
					self.selectedArray = value.sorted(by: { (ob1 : [String : Any], ob2 : [String : Any]) -> Bool in

						var count1 : Int = 0 //(ob1["view_count"] as? Int)!
						var count2 : Int = 0 //(ob2["view_count"] as? Int)!

						if let _ = ob1["view_count"] {

							count1 = (ob1["view_count"] as? Int)!
							count2 = (ob2["view_count"] as? Int)!
						}

						if let _ = ob1["order_count"] {

							count1 = (ob1["order_count"] as? Int)!
							count2 = (ob2["order_count"] as? Int)!
						}

						if let _ = ob1["shares"] {

							count1 = (ob1["shares"] as? Int)!
							count2 = (ob2["shares"] as? Int)!
						}

						if(count1 > count2)
						{
							return true
						}
						return false
					})
				}
				self.tableView.reloadData();
			}
		}
	}

	func updateRightBarButton(ranking : String)
	{
		let barButton = UIBarButtonItem.init(title: ranking, style: .done, target: self, action: #selector(openPopup))
		self.navigationItem.rightBarButtonItem = barButton
	}

	@objc func openPopup()
	{
		let vc = UIViewController()
		vc.preferredContentSize = CGSize(width: 250,height: 300)
		let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 300))
		pickerView.delegate = self
		pickerView.dataSource = self
//		pickerView.selectRow(self.selectedVariant, inComponent: 0, animated: false)
		vc.view.addSubview(pickerView)
		let alert = UIAlertController(title: "Choose Color", message: "", preferredStyle: UIAlertController.Style.alert)
		alert.setValue(vc, forKey: "contentViewController")

		alert.addAction(UIAlertAction.init(title: "Done", style: .default, handler: { (action) in

			self.selectedIndex = pickerView.selectedRow(inComponent: 0)
			self.reloadData()
		}))
		self.present(alert, animated: true)
	}
}

extension PopularViewController : UIPickerViewDataSource, UIPickerViewDelegate
{
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return self.popular!.count
	}

	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		if let popular : Popular = self.popular![row]
		{
			return popular.ranking
		}
		return nil
	}
}

extension PopularViewController
{
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

		return (self.selectedArray != nil) ? self.selectedArray!.count : 0
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

		var value : [String : Any] = self.selectedArray![indexPath.row]

		if let name : NSNumber = value["id"] as? NSNumber
		{
			if let product : Product = value["product"] as? Product
			{
				cell.textLabel?.text = product.name
			}
			else{
				let result = OfflineDataManager.sharedInstance.retrieveProductsById(product_id: name.int16Value)
				value["product"] = result?.first
				self.selectedArray![indexPath.row] = value
				cell.textLabel?.text = result?.first!.name
			}
		}


		return cell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		let viewController : ProductDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "productDetailViewController") as! ProductDetailViewController
		viewController.product = self.selectedArray![indexPath.row]["product"] as? Product
		self.navigationController?.pushViewController(viewController, animated: true)
	}
}
