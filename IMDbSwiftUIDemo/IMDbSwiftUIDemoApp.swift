//
//  IMDbSwiftUIDemoApp.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 14.08.22.
//

import SwiftUI

@main
struct IMDbSwiftUIDemoApp: App {
    // SwiftUI’s @StateObject property wrapper is designed to fill a very specific gap in state management: when you need to create a reference type inside one of your views and make sure it stays alive for use in that view and others you share it with.
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
