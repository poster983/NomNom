//
//  CopyableItem.swift
//  NomNom
//
//  Created by Joseph Hassell on 3/26/24.
//

import SwiftUI

struct CopyableItem: View {
    var title: String;
    var text: String?;
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
            if(text != nil) {
                Text(text!)
                    .font(.caption)
            }
        }.contextMenu {
            if(text != nil) {
                Button(action: {
                    #if !os(macOS)
                        UIPasteboard.general.string = text
                    #else
                    let pasteboard = NSPasteboard.general
                    pasteboard.clearContents()
                    pasteboard.setString(text!, forType: .string)
                    #endif
                    
                }) {
                    Text("Copy to clipboard")
                    Image(systemName: "doc.on.doc")
                }
            }
        }
    }
}

#Preview {
    CopyableItem(title: "Title", text: "Text")
}
