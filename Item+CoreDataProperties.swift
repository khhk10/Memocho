//
//  Item+CoreDataProperties.swift
//  Memocho
//
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var text: String

}

extension Item : Identifiable {

}
