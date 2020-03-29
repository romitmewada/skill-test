//
//  ViewController.swift
//  Heady - Skill Assessment Test
//
//  Created by Romit on 29/03/20.
//  Copyright © 2020 Romit. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.

		WebService.requestJSONData(responseHandler: { (response) in

			print(response)
			
		}) { (error) in

			print(error)
		}
	}


}

