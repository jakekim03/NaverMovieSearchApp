//
//  Networking.swift
//  NaverMovieSearchApp
//
//  Created by 김용민 on 2022/06/13.
//

import Foundation


final class NetworkingManager{
    
    static let shared = NetworkingManager()
    
    private init() {}
    
    
    func requestAPIToNaver(_ queryValue: String, completion: @escaping ([Movie]?) -> Void) {

        let clientID: String = "mJF0gjV9Up4R2e_Iyhw3"
        let clientKEY: String = "8HAimP4qdr"

        let query: String  = "https://openapi.naver.com/v1/search/movie.json?query=\(queryValue)"
        let encodedQuery: String = query.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        let queryURL: URL = URL(string: encodedQuery)!

        var requestURL = URLRequest(url: queryURL)
        requestURL.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        requestURL.addValue(clientID, forHTTPHeaderField: "X-Naver-Client-Id")
        requestURL.addValue(clientKEY, forHTTPHeaderField: "X-Naver-Client-Secret")

        let task = URLSession.shared.dataTask(with: requestURL) { [self] data, response, error in
            guard error == nil else { print(error); return }
            guard let data = data else { print(error); return }

            var movieArray = self.parseJSON(data)
            
            completion(movieArray)
         

        }
        task.resume()
    }

    
    func parseJSON(_ movieData: Data) -> [Movie]? {
        // 함수실행 확인 코드
        print(#function)
        
        let decoder = JSONDecoder()
        
        do {
            
            
            let decodedData = try decoder.decode(MovieData.self, from: movieData)
        
            let itemLists = decodedData.items
            
            let myMovielists = itemLists.map {
                Movie(movieTitle: $0.title, movieDirector: $0.director, movieActor: $0.actor, movieImg: $0.image)
                
            }
            return myMovielists
            
        } catch {
            //print(error.localizedDescription)
            
            // (파싱 실패 에러)
            print("파싱 실패")
            
            return nil
        }
        
    }
}

extension String {
    // html 태그 제거 + html entity들 디코딩.
    var htmlEscaped: String {
        guard let encodedData = self.data(using: .utf8) else {
            return self
        }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        do {
            let attributed = try NSAttributedString(data: encodedData,
                                                    options: options,
                                                    documentAttributes: nil)
            return attributed.string
        } catch {
            return self
        }
    }
}
