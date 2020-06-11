//
//  ProspectsView.swift
//  HotProspects
//
//  Created by slava bily on 5/6/20.
//  Copyright © 2020 slava bily. All rights reserved.
//

import SwiftUI
import CodeScanner
import UserNotifications

struct ProspectsView: View {
    @EnvironmentObject var prospects: Prospects
    
    @State private var isShowingScanner = false
    @State private var showingActionSheet = false
    
    enum FilterType {
        case none, contacted, uncontacted
    }
    
    enum SortType {
        case none, byName, byDate
    }
    
    let filter: FilterType
    
    @State private var sorter: SortType = .none
    
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
    
    var filteredProspects: [Prospect] {
        switch filter {
        case .none:
            return prospects.people
        case .contacted:
            return prospects.people.filter {
                $0.isContacted
            }
        case .uncontacted:
            return prospects.people.filter {
                !$0.isContacted
            }
        }
    }
    
    var sortedProspects: [Prospect] {
        switch sorter {
        case .byDate:
            return filteredProspects.sorted {
                $0.dateAdded > $1.dateAdded
            }
        case .byName:
            return filteredProspects.sorted {
                $0.name < $1.name
            }
        case .none:
            return filteredProspects
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(sortedProspects) { prospect in
                    HStack {
                        VStack(alignment: .leading, content: {
                            Text(prospect.name)
                                .font(.headline)
                            Text(prospect.emailAddress)
                                .foregroundColor(.secondary)
                        })
                        Text(self.string(from: prospect.dateAdded))
                            .font(.footnote)
                        
                        if self.filteredProspects == self.prospects.people {
                            if prospect.isContacted {
                                Image(systemName: "checkmark.circle")
                            }
                        }
                    }
                    .contextMenu {
                            Button(prospect.isContacted ? "Mark Uncontacted" : "Mark Contacted") {
                                self.prospects.toggle(prospect)
                            }
                            if !prospect.isContacted {
                                Button("Remind Me") {
                                    self.addNotification(for: prospect)
                                }
                            }
                    }
                }
            }
            .navigationBarTitle(self.title)
            .navigationBarItems(leading: Button(action: {
                self.showingActionSheet = true
            }, label: {
                Text("Sort")
            }), trailing: Button(action: {
                self.isShowingScanner = true
            }, label: {
                Image(systemName: "qrcode.viewfinder")
                Text("Scan")
            }))
                .actionSheet(isPresented: $showingActionSheet, content: { () -> ActionSheet in
                    ActionSheet(title: Text("Sorting"), message: nil, buttons: [.default(Text("by Name"), action: {
                        self.sorter = .byName
                    }), .default(Text("by Date"), action: {
                        self.sorter = .byDate
                    })])
                })
                .sheet(isPresented: $isShowingScanner) {
                    CodeScannerView(codeTypes: [.qr], simulatedData: "Paul Hudson\npaul@hackingwithswift.com", completion: self.handlScan)
            }
        }
    }
    
    func handlScan(result: Result<String, CodeScannerView.ScanError>) {
        self.isShowingScanner = false
        
        switch result {
        case .success(let code):
            let details = code.components(separatedBy: "\n")
            guard details.count == 2 else { return }
            
            let person = Prospect()
            person.name = details[0]
            person.emailAddress = details[1]
            person.dateAdded = Date()
            
            self.prospects.add(person)
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
    }
    
    func string(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm E, d MMM y"
        
        return formatter.string(from: date)
    }
    
    func addNotification(for prospect: Prospect) {
        let center = UNUserNotificationCenter.current()
        
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.emailAddress
            content.sound = UNNotificationSound.default
            
            var dateComponents = DateComponents()
            dateComponents.hour = 9
//            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
            // for test purposes:
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }
        
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in
                    if success {
                        addRequest()
                    } else {
                        print("D'oh")
                    }
                }
            }
        }
    }
}

struct ProspectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectsView(filter: .none)
    }
}
