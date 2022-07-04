//
//  Model.swift
//  Contacts
//
//  Created by Rosario Galioto on 01/07/22.
//

import Foundation
import RealmSwift

class LocalPerson: Object {
    @objc dynamic var name: String?
    @objc dynamic var surname: String?
    @objc dynamic var cellular: String?
    @objc dynamic var email: String?
    @objc dynamic var photo: String?
    @objc dynamic var favorite: Bool = false
}

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
//        contacts.append(Person(name: "Mario", surname: "Rossi", cellular: "3315674326", email: "mariorossi@gmail.com", photo: nil, favorite: false))
//        contacts.append(Person(name: "Luca", surname: "Verdi", cellular: "3214567892", email: "verdone@gmail.com", photo: nil, favorite: true))
//        contacts.append(Person(name: "Elon", surname: "Musk", cellular: "3459876547", email: "tothemoon@gmail.com", photo: nil, favorite: true))
    }
    
    func mockInit () {
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
                deleteFromRealmDB(person: person)
            }
        }
    }
    
    func addPerson(person: Person) {
        contacts.append(person)
        saveToRealmDB(person: person)
    }
    
    func addPersonToModel(person: Person) {
        contacts.append(person)
    }
    
    func loadData(isFetching: inout Bool) {
        let localContacts = getContactsFromRealmDB()
        
        for localContact in localContacts {
            addPersonToModel(person: Person(name: localContact.name!, surname: localContact.surname!, cellular: localContact.cellular!, email: localContact.email!, photo: localContact.photo, favorite: localContact.favorite))
        }
        isFetching = false
    }
    
    func updateLocalWithRemote(isFetching: inout Bool) {
        var localContacts = getContactsFromRealmDB()
        let remoteContacts = getContactsFromJSONAPI()
        
        for remoteContact in remoteContacts {
            // se non abbiamo in locale il contatto remoto, lo aggiungiamo
            //TODO usare id o qualcosa di meglio
            if(localContacts.filter({$0.name == remoteContact.name && $0.surname == remoteContact.surname}).isEmpty) {
                saveToRealmDB(person: remoteContact)
            }
        }
        
        localContacts = getContactsFromRealmDB()
        self.contacts.removeAll()
        for localContact in localContacts {
            addPersonToModel(person: Person(name: localContact.name!, surname: localContact.surname!, cellular: localContact.cellular!, email: localContact.email!, photo: localContact.photo, favorite: localContact.favorite))
        }
        isFetching = false
    }
    
    func getPersonFromRealmDB(person: Person) -> LocalPerson? {
        let realm = try! Realm.init()
        let results = realm.objects(LocalPerson.self).filter({$0.name == person.name && $0.surname == person.surname})
        if(results.isEmpty) {
            return nil
        }
        else {
            let foundPerson = Array(results)[0]
            return foundPerson
        }
    }
    
    func saveToRealmDB(person: Person) {
        // salviamo nel db locale
        let realm = try! Realm.init()
        let userToSave = LocalPerson.init()
        userToSave.name = person.name
        userToSave.surname = person.surname
        userToSave.cellular = person.cellular
        userToSave.email = person.email
        userToSave.photo = person.photo
        userToSave.favorite = person.favorite
        try! realm.write({
            realm.add(userToSave)
        })
    }
    
    func deleteFromRealmDB(person: Person) {
        let realm = try! Realm.init()
        let personToDelete = getPersonFromRealmDB(person: person)
        if(personToDelete != nil) {
            try! realm.write({
                realm.delete(personToDelete!)
            })
        }
    }
    
    func getContactsFromJSONAPI() -> [Person] {
        let result = [Person]()
        
        let apiEndpoint = "https://my-json-server.typicode.com/tirannosario/demo/contacts"
        guard let url = URL(string: apiEndpoint) else {
            print("bad URL")
            return result
        }
        
        if let data = try? Data(contentsOf: url) {
            do {
                // Parse the JSON data
                let fetchedContacts = try JSONDecoder().decode([Person].self, from: data)
                return fetchedContacts
            } catch {
                print(error)
            }
        }
        return result
    }
    
    func getContactsFromRealmDB() -> [LocalPerson] {
        let realm = try! Realm.init()
        let results = realm.objects(LocalPerson.self)
        return Array(results)
    }
}
