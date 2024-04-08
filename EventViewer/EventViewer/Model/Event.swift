//
//  Event.swift
//  EventViewer
//
//  Created by Chad Olsen on 8/7/19.
//  Copyright © 2019 colsen. All rights reserved.
//

import Foundation

struct EventList : Codable {
    let events : [Event]
    
    enum CodingKeys : String, CodingKey {
        case events
    }
}

struct Event : Codable {
    let id : Int
    let title : String
    let description : String?
    let dateTimeLocal : Date?
    let performers : [Performer]?
    let venue : Venue?
    let type : String?
    var favorite : Bool = false
}

extension Event {
    enum CodingKeys : String, CodingKey {
        case id
        case title
        case description
        case dateTimeLocal = "datetime_local"
        case performers
        case venue
        case type
    }
    
    func getImageUrl() -> URL? {
        if (performers?.count ?? 0 > 0) {
            return performers?[0].image
        } else {
            return nil
        }
    }
    
    func getDateString() -> String? {
        if let date = dateTimeLocal {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            return formatter.string(from: date)
        } else {
            return nil
        }
    }
}



struct Images : Codable {
    let huge : String?
    
    enum CodingKeys : String, CodingKey {
        case huge
    }
}
