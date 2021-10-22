//
//  NewListsAPI.swift
//  NewsApp
//
//  Created by Lyvennitha on 22/10/21.
//

import Foundation

struct NewListsAPI {
    let networkLayer = NetworkLayer()
    
    func getLatestNews(success: @escaping (NewsResponse) -> (), onError: @escaping(Error) -> ()){
        networkLayer.getNew(success: success, onError: onError)
    }
    
}



// MARK: - NewsResponse
class NewsResponse: Codable {
    var status: String?
    var totalResults: Int?
    var articles: [Article]?

    init(status: String?, totalResults: Int?, articles: [Article]?) {
        self.status = status
        self.totalResults = totalResults
        self.articles = articles
    }
}

// MARK: - Article
class Article: Codable {
    var source: Source?
    var author: String?
    var title: String?
    var articleDescription: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
    var content: String?

    enum CodingKeys: String, CodingKey {
        case source, author, title
        case articleDescription = "description"
        case url, urlToImage, publishedAt, content
    }

    init(source: Source?, author: String?, title: String?, articleDescription: String?, url: String?, urlToImage: String?, publishedAt: String?, content: String?) {
        self.source = source
        self.author = author
        self.title = title
        self.articleDescription = articleDescription
        self.url = url
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
        self.content = content
    }
}

// MARK: - Source
class Source: Codable {
    var id: String?
    var name: String?

    init(id: String?, name: String?) {
        self.id = id
        self.name = name
    }
}
