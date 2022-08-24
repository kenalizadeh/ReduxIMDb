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

                    case .movieDetail(let movieID):
                        MovieDetailView(movieID: movieID)
                            .environmentObject(store)

                    case .movieReviews(let movieID):
                        MovieReviewsView(movieID: movieID)
                            .environmentObject(store)
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
