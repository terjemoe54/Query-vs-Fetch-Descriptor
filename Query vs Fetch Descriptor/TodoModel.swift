//
//  TodoModel.swift
//  Query vs Fetch Descriptor
//
//  Created by Terje Moe on 20/03/2025.
//

import Foundation
import SwiftData

@Model
class TodoModel {
    var title: String
    var date: Date
    
    init(title: String, date: Date) {
        self.title = title
        self.date = date
    }
    
}
