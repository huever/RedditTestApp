//
//  Networking.swift
//  redditTest
//
//  Created by luciano on 04/06/2018.
//  Copyright © 2018 huevo. All rights reserved.
//

import Foundation

class Networking {
    
    func getTopPost(taskCallback: @escaping ([Article]) -> ())  {
        let redditUrl = URL(string: "https://www.reddit.com/r/popular/top.json")
        
        URLSession.shared.dataTask(with: redditUrl!) { (data, response
            , error) in

            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let redditData = try decoder.decode(RedditBase.self, from: data)
                let data = redditData.data.children
                
                taskCallback(data)
            } catch let err {
                print("Err", err)
                taskCallback([])
            }
            }.resume()
    }
}
