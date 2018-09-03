//
//  UIViewController+CoreData.swift
//  ComprasUSA
//
//  Created by Desenvolvimento on 03/09/18.
//  Copyright © 2018 Rafael. All rights reserved.
//

import UIKit
import CoreData


extension UIViewController {
    var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
}
