//
//  ContactPage.swift
//  Contacts
//
//  Created by Rosario Galioto on 01/07/22.
//

import SwiftUI

struct ContactPage: View {
    @ObservedObject var model:Model
    @ObservedObject var person:Person
    
    var body: some View {
        VStack {
            List {
                HStack {
                    Spacer()
                    Image("abbey_road_beatles").resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(60.0).frame(width: 100, height: 100, alignment: .top)
                    .padding(.vertical, 20)
                    Spacer()
                }
                HStack {
                    Text("Name:").foregroundColor(Color.gray)
                    Text(person.name)
                }
                HStack {
                    Text("Surname:").foregroundColor(Color.gray)
                    Text(person.surname)
                }
                HStack {
                    Text("Cellular:").foregroundColor(Color.gray)
                    Text(person.cellular)
                }
                HStack {
                    Text("Email:").foregroundColor(Color.gray)
                    Text(person.email)
                }
                HStack {
                    Spacer()
                    Button {
                        person.favorite = !person.favorite
                    }
                    label: {
                    Image(systemName: person.favorite ? "star.fill" : "star" ).foregroundColor(Color.yellow)
                        .font(Font.custom("setFavorite", size: 35))
                    }
                    Spacer()
                }.padding(.vertical, 20)
                HStack {
                    Spacer()
                    Button {
                        model.deletePerson(findId: person.id)
                    }label: {
                        Text("Delete Contact").foregroundColor(Color.red)
                    }
                    Spacer()
                }.padding(.vertical, 30)
            }
        }
        .navigationTitle("Contact Detail")
    }
}

struct ContactPage_Previews: PreviewProvider {
    static var previews: some View {
        ContactPage(model: Model(), person: Model().contacts[0])
    }
}
