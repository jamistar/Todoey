//
//  Item.swift
//  Todoey
//
//  Created by Jami on 2018/2/9.
//  Copyright © 2018年 Jami. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
