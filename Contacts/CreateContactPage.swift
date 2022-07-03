//
//  CreateContactPage.swift
//  Contacts
//
//  Created by Rosario Galioto on 02/07/22.
//

import SwiftUI

struct CreateContactPage: View {
    @ObservedObject var model:Model

    @State var name: String = ""
    @State var surname: String = ""
    @State var cellular: String = ""
    @State var email: String = ""
    @State var photo: String? = nil
    @State var favorite: Bool = false
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            Text("Create Contact").font(Font.title2).padding(15)
            Form {
                HStack {
                    Spacer()
                    Image("placeholder_pic").resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(60.0).frame(width: 100, height: 100, alignment: .top)
                    .padding(.vertical, 20)
                    Spacer()
                }
                
                TextField("Name", text: $name)
                TextField("Surname", text: $surname)
                TextField("Cellular", text: $cellular).keyboardType(.phonePad)
                TextField("Email", text: $email).keyboardType(.emailAddress)
                
                HStack {
                    Spacer()
                    Button {
                        favorite = !favorite
                    }
                    label: {
                    Image(systemName: favorite ? "star.fill" : "star" ).foregroundColor(Color.yellow)
                        .font(Font.custom("setFavorite", size: 35))
                    }
                    Spacer()
                }.padding(.vertical, 20)
                
                HStack {
                    Spacer()
                    Button {
                        model.addPerson(person: Person(name: name, surname: surname, cellular: cellular, email: email, favorite: favorite))
                        dismiss()
                    }
                    label: {
                        Text("Create Contact")
                    }
                    Spacer()
                }.padding(.vertical, 30)
                
            }
        }
    }
}

struct CreateContactPage_Previews: PreviewProvider {
    static var previews: some View {
        let model = Model()
        model.mockInit()
        return CreateContactPage(model: model)
    }
}
