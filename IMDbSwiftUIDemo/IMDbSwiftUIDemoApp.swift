//
//  IMDbSwiftUIDemoApp.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 14.08.22.
//

import SwiftUI

@main
struct IMDbSwiftUIDemoApp: App {
    @StateObject
    var store = ISDStore(
        initial: ISDAppState(),
        reducer: rootReducer,
        middlewares: [
            loggerMiddleware,
            searchMiddleware,
            mostPopularMoviesThunk,
            movieDetailThunk,
            recentlyViewedMoviesThunk,
            searchMoviesThunk,
            movieReviewsThunk
        ]
    )

    var body: some Scene {
        WindowGroup {
            AppContainerView()
                .environmentObject(store)
        }
    }
}
