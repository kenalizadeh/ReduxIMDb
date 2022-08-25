//
//  AppContainerView.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 14.08.22.
//

import SwiftUI

struct AppContainerView: View {
    // For data that should be shared with many views in your app, SwiftUI gives us the @EnvironmentObject property wrapper. This lets us share model data anywhere it’s needed, while also ensuring that our views automatically stay updated when that data changes.
    // Think of @EnvironmentObject as a smarter, simpler way of using @ObservedObject on lots of views. Rather than creating some data in view A, then passing it to view B, then view C, then view D before finally using it, you can create it in view A and put it into the environment so that views B, C, and D will automatically have access to it
    // Ref: https://www.hackingwithswift.com/quick-start/swiftui/how-to-use-environmentobject-to-share-data-between-views
    @EnvironmentObject var store: ISDStore

    var body: some View {
        NavigationStack {
            DashboardView()
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .mainView:
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
            store.dispatch(.launch)
        }
    }
}

struct AppContainerView_Previews: PreviewProvider {
    static var previews: some View {
        AppContainerView()
    }
}
