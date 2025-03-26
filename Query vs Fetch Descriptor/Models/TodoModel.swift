//
//  TodoModel.swift
//  Query vs Fetch Descriptor
//
//  Created by Terje Moe on 20/03/2025.

import Foundation
import SwiftData
import SwiftUI

@Model
class TodoModel {
    var title: String = ""
    var date: Date = Date()
    var isCompleted: Bool = false
    var tags: Set<Tag>? = []
    
    init(
        title: String,
        date:Date = Date(),
        isCompleted: Bool = false,
        tags: Set<Tag> = []
    ) {
        self.title = title
        self.date = date
        self.isCompleted = isCompleted
        self.tags = tags
    }
}

enum Tag: String, Codable, CaseIterable {
    case work, personal, urgent, shopping, study
    
    var color: Color {
        switch self {
        case .work:
                .blue
        case .personal:
                .purple
        case .urgent:
                .red
        case .shopping:
                .green
        case .study:
                .orange
        }
    }
}
