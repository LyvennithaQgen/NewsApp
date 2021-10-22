//
//  NetworkLayer.swift
//  NewsApp
//
//  Created by Lyvennitha on 22/10/21.
//

import Foundation

enum NetworkConstants: String{
    case baseURL = "https://newsapi.org/v2/top-headlines?country=us&apiKey=8c2305596dac4935b7df4aa12e7a5477"
}

class NetworkLayer{
    
    func getNew<T: Codable>(success: @escaping (T) -> (), onError: @escaping(Error) -> ()){
        var urlRequest = URLRequest(url: URL(string: NetworkConstants.baseURL.rawValue)!)
        urlRequest.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: urlRequest){(data, response, error) in
            
            do {
                let res = try JSONDecoder().decode(T.self, from: data!)
                success(res)
            } catch {
                print(error)
                onError(error)
            }
           
        }.resume()
        
    }
    
}
