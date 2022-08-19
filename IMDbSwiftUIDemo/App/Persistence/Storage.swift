//
//  Storage.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 14.08.22.
//

import Foundation

//class Storage: ObservableObject {
//    private init() {
//        accessToken = UserDefaults.standard.string(forKey: NetworkConstants.accessToken)
//        refreshToken = UserDefaults.standard.string(forKey: NetworkConstants.refreshToken)
//        isUserLoggedIn = UserDefaults.standard.bool(forKey: "\(Self.self).isUserLoggedIn")
//    }
//
//    static let shared = Storage()
//
//    @Published
//    var accessToken: String? {
//        didSet {
//            UserDefaults.standard.set(accessToken, forKey: NetworkConstants.accessToken)
//        }
//    }
//
//    @Published
//    var refreshToken: String? {
//        didSet {
//            UserDefaults.standard.set(refreshToken, forKey: NetworkConstants.refreshToken)
//        }
//    }
//
//    @Published
//    var isUserLoggedIn: Bool {
//        didSet {
//            UserDefaults.standard.set(isUserLoggedIn, forKey: "\(Self.self).isUserLoggedIn")
//        }
//    }
//}
