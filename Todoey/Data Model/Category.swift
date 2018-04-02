//
//  Category.swift
//  Todoey
//
//  Created by Jason Lewis on 2018-03-29.
//  Copyright © 2018 Controlsequipment. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    
    @objc dynamic var name : String = ""
    
    let items = List<Item>()
    
}
