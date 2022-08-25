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
                    case .mainView:
                        DashboardView()
                            .environmentObject(store)

                    case .movieDetail(let movie):
                        MovieDetailView(movieID: movie.id)
                            .environmentObject(store)
                            .navigationTitle(movie.title)

                    case .movieReviews(let movie):
                        MovieReviewsView(movieID: movie.id)
                            .environmentObject(store)
                            .navigationTitle(movie.title)
                    }
                }
        }
        .onAppear {
            store.dispatch(.launch)
        }
    }
}

struct AppContainerView_Previews: PreviewProvider {
    static var previews: some View {
        AppContainerView()
    }
}
