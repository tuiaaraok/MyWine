//
//  CoreDataManager.swift
//  My_Wine
//
//  Created by Karen Khachatryan on 07.10.24.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "My_Wine")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func fetchWine(completion: @escaping ([WineModel], Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Wine> = Wine.fetchRequest()
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                var wineModels: [WineModel] = []
                for result in results {
                    let wineModel = WineModel(id: result.id ?? UUID(), name: result.name, photo: result.photo, grape: result.grape, country: result.country, year: result.year, qualities: result.qualities, rating: result.rating, isFavorite: result.isFavorite, isMyWine: result.isMyWine)
                    wineModels.append(wineModel)
                }
                DispatchQueue.main.async {
                    completion(wineModels, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion([], error)
                }
            }
        }
    }
    
    func fetchFavoriteWine(completion: @escaping ([WineModel], Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Wine> = Wine.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "isFavorite == %@", NSNumber(value: true))
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                var wineModels: [WineModel] = []
                for result in results {
                    let wineModel = WineModel(id: result.id ?? UUID(),
                                              name: result.name,
                                              photo: result.photo,
                                              grape: result.grape,
                                              country: result.country,
                                              year: result.year,
                                              qualities: result.qualities,
                                              rating: result.rating,
                                              isFavorite: result.isFavorite,
                                              isMyWine: result.isMyWine)
                    wineModels.append(wineModel)
                }
                DispatchQueue.main.async {
                    completion(wineModels, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion([], error)
                }
            }
        }
    }
    
    func fetchMyWine(completion: @escaping ([WineModel], Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Wine> = Wine.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "isMyWine == %@", NSNumber(value: true))
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                var wineModels: [WineModel] = []
                for result in results {
                    let wineModel = WineModel(id: result.id ?? UUID(),
                                              name: result.name,
                                              photo: result.photo,
                                              grape: result.grape,
                                              country: result.country,
                                              year: result.year,
                                              qualities: result.qualities,
                                              rating: result.rating,
                                              isFavorite: result.isFavorite,
                                              isMyWine: result.isMyWine)
                    wineModels.append(wineModel)
                }
                DispatchQueue.main.async {
                    completion(wineModels, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion([], error)
                }
            }
        }
    }
    
    func saveWine(wineModel: WineModel, completion: @escaping (Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Wine> = Wine.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", wineModel.id as CVarArg)
            
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                let wine: Wine

                if let existingWine = results.first {
                    wine = existingWine
                } else {
                    wine = Wine(context: backgroundContext)
                    wine.id = wineModel.id
                }
                wine.country = wineModel.country
                wine.grape = wineModel.grape
                wine.isFavorite = wineModel.isFavorite
                wine.isMyWine = wineModel.isMyWine
                wine.name = wineModel.name
                wine.photo = wineModel.photo
                wine.qualities = wineModel.qualities
                wine.rating = wineModel.rating
                wine.year = wineModel.year
                try backgroundContext.save()
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
    
}
