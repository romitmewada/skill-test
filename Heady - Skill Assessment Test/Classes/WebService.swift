//
//  WebService.swift
//  Heady - Skill Assessment Test
//
//  Created by Romit on 29/03/20.
//  Copyright © 2020 Romit. All rights reserved.
//

import Foundation
import Alamofire

class WebService: NSObject {

	static func requestJSONData(responseHandler: @escaping (Dictionary<String, Any>) -> Void, responseFailHandler: @escaping (Error) -> Void)
	{
		AF.request(Urls.data_url).responseJSON { (response) in

			switch response.result {
			case .success:

				do{
					let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String : Any]

					if let categories : [[String : Any]]  = json!["categories"] as? [[String : Any]]
					{
						for category in categories
						{
							OfflineDataManager.sharedInstance.save(object: category)
						}
					}

					DispatchQueue.main.async {
						responseHandler(json!);
					}
				}
				catch{
					responseFailHandler(error);

				}
				break

			case .failure(let error):
				print(error)
				DispatchQueue.main.async {
					responseFailHandler(error as NSError);
				}
			}
		};
	}
}
