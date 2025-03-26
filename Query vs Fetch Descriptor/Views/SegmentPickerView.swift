//
//  SegmentPickerView.swift
//  Query vs Fetch Descriptor
//
//  Created by Terje Moe on 23/03/2025.
//

import SwiftUI

struct SegmentPickerView: View {
    @Binding var selectedSortOption: SortOption
    
    var body: some View {
        Picker(
            "Sort Todoes",
            selection: $selectedSortOption) {
                ForEach(SortOption.allCases, id: \.self) { option in
                    Text(option.rawValue)
                        .tag(option)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
    }
}
