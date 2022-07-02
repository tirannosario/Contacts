//
//  Model.swift
//  Contacts
//
//  Created by Rosario Galioto on 01/07/22.
//

import Foundation

class Person: Identifiable, ObservableObject, Equatable {
    
    var id = UUID()
    @Published var name: String
    @Published var surname: String
    @Published var cellular: String
    @Published var email: String
    @Published var photo: String?
    @Published var favorite: Bool
    
    init(id: UUID = UUID(), name: String, surname: String, cellular: String, email: String, photo: String? = nil, favorite: Bool) {
        self.id = id
        self.name = name
        self.surname = surname
        self.cellular = cellular
        self.email = email
        self.photo = photo
        self.favorite = favorite
    }
    
    static func == (lhs: Person, rhs: Person) -> Bool {
        return lhs.id == rhs.id
    }
    
    func setFavorite(favorite: Bool){
        self.favorite = favorite
        print("\(name) favorite: \(favorite)")
    }
}

class Model: ObservableObject {
    @Published var contacts: [Person] = []
    
    init () {
        contacts.append(Person(name: "Mario", surname: "Rossi", cellular: "3315674326", email: "mariorossi@gmail.com", photo: nil, favorite: false))
        contacts.append(Person(name: "Luca", surname: "Verdi", cellular: "3214567892", email: "verdone@gmail.com", photo: nil, favorite: true))
        contacts.append(Person(name: "Elon", surname: "Musk", cellular: "3459876547", email: "tothemoon@gmail.com", photo: nil, favorite: true))
    }
    
    func getPerson(findId: UUID)-> Person? {
        if let person = contacts.first(where: {$0.id == findId}) {
            return person
        }
        return nil
    }
    
    func deletePerson(findId: UUID) {
        if let person = contacts.first(where: {$0.id == findId}) {
            if let index = contacts.firstIndex(of: person) {
                contacts.remove(at: index)
            }
        }
    }
}
