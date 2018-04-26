//
//  Expense+CoreDataProperties.swift
//  Expenses
//
//  Created by Mandy Rogers on 4/26/18.
//  Copyright © 2018 Mandy Rogers. All rights reserved.
//
//

import Foundation
import CoreData


extension Expense {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expense> {
        return NSFetchRequest<Expense>(entityName: "Expense")
    }

    @NSManaged public var name: String?
    @NSManaged public var amount: Double
    @NSManaged public var rawDate: NSDate?

}
