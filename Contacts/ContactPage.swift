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
                    if let picUser = person.photo {
                        AsyncImage(url: URL(string: picUser)) {
                            phase in
                                switch phase {
                                case .empty:
                                    showDefaultPic()
                                case .success(let image):
                                    image.resizable()
                                         .aspectRatio(contentMode: .fit)
                                         .cornerRadius(60.0)
                                         .frame(width: 100, height: 100, alignment: .top)
                                         .padding(.vertical, 20)
                                case .failure:
                                    showDefaultPic()
                                @unknown default:
                                    // Since the AsyncImagePhase enum isn't frozen,
                                    // we need to add this currently unused fallback
                                    // to handle any new cases that might be added
                                    // in the future:
                                    EmptyView()
                                }
                        }
                    }
                    else {
                        showDefaultPic()
                    }
                    
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
                    Link(person.cellular, destination: URL(string: "tel:\(person.cellular)")!)
                }
                HStack {
                    Text("Email:").foregroundColor(Color.gray)
                    Link(person.email, destination: URL(string: "mailto:\(person.email)")!)
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
        let model = Model()
        model.mockInit()
        return ContactPage(model: model, person: model.contacts[0])
    }
}


func showDefaultPic() -> some View {
    return Image("placeholder_pic").resizable()
    .aspectRatio(contentMode: .fit)
    .cornerRadius(60.0).frame(width: 100, height: 100, alignment: .top)
    .padding(.vertical, 20)
}
