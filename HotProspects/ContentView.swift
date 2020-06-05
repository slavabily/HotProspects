//
//  ContentView.swift
//  HotProspects
//
//  Created by slava bily on 2/6/20.
//  Copyright © 2020 slava bily. All rights reserved.
//

import SwiftUI
import UserNotifications
import SamplePackage
 
struct ContentView: View {
    let possibleNumbers = Array(1...60)
    
    var results: String {
        let selected = possibleNumbers.random(7).sorted()
        
        let strings = selected.map(String.init)
        return strings.joined(separator: ", ")
    }
 
    var body: some View {
        Text(results)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
