//
//  Item.swift
//  Todoey
//
//  Created by Vasyl Senyshyn on 18.10.2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object{

    
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var date =  NSDate()
    @objc dynamic var colorItem: String = ""
    var parentCategory = LinkingObjects(fromType: CategoryItem.self, property: "items")
}
