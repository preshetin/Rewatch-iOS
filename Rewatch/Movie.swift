//
//  Movie.swift
//  Rewatch
//
//  Created by Petr Reshetin on 25/11/2016.
//  Copyright © 2016 Petr Reshetin. All rights reserved.
//

import Foundation

struct Movie {
    var title : String
    var type : String
}

extension Movie {
    init?(json: [String: Any]) {
        guard let title = json["Title"] as? String,
            let type = json["Type"] as? String
            else {
                return nil
        }
        
        self.title = title
        self.type = type
    }
}
