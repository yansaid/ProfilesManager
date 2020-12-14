//
//  ProfilesApp.swift
//  Shared
//
//  Created by Yan on 2020/12/11.
//

import SwiftUI

@main
struct ProfilesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(ProfilesManager())
        }
    }
}
