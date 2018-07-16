//
//  Category.swift
//  Todoey
//
//  Created by AshwaniKumar on 14/07/18.
//  Copyright © 2018 Ashwani Kumar. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var colour: String = ""
    let items = List<Item>()
}

