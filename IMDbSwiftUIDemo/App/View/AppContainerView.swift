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
        NavigationView {
            DashboardView()
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
