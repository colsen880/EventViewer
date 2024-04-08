//
//  Venue.swift
//  EventViewer
//
//  Created by Chad Olsen on 8/7/19.
//  Copyright © 2019 colsen. All rights reserved.
//

import Foundation

struct Venue : Codable {
    let displayLocation : String
    
    enum CodingKeys : String, CodingKey {
        case displayLocation = "display_location"
    }
}
