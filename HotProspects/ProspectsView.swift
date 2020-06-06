//
//  ProspectsView.swift
//  HotProspects
//
//  Created by slava bily on 5/6/20.
//  Copyright © 2020 slava bily. All rights reserved.
//

import SwiftUI

struct ProspectsView: View {
    
    enum FilterType {
        case none, contacted, uncontacted
    }
    
    let filter: FilterType
    
    var title: String {
        switch filter {
        case .none:
            return "Everyone"
        case .contacted:
            return "Contacted People"
        case .uncontacted:
            return "Uncontacted People"
        }
    }
    
    var body: some View {
        NavigationView {
            Text("Hello, World!")
            .navigationBarTitle(title)
        }
     }
}

struct ProspectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectsView(filter: .none)
    }
}
