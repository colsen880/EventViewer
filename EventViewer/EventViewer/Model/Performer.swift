//
//  Performer.swift
//  EventViewer
//
//  Created by Chad Olsen on 8/7/19.
//  Copyright © 2019 colsen. All rights reserved.
//

import Foundation

struct Performer : Codable {
    let image : URL?
    let images : Images?
    let name : String
    
    enum CodingKeys : String, CodingKey {
        case image
        case images
        case name
    }
}
