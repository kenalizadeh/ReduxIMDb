//
//  Storage.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 14.08.22.
//

import Foundation

class Storage: ObservableObject {
    private init() {
        accessToken = UserDefaults.standard.string(forKey: NetworkConstants.accessTokenStorageKey)
        refreshToken = UserDefaults.standard.string(forKey: NetworkConstants.refreshTokenStorageKey)
        isUserLoggedIn = UserDefaults.standard.bool(forKey: "\(Self.self).isUserLoggedIn")
    }

    static let shared = Storage()

    @Published
    var accessToken: String? {
        didSet {
            UserDefaults.standard.set(accessToken, forKey: NetworkConstants.accessTokenStorageKey)
        }
    }

    @Published
    var refreshToken: String? {
        didSet {
            UserDefaults.standard.set(refreshToken, forKey: NetworkConstants.refreshTokenStorageKey)
        }
    }

    @Published
    var isUserLoggedIn: Bool {
        didSet {
            UserDefaults.standard.set(isUserLoggedIn, forKey: "\(Self.self).isUserLoggedIn")
        }
    }
}
