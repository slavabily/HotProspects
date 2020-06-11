//
//  Prospect.swift
//  HotProspects
//
//  Created by slava bily on 6/6/20.
//  Copyright © 2020 slava bily. All rights reserved.
//

import SwiftUI

class Prospect: Identifiable, Codable, Equatable {
    
    let id = UUID()
    var name = "Anonymous"
    var emailAddress = ""
    var dateAdded = Date()
    fileprivate(set) var isContacted = false
    
    static func == (lhs: Prospect, rhs: Prospect) -> Bool {
        lhs.isContacted == rhs.isContacted
    }
}

class Prospects: ObservableObject {
    @Published private(set) var people: [Prospect]
    
    static let savedFileName = "Saved"
    
    init() {
        func getDocumentsDirectory() -> URL {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            return paths[0]
        }
        
        let fileName = getDocumentsDirectory().appendingPathComponent(Self.savedFileName)
        do {
            let data = try Data(contentsOf: fileName)
            if let decoded = try? JSONDecoder().decode([Prospect].self, from: data) {
                self.people = decoded
                return
            }
        } catch {
            print(error.localizedDescription)
        }
        self.people = []
    }
    
    private func save() {
        func getDocumentsDirectory() -> URL {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            return paths[0]
        }
        
        let fileName = getDocumentsDirectory().appendingPathComponent(Self.savedFileName)
        
        do {
            let encoded = try JSONEncoder().encode(people)
            try encoded.write(to: fileName, options: [.atomicWrite, .completeFileProtection])
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func toggle(_ prospect: Prospect) {
        objectWillChange.send()
        prospect.isContacted.toggle()
        save()
    }
    
    func add(_ prospect: Prospect) {
        people.append(prospect)
        save()
    }
}
