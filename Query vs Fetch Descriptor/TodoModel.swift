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
    var isCompleted: Bool
    
    init(
    title: String,
    date:Date = Date(),
    isCompleted: Bool = false
    ) {
        self.title = title
        self.date = date
        self.isCompleted = isCompleted
    
    }
    
}
