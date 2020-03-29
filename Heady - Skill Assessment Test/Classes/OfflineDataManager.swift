//
//  OfflineDataManager.swift
//  Heady - Skill Assessment Test
//
//  Created by Romit on 29/03/20.
//  Copyright © 2020 Romit. All rights reserved.
//

import Foundation
import CoreData

open class OfflineDataManager: NSObject {

    public static let sharedInstance = OfflineDataManager()

    private override init() {}

    private func getContext() -> NSManagedObjectContext? {
        return self.persistentContainer.viewContext
    }

	lazy var persistentContainer: NSPersistentContainer = {

		let container = NSPersistentContainer(name: "OfflineData")
	    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
	        if let error = error as NSError? {
				print(error)
	        }
	    })
	    return container
	}()

    func retrieveCategories() -> [Categories]? {
        guard let managedContext = getContext() else { return nil }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Categories")

        do {
            let result = try managedContext.fetch(fetchRequest)
			return (result as! [Categories]);

        } catch {

            print("Failed")
			return nil
        }
	}

	func retrieveMultipleCategories(categories : NSArray) -> [Categories]? {
        guard let managedContext = getContext() else { return nil }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Categories")

		var predicateArray = [NSPredicate]()
		for categoryId in categories
		{
			print(categoryId)
			if let category_id : Int = (categoryId as! Int)
			{
				let predicate = NSPredicate(format: "id = %d", category_id)
				predicateArray.append(predicate)
			}
		}

		let orPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.or, subpredicates: predicateArray)
		fetchRequest.predicate = orPredicate

        do {
            let result = try managedContext.fetch(fetchRequest)
			return (result as! [Categories]);

        } catch {

			return nil
        }
	}

	func retrieveProductsByCategory(category_id : Int16) -> [Product]? {
        guard let managedContext = getContext() else { return nil }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Product")
		fetchRequest.predicate = NSPredicate(format: "category_id == %d", category_id)

        do {
            let result = try managedContext.fetch(fetchRequest)
			return (result as! [Product]);

        } catch {

            print("Failed")
			return nil
        }
	}

	func retrieveProductsById(product_id : Int16) -> [Product]? {
        guard let managedContext = getContext() else { return nil }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Product")
		fetchRequest.predicate = NSPredicate(format: "id == %d", product_id)

        do {
            let result = try managedContext.fetch(fetchRequest)
			return (result as! [Product]);

        } catch {

            print("Failed")
			return nil
        }
	}

	func retrieveProductsByRank() -> [Popular]? {
        guard let managedContext = getContext() else { return nil }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Popular")
//		fetchRequest.predicate = NSPredicate(format: "category_id == %d", category_id)

        do {
            let result = try managedContext.fetch(fetchRequest)
			return (result as! [Popular]);

        } catch {

            print("Failed")
			return nil
        }
	}

	func save(object : [String : Any])
	{
		let context = persistentContainer.viewContext

        do {
			let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Categories")
			fetchRequest.predicate = NSPredicate(format: "id = %d", object["id"] as! Int16)

			let oldObject = try context.fetch(fetchRequest)
			if(oldObject.count > 0)
			{
				let category = oldObject.first as? Categories
				try! category?.update(with: object)
                try context.save()
			}
			else {

				let entity = NSEntityDescription.entity(forEntityName: "Categories", in: context)!

				let category = NSManagedObject(entity: entity, insertInto: context) as? Categories
				try! category?.update(with: object)
				if(category!.hasChanges)
				{
					try context.save()
				}
			}
		} catch let error as NSError {
			print("Could not save. \(error), \(error.userInfo)")
		}
	}

	func saveRanking(object : [String : Any])
	{
		let context = persistentContainer.viewContext

        do {
			let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Popular")
			fetchRequest.predicate = NSPredicate(format: "ranking = %@", object["ranking"] as! String)

			let oldObject = try context.fetch(fetchRequest)
			if(oldObject.count > 0)
			{
				let popular = oldObject.first as? Popular
				try! popular?.update(with: object)
                try context.save()
			}
			else {

				let entity = NSEntityDescription.entity(forEntityName: "Popular", in: context)!

				let popular = NSManagedObject(entity: entity, insertInto: context) as? Popular
				try! popular?.update(with: object)
				if(popular!.hasChanges)
				{
					try context.save()
				}
			}
		} catch let error as NSError {
			print("Could not save. \(error), \(error.userInfo)")
		}
	}

}

extension Popular
{
	func update(with jsonDictionary: [String: Any]) throws {
        guard let ranking = jsonDictionary["ranking"] as? String,
            let products = jsonDictionary["products"] as? NSArray
            else {
                throw NSError(domain: "", code: 100, userInfo: nil)
        }

		self.ranking = ranking
		self.products = products
	}
}

extension Categories
{
    func update(with jsonDictionary: [String: Any]) throws {
        guard let name = jsonDictionary["name"] as? String,
            let id = jsonDictionary["id"] as? Int16,
            let productArray = jsonDictionary["products"] as? NSArray,
			let child_categories = jsonDictionary["child_categories"] as? NSArray
            else {
                throw NSError(domain: "", code: 100, userInfo: nil)
			}

		let context = OfflineDataManager.sharedInstance.persistentContainer.viewContext
		let entity = NSEntityDescription.entity(forEntityName: "Product", in: context)!

		let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Product")

		for productDictionary in productArray
		{
			if let dictionary = productDictionary as? [String : Any]
			{
				fetchRequest.predicate = NSPredicate(format: "id = %d", dictionary["id"] as! Int16)

				let oldObject = try context.fetch(fetchRequest)
				if(oldObject.count > 0)
				{
					let product = oldObject.first as? Product
					try! product?.update(with: dictionary, category_id: id)
					try context.save()
				}
				else {

					let product = NSManagedObject(entity: entity, insertInto: context) as? Product
					try! product?.update(with: productDictionary as! [String : Any], category_id: id)
					try! context.save()
				}
			}
		}

		self.name = name
		self.id = id
		self.child_categories = child_categories
    }
}

extension Product
{
	func update(with jsonDictionary: [String: Any], category_id: Int16) throws {
        guard let name = jsonDictionary["name"] as? String,
            let id = jsonDictionary["id"] as? Int,
            let variants = jsonDictionary["variants"] as? NSArray,
            let date_added = jsonDictionary["date_added"] as? String,
			let tax = jsonDictionary["tax"] as? [String : Any]
            else {
                throw NSError(domain: "", code: 100, userInfo: nil)
        }

		self.name = name
		self.id = Int16(id)
		self.variants = variants
		self.date_added = date_added
		self.tax = tax
		self.category_id = category_id
    }
}
