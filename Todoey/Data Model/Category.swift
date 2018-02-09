//
//  Category.swift
//  Todoey
//
//  Created by Jami on 2018/2/9.
//  Copyright © 2018年 Jami. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}

