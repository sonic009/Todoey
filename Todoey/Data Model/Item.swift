//
//  Item.swift
//  Todoey
//
//  Created by AshwaniKumar on 10/07/18.
//  Copyright © 2018 Ashwani Kumar. All rights reserved.
//

import Foundation

class Item: Codable {               //Codable includes both Encodable & Decodable as well.
    var title: String = ""
    var status: Bool = false
}
