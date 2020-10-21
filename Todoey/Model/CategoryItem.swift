//
//  Category.swift
//  Todoey
//
//  Created by Vasyl Senyshyn on 18.10.2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class CategoryItem: Object{
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    let items = List<Item>()
    
}
