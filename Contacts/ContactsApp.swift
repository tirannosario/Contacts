//
//  ContactsApp.swift
//  Contacts
//
//  Created by Rosario Galioto on 01/07/22.
//

import SwiftUI

@main
struct ContactsApp: App {
    var model = Model()
    var body: some Scene {
        WindowGroup {
            ContentView(model: model)
        }
    }
}
