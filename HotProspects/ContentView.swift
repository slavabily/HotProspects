//
//  ContentView.swift
//  HotProspects
//
//  Created by slava bily on 2/6/20.
//  Copyright © 2020 slava bily. All rights reserved.
//

import SwiftUI
 
struct ContentView: View {
    @State private var backgroundColor = Color.red

    var body: some View {
        VStack {
            Text("Hello, World!")
            .padding()
            .background(backgroundColor)
            
            Text("Chamge Color")
                .padding()
                .contextMenu {
                    Button(action: {
                        self.backgroundColor = .red
                    }) {
                        Text("Red")
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.red)
                    }
                    
                    Button(action: {
                        self.backgroundColor = .green
                    }) {
                        Text("Green")
                    }
                    
                    Button(action: {
                        self.backgroundColor = .blue
                    }) {
                        Text("Blue")
                    }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
