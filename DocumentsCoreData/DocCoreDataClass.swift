//
//  DocCoreDataClass.swift
//  DocumentsCoreData
//
//  Created by Jasmine Tan on 2/21/20.
//  Copyright © 2020 Jasmine Tan. All rights reserved.
//

import Foundation

import UIKit
import CoreData
@objc(Doc)
public class Doc: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Doc> {
        return NSFetchRequest<Doc>(entityName: "Doc")
    }
    @NSManaged public var date: NSDate?
    @NSManaged public var text: String?
    @NSManaged public var name: String?
    @NSManaged public var size: Int64
 
    
      var modifiedDate: Date? {
        get {
            return date as Date?
        }
        set {
            date = newValue as NSDate?
        }
    }
    convenience init?(name: String?, text: String?) {
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            guard let managedContext = appDelegate?.persistentContainer.viewContext,
                let name = name, name != "" else {
                    return nil
            }
            self.init(entity: Doc.entity(), insertInto: managedContext)
            self.name = name
            self.text = text
            if let size = text?.count {
                self.size = Int64(size)
            } else {
                self.size = 0
            }
            
        self.date = Date(timeIntervalSinceNow: 0) as NSDate
        }
        
        func update(name: String, text: String?) {
            self.name = name
            self.text = text
            if let size = text?.count {
                self.size = Int64(size)
            } else {
                self.size = 0
            }
        
            self.modifiedDate = Date(timeIntervalSinceNow: 0)
        }
    }
