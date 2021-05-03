//
//  Storage.swift
//  YouStreamer
//
//  Created by Alexander Kozhevin on 01/08/2019.
//  Copyright © 2019 Alexander Kozhevin. All rights reserved.
//

import Foundation
import CoreData
import UIKit


func fillMetadata(store: NSPersistentStore, key : String, value : String) -> [String: Any] {
    
    var metadata: [String: Any] = store.metadata
    metadata[key] = value
    print(metadata)
    return metadata
}

func fillSettings(metadata: [String: Any], key : String) -> String {
    
    if let theAuthor = metadata[key] as? String {
        //author = theAuthor
        return theAuthor
    } else {
        return ""
    }
    
}

func StorageSave(key: String, value: String){
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate


    let context = appDelegate.persistentContainer.viewContext
    let store = context.persistentStoreCoordinator?.persistentStores.first
    
    let coordinator = context.persistentStoreCoordinator

   

    
    if let store = context.persistentStoreCoordinator?.persistentStores.first {
        let metadata = fillMetadata(store: store, key: key, value: value)
        store.metadata = metadata
        do {
            try coordinator?.setMetadata(["push_url": value], for: store)
            try context.save()
        } catch {
            
        }
        
    }
    
   
    
    
}





func StorageGet(key: String) -> String{
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    let context = appDelegate.persistentContainer.viewContext
    let store = context.persistentStoreCoordinator?.persistentStores.first
    if let store = context.persistentStoreCoordinator?.persistentStores.first,
        
        
        let metadata = context.persistentStoreCoordinator?.metadata(for: store) {
        
        

        return fillSettings(metadata: metadata, key: key)
    } else {
        return ""
    }
    
}

