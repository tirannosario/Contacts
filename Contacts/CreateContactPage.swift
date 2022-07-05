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
    
    @State private var image: UIImage? = UIImage(named:"placeholder_pic")
    @State private var shouldPresentImagePicker = false
    @State private var shouldPresentActionScheet = false
    @State private var shouldPresentCamera = false
    
    var body: some View {
        VStack {
            Text("Create Contact").font(Font.title2).padding(15)
            Form {
                HStack {
                    Spacer()
                    Image(uiImage: image!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100, alignment: .top)
                        .cornerRadius(60.0).frame(width: 100, height: 100, alignment: .top)
                        .padding(.vertical, 20)
                        .onTapGesture { self.shouldPresentActionScheet = true }
                        .sheet(isPresented: $shouldPresentImagePicker) {
                            SUImagePickerView(sourceType: self.shouldPresentCamera ? .camera : .photoLibrary, image: self.$image, isPresented: self.$shouldPresentImagePicker)
                    }.actionSheet(isPresented: $shouldPresentActionScheet) {
                        ActionSheet(title: Text("Choose mode"),
                            message: Text("Please choose your preferred mode to set your profile image"),
                            buttons: [
                                ActionSheet.Button.default(Text("Camera"),
                                   action: {
                                       self.shouldPresentImagePicker = true
                                       self.shouldPresentCamera = true
                                   }),
                                ActionSheet.Button.default(Text("Photo Library"),
                                    action: {
                                        self.shouldPresentImagePicker = true
                                        self.shouldPresentCamera = false
                                    }),
                                ActionSheet.Button.cancel()
                            ])
                    }
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
                        let isSaved = Model.saveImage(name: name, surname: surname, image: image!)
                        let path = "\(name)-\(surname).png"
                        model.addPerson(person: Person(name: name, surname: surname, cellular: cellular, email: email,onlinePic: false, photo: path, favorite: favorite))
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
