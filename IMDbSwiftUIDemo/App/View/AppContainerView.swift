//
//  AppContainerView.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 14.08.22.
//

import SwiftUI

struct AppContainerView: View {
    @EnvironmentObject var store: ISDStore

    var body: some View {
        NavigationStack {
        DashboardView()
                .environmentObject(store)
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .main:
                        DashboardView()
                            .environmentObject(store)

                    case .search(let searchText):
                        SearchView(.constant(searchText))
                            .environmentObject(store)

                    case .movieDetail(let movie):
                        MovieDetailView(movie: movie)
                            .environmentObject(store)
                    }
                }
        }
    }
}

struct AppContainerView_Previews: PreviewProvider {
    static var previews: some View {
        AppContainerView()
    }
}
