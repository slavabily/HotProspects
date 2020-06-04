//
//  ContentView.swift
//  HotProspects
//
//  Created by slava bily on 2/6/20.
//  Copyright © 2020 slava bily. All rights reserved.
//

import SwiftUI

enum NetworkError: Error {
    case badURL, requestFailed, unknown
}
 
struct ContentView: View {

    var body: some View {
        Text("Hello, World!")
            .onAppear {
                self.fetchData(from: "https://www.apple.com") { (result) in
                    switch result {
                    case .success(let str):
                        print(str)
                    case .failure(let error):
                        switch error {
                        case .badURL:
                            print("BadURL")
                        case .requestFailed:
                            print("Network problems")
                        case .unknown:
                            print("Unknown error")
                        }
                    }
                }
            }
    }
    
    func fetchData(from urlString: String, completion: @escaping (Result<String, NetworkError>) -> Void) {
        // check the URL is OK, otherwize return with a failure
        guard let url = URL(string: "https://www.apple.com") else {
            completion(.failure(.badURL))
            return
        }
        URLSession.shared.dataTask(with: url) { data, responce, error in
            // the task is completed - push our work to the main thread
            DispatchQueue.main.async {
                if let data = data {
                    // success: convert the data to a string and send it back
                    let stringData = String(decoding: data, as: UTF8.self)
                    completion(.success(stringData))
                } else if error != nil {
                    // any sort of network failure
                    completion(.failure(.requestFailed))
                } else {
                    // this ought not to be possible, yet here we are
                    completion(.failure(.unknown))
                }
            }
        }
        .resume()
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
