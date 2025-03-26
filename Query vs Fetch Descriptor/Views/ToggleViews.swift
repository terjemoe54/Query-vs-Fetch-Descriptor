//
//  ToggleViews.swift
//  Query vs Fetch Descriptor
//
//  Created by Terje Moe on 23/03/2025.
//

import SwiftUI

struct ToggleViews: View {
    @Binding var showCompletedOnly: Bool
    @Binding var showTodaysTodos: Bool
    var body: some View {
        // Toggle Completion
        Toggle("Show Completed Only", isOn: $showCompletedOnly)
        
        // Toggle show today
        Toggle("Show Today Todos", isOn: $showTodaysTodos)
    }
}
