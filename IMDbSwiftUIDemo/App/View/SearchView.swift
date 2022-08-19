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
        if case let .searching(searchQuery) = store.state.search {
            Text(searchQuery)
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
