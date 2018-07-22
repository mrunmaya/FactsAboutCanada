//
//  Fact.swift
//  FactsAboutCanada
//
//  Created by mrunmaya pradhan on 21/07/18.
//  Copyright © 2018 Self. All rights reserved.
//

import Foundation
class Fact {
    var title: String?
    var description: String?
    var imageUrl: String?

    init(title: String?, description: String?, imageUrl: String?) {
        self.title = title
        self.description = description
        self.imageUrl = imageUrl
    }
}
