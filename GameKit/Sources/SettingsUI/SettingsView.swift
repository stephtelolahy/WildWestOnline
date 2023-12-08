//
//  SettingsView.swift
//
//
//  Created by Hugues Telolahy on 08/12/2023.
//
// swiftlint:disable no_magic_numbers

import Redux
import Routing
import SwiftUI
import Theme

public struct SettingsView: View {
    @State var isDarkModeEnabled = true
    @State var downloadViaWifiEnabled = false

    public var body: some View {
        NavigationView {
            Form {
                headerView
                contentSection
                preferencesSection
            }
            .navigationBarTitle("Settings")
        }
    }

    private var headerView: some View {
        VStack {
            Image(systemName: "person.crop.circle")
                .resizable()
                .frame(width: 100, height: 100, alignment: .center)
            Text("Wolf Knight")
                .font(.title)
            Text("WolfKnight@kingdom.tv")
                .font(.subheadline)
                .foregroundColor(.gray)
            Spacer()
            Button(action: {
                print("Edit Profile tapped")
            }, label: {
                Text("Sign out")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.white, lineWidth: 2)
                    )
            })
            .background(Color.blue)
            .cornerRadius(25)
        }
        .padding()
    }

    private var contentSection: some View {
        Section(header: Text("CONTENT")) {
            HStack {
                Image(systemName: "star")
                Text("Favorites")
            }

            HStack {
                Image(systemName: "arrow.down.circle")
                Text("Downloads")
            }
        }
    }

    private var preferencesSection: some View {
        Section(header: Text("PREFRENCES")) {
            HStack {
                Image(systemName: "globe")
                Text("Language")
            }
            HStack {
                Image(systemName: "circle.lefthalf.striped.horizontal.inverse")
                Toggle(isOn: $isDarkModeEnabled) {
                    Text("Dark Mode")
                }
            }
            HStack {
                Image(systemName: "wifi.circle")
                Toggle(isOn: $downloadViaWifiEnabled) {
                    Text("Only Download via Wi-Fi")
                }
            }
            HStack {
                Image(systemName: "play.circle")
                Text("Play in Background")
            }
        }
    }
}

#Preview {
    SettingsView()
}
