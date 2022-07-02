//
//  ContactRow.swift
//  Contacts
//
//  Created by Rosario Galioto on 01/07/22.
//

import SwiftUI

struct ContactRow: View {
    @ObservedObject var model:Model
    @ObservedObject var person:Person
    
    var body: some View {
        HStack {
            Text(person.name).bold()
            Text(person.surname).bold()
            if person.favorite {
                Image(systemName: "star.fill").foregroundColor(Color.yellow)
            }
            NavigationLink(destination: ContactPage(model: model, person: person)) {
                Text("")
            }
        }
    }
}

struct ContactRow_Previews: PreviewProvider {
    static var previews: some View {
        ContactRow(model: Model(), person: Model().contacts[1])
    }
}
