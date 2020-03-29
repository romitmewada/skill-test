//
//  ProductDetailViewController.swift
//  Heady - Skill Assessment Test
//
//  Created by Romit on 29/03/20.
//  Copyright © 2020 Romit. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController {

	var product : Product?

	var selectedVariant : Int = 0;

	@IBOutlet weak var btnColor : UIButton?
	@IBOutlet weak var lblSize : UILabel?
	@IBOutlet weak var lblPrice : UILabel?
	@IBOutlet weak var lblTax : UILabel?
	@IBOutlet weak var lblTotal : UILabel?

	var picker  = UIPickerView()

    override func viewDidLoad() {
		super.viewDidLoad()

		self.title = self.product?.name

		let variants = self.product?.variants
		if let variant : [String : Any] = variants?.firstObject as? [String : Any]
		{
			self.updateUI(variant: variant)
		}
	}

	func updateUI(variant : [String : Any])
	{
		var productPrice : Int = 0
		if let color : String = variant["color"] as? String
		{
			self.btnColor?.setTitle(color, for: .normal)
		}
		if let size : Int = variant["size"] as? Int
		{
			self.lblSize?.attributedText =  String(size).addTitle(title: "Size: ")
		}
		if let price : Int = variant["price"] as? Int
		{
			productPrice = price
			self.lblPrice?.attributedText = String(price).convertDoubleToCurrency().addTitle(title: "Price: ")
		}
		if let tax : [String : Any] = product?.tax
		{
			if let name = tax["name"] as? String
			{
				if let value : Float = tax["value"] as? Float
				{
					self.lblTax?.attributedText = String(value).convertDoubleToCurrency().addTitle(title: name + ": ")

					let total = Float(productPrice) + value

					self.lblTotal?.attributedText = String(total).convertDoubleToCurrency().addTitle(title: "Total: ")
				}
			}
		}
	}

	@IBAction func btnColorTap()
	{
		let vc = UIViewController()
		vc.preferredContentSize = CGSize(width: 250,height: 300)
		let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 300))
		pickerView.delegate = self
		pickerView.dataSource = self
		pickerView.selectRow(self.selectedVariant, inComponent: 0, animated: false)
		vc.view.addSubview(pickerView)
		let alert = UIAlertController(title: "Choose Color", message: "", preferredStyle: UIAlertController.Style.alert)
		alert.setValue(vc, forKey: "contentViewController")
		alert.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
		self.present(alert, animated: true)

	}
}

extension ProductDetailViewController : UIPickerViewDataSource, UIPickerViewDelegate
{
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return (self.product?.variants!.count)!
	}

	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		if let variant : [String : Any] = self.product?.variants![row] as! [String : Any]
		{
			if let name : String = (variant["color"] as! String)
			{
				return name
			}
		}
		return nil
	}

	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

		if let variant : [String : Any] = self.product?.variants![row] as! [String : Any]
		{
			self.selectedVariant = row
			self.updateUI(variant: variant)
		}
	}
}
