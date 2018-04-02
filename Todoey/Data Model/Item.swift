//
//  Item.swift
//  Todoey
//
//  Created by Jason Lewis on 2018-03-29.
//  Copyright © 2018 Controlsequipment. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date = Date()
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
