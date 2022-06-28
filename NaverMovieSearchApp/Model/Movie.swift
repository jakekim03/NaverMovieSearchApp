//
//  Movie.swift
//  NaverMovieSearchApp
//
//  Created by 김용민 on 2022/06/13.
//

import Foundation


struct Movie{
    
    var movieTitle: String?
    var movieDirector: String?
    var movieActor: String?
    var movieImg: String?
    
}


// MARK: - Welcome
struct MovieData: Codable {
    let lastBuildDate: String
    let total, start, display: Int
    let items: [Item]
}

// MARK: - Item
struct Item: Codable {
    let title: String
    let link: String
    let image: String
    let subtitle, pubDate, director, actor: String
    let userRating: String
}

