//
//  ContentView.swift
//  Shared
//
//  Created by Yan on 2020/12/11.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var profileManager: ProfilesManager
    var body: some View {
        List(profileManager.profiles, id: \.self) { profile in
            Cell(profile: profile) {
                profileManager.delete(profile: profile)
            }
        }
    }
}

struct Cell: View {
    var profile: ProvisioningProfile
    var delectAction: () -> ()
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(profile.bundleIdentifier).padding(.top, 10)
                    Text(profile.teamName)
                        .padding(.bottom, 10)
                }
                Spacer()
                Button(action: delectAction){
                    Text("Delete")
                }.foregroundColor(Color(.red))
            }
            Color.gray
                .frame(height: 1)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
