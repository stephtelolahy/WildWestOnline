//
//  SettingsView.swift
//
//
//  Created by Hugues Telolahy on 08/12/2023.
//
// swiftlint:disable no_magic_numbers type_contents_order

import Redux
import Routing
import SwiftUI
import Theme

public struct SettingsView: View {
    @State private var downloadViaWifiEnabled = false
    @StateObject private var store: Store<SettingsState>

    public init(store: @escaping () -> Store<SettingsState>) {
        // SwiftUI ensures that the following initialization uses the
        // closure only once during the lifetime of the view, so
        // later changes to the view's name input have no effect.
        _store = StateObject(wrappedValue: store())
    }

    public var body: some View {
        NavigationView {
            Form {
                headerView
                contentSection
                preferencesSection
            }
            .toolbar {
                Button("Done") {
                    withAnimation {
                        store.dispatch(NavAction.dismiss)
                    }
                }
            }
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
                Image(systemName: "gamecontroller")
                Stepper(
                    "Players count: \(store.state.playersCount)",
                    value: Binding<Int>(
                        get: { store.state.playersCount },
                        set: { store.dispatch(SettingsAction.updatePlayersCount($0)) }
                    ).animation(),
                    in: 2...8
                )
            }
            HStack {
                Image(systemName: "record.circle")
                Toggle(isOn: Binding<Bool>(
                    get: { store.state.simulation },
                    set: { _ in store.dispatch(SettingsAction.toggleSimulation) }
                ).animation()) {
                    Text("Simulation")
                }
            }
        }
    }
}

#Preview {
    SettingsView {
        Store<SettingsState>(
            initial: .init(
                playersCount: 5,
                simulation: false
            ),
            reducer: SettingsState.reducer
        )
    }
}