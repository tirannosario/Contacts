//
//  ContentView.swift
//  Contacts
//
//  Created by Rosario Galioto on 01/07/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var model: Model
    @State private var filterFavorite = false
    @State private var isShowingCreatePage = false
    @State private var isFetching = true
    
    var filteredList: [Person] {
        model.contacts.filter {!filterFavorite || $0.favorite}.sorted(by: {$0.name < $1.name})
    }
    
    var body: some View {
        NavigationView {
            if(isFetching) {
                VStack {
                    ProgressView().onAppear(perform: {
                        DispatchQueue.main.async {
                            self.model.loadData(isFetching: &isFetching)
                        }
                    }
                    )
                }
            }
            else {
                VStack {
                    GeometryReader { geometry in
                        HStack() {
                            Button {
                                isShowingCreatePage = true
                            }
                            label: {
                                Image(systemName: "plus")
                            }
                            .font(Font.title)
                            .foregroundColor(Color.indigo)
                            .frame(width: geometry.size.width * 0.10)
                            
                            Spacer().frame(width: geometry.size.width * 0.50)
                            
                            Toggle(isOn: $filterFavorite) {Image(systemName: "star.fill").foregroundColor(Color.yellow)}
                                .frame(width: geometry.size.width * 0.20)
                            
                            Spacer().frame(width: geometry.size.width * 0.10)
                            
                            Button {
                                self.model.updateLocalWithRemote(isFetching: &isFetching)
                            }
                            label: {
                                Image(systemName: "icloud.and.arrow.down")
                            }
                            .font(Font.title)
                            .foregroundColor(Color.indigo)
                            .frame(width: geometry.size.width * 0.10)
                        }
                    }.frame(height: 30).padding(.horizontal, 25).padding(.vertical, 10)
                    
                    List(filteredList) {
                        person in ContactRow(model: model, person: person)
                    }
                }
                .navigationTitle("My Contacts")
                .sheet(isPresented: $isShowingCreatePage) { // per mostrare la pagina di creazione come Sheet
                    CreateContactPage(model: model)
                }
            }

        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let model = Model()
        model.mockInit()
        return ContentView(model: model)
    }
}
