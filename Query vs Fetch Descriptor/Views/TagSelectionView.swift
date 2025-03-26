//
//  TagSelectionView.swift
//  Query vs Fetch Descriptor
//
//  Created by Terje Moe on 23/03/2025.
//

import SwiftUI

struct TagSelectionView: View {
    let action: (_ tag: Tag) -> Void
    let selectedTags: Set<Tag>
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(Tag.allCases, id: \.self) { tag in
                    Button {
                        action(tag)
                    } label: {
                        Text(tag.rawValue.capitalized)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(selectedTags.contains(tag) ? tag.color.opacity(0.8) : .gray.opacity(0.3))
                            .foregroundStyle(.white)
                            .clipShape(Capsule())
                    }
                    
                }
            }
        }.scrollIndicators(.hidden)
    }
}
