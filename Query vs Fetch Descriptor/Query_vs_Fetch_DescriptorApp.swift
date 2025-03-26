//
//  Query_vs_Fetch_DescriptorApp.swift
//  Query vs Fetch Descriptor
//
//  Created by Terje Moe on 20/03/2025.

import SwiftUI
import SwiftData

@main
struct Query_vs_Fetch_DescriptorApp: App {
    var body: some Scene {
        WindowGroup {
            TodoListView()
                .modelContainer(for: TodoModel.self)
        }
    }
}
