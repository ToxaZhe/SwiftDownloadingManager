//
//  CoreDataManager.swift
//  SwiftDownloadingManager
//
//  Created by user on 11/23/16.
//  Copyright © 2016 Toxa. All rights reserved.
//

import Foundation
import CoreData


class CoreDataManager: NSObject {
    
    static let instance = CoreDataManager()
    var moc: NSManagedObjectContext?
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SwiftDownloadingManager")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func getContext () -> NSManagedObjectContext? {
        if moc != nil {
            return moc
        } else {
            moc = self.persistentContainer.viewContext
            return moc
        }
    }
    
    // MARK: - Core Data Saving/Fetching/Deleting
    
    func saveContext () {
        
        
        let context = getContext()
        
        
        if context!.hasChanges {
            do {
                try context!.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func saveMox(storeMod: DownloadInfo, onError:(Error) -> ()) {
        let context = getContext()
        do {
            try context!.save()
            print("saved")
        }  catch {
            onError(error)
        }
    }
    
    
    func getSortedFetch(onSuccess:([DownloadInfo]) -> (), onError:(Error) -> ()) {
        let context = getContext()
        let fetchRequest: NSFetchRequest<DownloadInfo> = DownloadInfo.fetchRequest()
        do {
            
            let searchResults = try context!.fetch(fetchRequest)
            
            print ("num of results = \(searchResults.description)")
            
            let res = searchResults.sorted(by: {$0.finishedDownload! <
                $1.finishedDownload!})
            onSuccess(res)
        } catch {
            
            onError(error)
            
        }
        
    }
    
    func removeEntity(songName: String, onError:(Error) -> ()) {
        let context = getContext()
        let fetchRequest: NSFetchRequest<DownloadInfo> = DownloadInfo.fetchRequest()
        let predicate = NSPredicate(format: "fileName == %@", songName)
        fetchRequest.predicate = predicate
        do {
            let searchResults = try context!.fetch(fetchRequest)
            for res in searchResults {
                context!.delete(res)
                print("successfully removed entity")
            }
        } catch {
            onError(error)
        }
        saveContext()
    }
}


extension NSDate {
    static public func <(a: NSDate, b: NSDate) -> Bool {
        return a.compare(b as Date) == ComparisonResult.orderedAscending
    }
    
}
