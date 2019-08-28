//
//  ArtistModel.swift
//  FireBaseDB
//
//  Created by Antony Leo Ruban Yesudass on 28/08/19.
//  Copyright © 2019 Antony Leo Ruban Yesudass. All rights reserved.
//

import Foundation

class ArtistModel {
    
    var id: String?
    var name: String?
    var genre: String?
    
    init(id: String?, name: String?, genre: String?){
        self.id = id
        self.name = name
        self.genre = genre
    }
}
