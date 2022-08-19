//
//  SearchView.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 14.08.22.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var store: ISDStore

    var body: some View {
        //        if case let .searching(searchQuery) = store.state.search {
        //            Text(searchQuery)
        //        }
        Grid {
            ForEach(1...10, id: \.self) { id in
                if id % 3 < 3 {
                    GridRow {
                        Text(String(id % 3))
                    }
                }
            }
        }
        .padding(.vertical, 150)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
