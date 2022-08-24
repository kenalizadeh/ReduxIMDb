//
//  IMDbSwiftUIDemoApp.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 14.08.22.
//

import SwiftUI

@main
struct IMDbSwiftUIDemoApp: App {
    let store = ISDStore(
        initial: ISDAppState(),
        reducer: isdReducer,
        middlewares: [
            searchMiddleware
        ],
        thunks: [
            recentlyViewedMoviesThunk,
            mostPopularMoviesThunk,
            searchMoviesThunk
        ]
    )

    var body: some Scene {
        WindowGroup {
            AppContainerView()
                .environmentObject(store)
        }
    }
}
