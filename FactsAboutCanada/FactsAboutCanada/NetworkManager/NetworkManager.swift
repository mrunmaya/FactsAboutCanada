//
//  NetworkManager.swift
//  FactsAboutCanada
//
//  Created by mrunmaya pradhan on 21/07/18.
//  Copyright © 2018 Self. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

fileprivate let URL_GET_DATA = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"

protocol NetWorkManagerProtocol {
    func fetchAllFacts(completion: @escaping ([Fact]?, String?) -> Void)
    func requestImage(path: String, completionHandler: @escaping (Image) -> Void)
}

class NetworkManager: NetWorkManagerProtocol {
    static let sharedInstance = NetworkManager()
    private var facts = [Fact]()
    
    func fetchAllFacts(completion: @escaping ([Fact]?, String?) -> Void) {
        Alamofire.request(URL_GET_DATA).responseString { responseData in
            if let data = responseData.result.value?.data(using: String.Encoding.utf8) {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject]
                    guard let jsonData = json else {return completion(nil, nil)}
                    let title:String? = jsonData["title"] as? String
                    var responseArray = [[String:AnyObject]]()
                    guard let resData = jsonData["rows"], let responseData = resData as? [[String:AnyObject]] else {return completion(nil,nil)}
                    responseArray = responseData
                    
                    for i in 0..<responseArray.count {
                        self.facts.append(Fact(
                            title: (responseArray[i] as AnyObject).value(forKey: "title") as? String,
                            description: (responseArray[i] as AnyObject).value(forKey: "description") as? String,
                            imageUrl: (responseArray[i] as AnyObject).value(forKey: "imageHref") as? String
                        ))
                    }
                    completion(self.facts, title)
                    
                }
                catch {}
            }
        }
    }
    
    func requestImage(path: String, completionHandler: @escaping (Image) -> Void){
        Alamofire.request("\(path)").responseImage(imageScale: 1.5, inflateResponseImage: false, completionHandler: {response in
            guard let image = response.result.value else {return}
            completionHandler(image)
        })
    }
    
}
