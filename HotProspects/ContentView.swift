//
//  ContentView.swift
//  HotProspects
//
//  Created by slava bily on 2/6/20.
//  Copyright © 2020 slava bily. All rights reserved.
//

import SwiftUI
 
struct ContentView: View {
    

    var body: some View {
        Image("example")
            .interpolation(.none)
            .resizable()
            .scaledToFit()
            .frame(maxHeight: .infinity)
            .background(Color.black)
            .edgesIgnoringSafeArea(.all)
        
    }
    
    
         
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
