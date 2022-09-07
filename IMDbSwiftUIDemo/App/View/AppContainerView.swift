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
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .dashboard:
                        DashboardView()

                    case .movieDetail(let movie):
                        MovieDetailView(movieID: movie.id)
                            .navigationTitle(movie.title)

                    case .movieReviews(let movie):
                        MovieReviewsView(movieID: movie.id)
                            .navigationTitle(movie.title)
                    }
                }
        }
        .onAppear {
            store.dispatch(ISDAction.launch)
        }
    }
}

struct AppContainerView_Previews: PreviewProvider {
    static var previews: some View {
        AppContainerView()
    }
}
