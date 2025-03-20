//
//  ContentView.swift
//  Query vs Fetch Descriptor
//
//  Created by Terje Moe on 20/03/2025.
//

import SwiftUI
import SwiftData

struct TodoListView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query(sort: [SortDescriptor(\TodoModel.date)]) var dateTodos: [TodoModel]
    @Query(sort: [SortDescriptor(\TodoModel.title)]) var titleTodos: [TodoModel]
    
    @State private var newTitle: String = ""
    @State private var selectedSortOption: SortOption = .byTitle
    @State private var selectedDate: Date = Date()
    
    enum SortOption: String, CaseIterable {
        case byTitle = "By Title"
        case byDate = "By Date"
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack  {
                    // Text Field
                    HStack {
                        TextField("New Todo", text: $newTitle)
                            .textFieldStyle(.roundedBorder)
                        Button {
                            
                        } label: {
                            Text("Add")
                                .padding()
                                .background(.blue)
                                .clipShape(.rect(cornerRadius: 10))
                                .foregroundStyle(.white)
                        }

                    }
                   // Date Picker
                    DatePicker("Select Date",
                               selection: $selectedDate,
                               in: Date()...
                    )
                   // Segmented picker
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
                .padding()
                // List
                Spacer()
            }
            .navigationTitle("Todoes")
        }
    }
    
    private var sortedTodoes: [TodoModel] {
        switch selectedSortOption {
        case .byTitle:
            return titleTodos
        case .byDate:
            return dateTodos
        }
    }
    
    private func addTodoes() {
        
    }
    
    private func deleteTodo(_ todo: TodoModel) {
        
    }
}

#Preview {
    TodoListView()
        .modelContainer(for: TodoModel.self)
}
