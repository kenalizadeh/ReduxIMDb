//
//  Middleware.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 11.09.22.
//

import Foundation
import Combine

public typealias Middleware<State> = (@escaping ActionDispatch, State, Action) -> AnyPublisher<Action, Never>
