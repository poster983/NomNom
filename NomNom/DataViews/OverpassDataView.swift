//
//  OverpassDataView.swift
//  NomNom
//
//  Created by Joseph Hassell on 3/29/24.
//

import SwiftUI
import SwiftOverpassAPI

private struct TagKV {
//    var id: ObjectIdentifier = { .init(self)}()
    
    var key: String
    var value: String
}

struct OverpassDataView: View {
    var places: [OverpassData]
    var body: some View {
//        let asArray = {
//            return places.values.map({p in p})
//        }()
        
        ForEach(places, id: \.id) { place in
//            let p = { place.wrappedValue } ()
            let title = place.tags["name"] ?? "No name: \(place.id)"
            
            NavigationLink(destination: {
                Group {
                    List {
                        CopyableItem(title: "Name", text: title)
                        
                        Section(header: Text("Tags")) {
                            let tags: [TagKV] = place.tags.map({key, value in
                                return TagKV(key: key, value: value)
                            })
                            ForEach(tags, id: \.key) { kv in
                                CopyableItem(title: kv.key, text: kv.value)
                            }
                        }
                        
                        Section(header: Text("Open Street Map")) {
                            CopyableItem(title: "ID", text: String(place.id))
//                            CopyableItem(title: "ID", text: pla)
                            
                        }
                    }
                    
                    
                }
            }) {
                Text(title)
            }
        }
    }
}

//#Preview {
//    OverpassDataView(
//        .constant([
//            OPWay(id: 1, tags: ["peepee": "poopoo"], isInteresting: true, isSkippable: false, nodes: <#T##[Int]#>, geometry: <#T##OPGeometry#>, meta: <#T##OPMeta?#>)
//        ])
//    )
//}
