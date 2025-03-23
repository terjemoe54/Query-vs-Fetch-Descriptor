//
//  SelectDateView.swift
//  Query vs Fetch Descriptor
//
//  Created by Terje Moe on 23/03/2025.
//


import SwiftUI

struct SelectDateView: View {
    @Binding var selectedDate: Date
    var body: some View {
        DatePicker("Select Date",
                   selection: $selectedDate,
                   in: Date()...
        )
    }
}