//
//  Item.swift
//  Todoey
//
//  Created by AshwaniKumar on 14/07/18.
//  Copyright © 2018 Ashwani Kumar. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var status: Bool = false
    @objc dynamic var dateCreated: Date?
    let parentCategory = LinkingObjects(fromType: Category.self, property: "items")  //reverse relation
}
