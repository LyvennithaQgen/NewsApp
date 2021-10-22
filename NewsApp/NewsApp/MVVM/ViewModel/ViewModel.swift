//
//  ViewModel.swift
//  ShoppingTask
//
//  Created by TECH ZAR INFO on 29/11/20.
//  Copyright © 2020 personal. All rights reserved.
//

import Foundation
import UIKit
import CoreData

enum CoreDataKeys: String{
    
    case author = "author"
    case title = "title"
    case url = "url"
    case urlToImage = "imageURL"
    case publishedAt = "publishedAt"
    case content = "content"
    
}


class NewsListViewModel{
    var newsData: NewsResponse?
    private let apiService = NewListsAPI()
    static let shared = NewsListViewModel()
    private init(){
        print("I'm Borned NewsListViewModel")
    }
    
    func news_list( success: @escaping () -> (), onError: @escaping(String) -> ()) {
        apiService.getLatestNews(success: { (response) in
            self.newsData = response
            let articles = self.newsData?.articles
            var dict = [String: Any]()
            for data in articles ?? []{
                dict[CoreDataKeys.author.rawValue] = data.author
                dict[CoreDataKeys.title.rawValue] = data.title
                dict[CoreDataKeys.urlToImage.rawValue] = data.urlToImage
                dict[CoreDataKeys.url.rawValue] = data.url
                dict[CoreDataKeys.content.rawValue] = data.content
                dict[CoreDataKeys.publishedAt.rawValue] = data.publishedAt
                CoreDataManager.shared.createData(entity: "NewsData", dict: dict)
                
            }
            
            
            //self.newsData = CoreDataManager.shared.retrieveData(entity: "NewsData")
            success()
        }) { (error) in
            onError(error.localizedDescription)
        }
    }
}


class CoreDataManager{
    
    static var shared = CoreDataManager()
    
    func convertImageToBase64String (img: UIImage) -> String {
        let imageData:NSData = img.jpegData(compressionQuality: 0.50)! as NSData
        let imgString = imageData.base64EncodedString(options: .init(rawValue: 0))
        return imgString
    }
    
    func convertBase64StringToImage (imageBase64String:String) -> UIImage {
        let imageData = Data.init(base64Encoded: imageBase64String, options: .init(rawValue: 0))
        let image = UIImage(data: imageData!)!
        return image
    }
    
    //CRUD functions
    
    func createData(entity: String?, dict: [String:Any]){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let userEntity = NSEntityDescription.entity(forEntityName: entity ?? "", in: managedContext)!
        
        let product = NSManagedObject(entity: userEntity, insertInto: managedContext)
        product.setValue(dict[CoreDataKeys.author.rawValue], forKeyPath: CoreDataKeys.author.rawValue)
        product.setValue(dict[CoreDataKeys.title.rawValue], forKeyPath: CoreDataKeys.title.rawValue)
        product.setValue(dict[CoreDataKeys.url.rawValue], forKeyPath: CoreDataKeys.url.rawValue)
        product.setValue(dict[CoreDataKeys.urlToImage.rawValue], forKeyPath: CoreDataKeys.urlToImage.rawValue)
        product.setValue(dict[CoreDataKeys.publishedAt.rawValue], forKeyPath: CoreDataKeys.publishedAt.rawValue)
        product.setValue(dict[CoreDataKeys.content.rawValue], forKeyPath: CoreDataKeys.content.rawValue)
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity ?? "")
            fetchRequest.predicate = NSPredicate(format: "author = %@", CoreDataKeys.author.rawValue)
            let result = try managedContext.fetch(fetchRequest)
            if result.count == 0{
            try managedContext.save()
            }
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
    func retrieveData(entity: String?) -> [NSManagedObject] {
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        var data = [NSManagedObject]()
        
        let managedContext = appDelegate?.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity ?? "")
        let nameSort = NSSortDescriptor(key:"author", ascending:true)
        fetchRequest.sortDescriptors = [nameSort]
        
        do {
            let result = try managedContext?.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                print(data.value(forKey: "author") as! String)
            }
            data = result  as! [NSManagedObject]
            
        } catch {
            
            print("Failed")
        }
        
        return data
    }
    
    func updateData(entity: String?, dict: [String:Any]){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: entity ?? "")
        fetchRequest.predicate = NSPredicate(format: "author = %@", CoreDataKeys.author.rawValue)
        do
        {
            let test = try managedContext.fetch(fetchRequest)
            
            let objectUpdate = test[0] as! NSManagedObject
            objectUpdate.setValue(dict[CoreDataKeys.author.rawValue], forKeyPath: CoreDataKeys.author.rawValue)
            objectUpdate.setValue(dict[CoreDataKeys.title.rawValue], forKeyPath: CoreDataKeys.title.rawValue)
            objectUpdate.setValue(dict[CoreDataKeys.url.rawValue], forKeyPath: CoreDataKeys.url.rawValue)
            objectUpdate.setValue(dict[CoreDataKeys.urlToImage.rawValue], forKeyPath: CoreDataKeys.urlToImage.rawValue)
            objectUpdate.setValue(dict[CoreDataKeys.publishedAt.rawValue], forKeyPath: CoreDataKeys.publishedAt.rawValue)
            objectUpdate.setValue(dict[CoreDataKeys.content.rawValue], forKeyPath: CoreDataKeys.content.rawValue)
            
            do{
                try managedContext.save()
            }
            catch
            {
                print(error)
            }
        }
        catch
        {
            print(error)
        }
        
    }
    
    func deleteData(entity: String?, name: String?){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity ?? "")
        fetchRequest.predicate = NSPredicate(format: "author = %@", CoreDataKeys.author.rawValue)
        
        do
        {
            let test = try managedContext.fetch(fetchRequest)
            
            let objectToDelete = test[0] as! NSManagedObject
            managedContext.delete(objectToDelete)
            
            do{
                try managedContext.save()
            }
            catch
            {
                print(error)
            }
            
        }
        catch
        {
            print(error)
        }
    }
    func convertToJSONArray(moArray: [NSManagedObject]) -> Any {
        var jsonArray: [[String: Any]] = []
        for item in moArray {
            var dict: [String: Any] = [:]
            for attribute in item.entity.attributesByName {
                //check if value is present, then add key to dictionary so as to avoid the nil value crash
                if let value = item.value(forKey: attribute.key) {
                    dict[attribute.key] = value
                }
            }
            jsonArray.append(dict)
        }
        return jsonArray
    }
  
}


