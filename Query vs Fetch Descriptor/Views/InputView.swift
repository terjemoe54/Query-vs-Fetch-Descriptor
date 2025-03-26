//
//  InputView.swift
//  Query vs Fetch Descriptor
//
//  Created by Terje Moe on 23/03/2025.
//

import SwiftUI

struct InputView: View {
    @Binding var newTitle: String
    let action: () -> Void
    
    var body: some View {
        // Text Field
        HStack {
            TextField("New Todo", text: $newTitle)
                .textFieldStyle(.roundedBorder)
            Button {
                action()
            } label: {
                Text("Add")
                    .padding()
                    .background(.blue)
                    .clipShape(.rect(cornerRadius: 10))
                    .foregroundStyle(.white)
            }
        }
    }
}
