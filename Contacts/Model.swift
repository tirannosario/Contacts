//
//  Model.swift
//  Contacts
//
//  Created by Rosario Galioto on 01/07/22.
//

import Foundation

class Person: Identifiable, ObservableObject, Equatable, Decodable, CustomStringConvertible {
    
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
    
    enum CodingKeys: String, CodingKey {
        case name
        case surname
        case cellular
        case email
        case photo
        case favorite
    }
    
    // init(decoder) e encode(encoder), sono metodi necessari per far si che la classe sia sia Observable che Decodable
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        name = try values.decode(String.self, forKey: .name)
        surname = try values.decode(String.self, forKey: .surname)
        cellular = try values.decode(String.self, forKey: .cellular)
        email = try values.decode(String.self, forKey: .email)
        photo = try values.decode(String.self, forKey: .photo)
        favorite = try values.decode(Bool.self, forKey: .favorite)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(surname, forKey: .surname)
        try container.encode(cellular, forKey: .cellular)
        try container.encode(email, forKey: .email)
        try container.encode(photo, forKey: .photo)
        try container.encode(favorite, forKey: .favorite)

    }
    
    static func == (lhs: Person, rhs: Person) -> Bool {
        return lhs.id == rhs.id
    }
    
    func setFavorite(favorite: Bool){
        self.favorite = favorite
        print("\(name) favorite: \(favorite)")
    }
    
    var description: String { return "\(self.name) \(self.surname) - \(self.cellular) - \(self.email) - \(self.favorite) - \(self.photo ?? "")"}
}

class Model: ObservableObject {
    @Published var contacts: [Person] = []
    
    init () {
        contacts.append(Person(name: "Mario", surname: "Rossi", cellular: "3315674326", email: "mariorossi@gmail.com", photo: nil, favorite: false))
        contacts.append(Person(name: "Luca", surname: "Verdi", cellular: "3214567892", email: "verdone@gmail.com", photo: nil, favorite: true))
        contacts.append(Person(name: "Elon", surname: "Musk", cellular: "3459876547", email: "tothemoon@gmail.com", photo: nil, favorite: true))
    }
    
    func addContacts(contacts: [Person]) {
        for contact in contacts {
            addPerson(person: contact)
        }
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
    
    func addPerson(person: Person) {
        contacts.append(person)
    }
    
    func popolateFromJSONAPI(isFetching: inout Bool) {
        let apiEndpoint = "https://my-json-server.typicode.com/tirannosario/demo/contacts"
        guard let url = URL(string: apiEndpoint) else {
            print("bad URL")
            return
        }
        
        if let data = try? Data(contentsOf: url) {
            do {
                // Parse the JSON data
                let fetchedContacts = try JSONDecoder().decode([Person].self, from: data)
                addContacts(contacts: fetchedContacts)
                isFetching = false
            } catch {
                print(error)
            }
        }
    }
}
