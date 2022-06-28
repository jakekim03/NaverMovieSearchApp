//
//  ViewController.swift
//  NaverMovieSearchApp
//
//  Created by 김용민 on 2022/06/13.
//

import UIKit

class ViewController: UIViewController {
    
    
    let searchController = UISearchController()
    
    
    @IBOutlet weak var movieTableView: UITableView!
    var movieArrays: [Movie] = []
    var networkManager = NetworkingManager.shared
//    let searchController = UISearchController(searchResultsController: UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchResultViewController") as! SearchResultViewController)
    
    var searchMovie : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        setupTableView()
//        setupDatas()
    }
    
    
    func setupSearchBar() {
        //            self.title = "Movie Search"
        navigationItem.searchController = searchController
        //            searchBar.searchTextField
        
        
//        let searchBar = UISearchBar()
//        searchBar.placeholder = "Search User"
//        self.navigationItem.titleView = searchBar
        
        
        
        //            navigationItem.searchController = searchController
        
        
        //  1) (단순)서치바의 사용
        searchController.searchBar.delegate = self
        
        
        //  2) 서치(결과)컨트롤러의 사용 (복잡한 구현 가능)
        //     ==> 글자마다 검색 기능 + 새로운 화면을 보여주는 것도 가능
        //            searchController.searchResultsUpdater = self
        
        // 첫글자 대문자 설정 없애기
        //            searchController.searchBar.autocapitalizationType = .none
    }
    
    
    
    
    func setupTableView() {
        movieTableView.dataSource = self
        movieTableView.delegate = self
        // Nib파일을 사용한다면 등록의 과정이 필요
        
        movieTableView.register(UINib(nibName:"MyMovieViewCell", bundle: nil), forCellReuseIdentifier: "MyMovieViewCell")
        
        //musicTableView.rowHeight = 120
    }
    
    
    func setupDatas(movieName: String) {
        // 네트워킹의 시작
        networkManager.requestAPIToNaver(movieName) { movieList in
            if let movieList = movieList {
                self.movieArrays = movieList
                
                // 테이블뷰 리로드
                DispatchQueue.main.async {
                    self.movieTableView.reloadData()
                }
            }
        }
        
    }
}
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(#function)
        return self.movieArrays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = movieTableView.dequeueReusableCell(withIdentifier: "MyMovieViewCell" , for: indexPath) as! MyMovieViewCell
        
        guard let movieTitle = movieArrays[indexPath.row].movieTitle,
              let movieDirector = movieArrays[indexPath.row].movieDirector,
              let movieActor = movieArrays[indexPath.row].movieActor,
              let movieImg = movieArrays[indexPath.row].movieImg else {return UITableViewCell()}

        cell.movieNameLable.text = movieTitle.htmlEscaped
        cell.directorNameLabel.text = movieDirector.htmlEscaped
        cell.actorNameLabel.text = movieActor.htmlEscaped
        cell.imageUrl = movieImg.htmlEscaped
        
        cell.selectionStyle = .none
        return cell
    }
    
    
}
    

extension ViewController: UITableViewDelegate {
    //     테이블뷰 셀의 높이를 유동적으로 조절하고 싶다면 구현할 수 있는 메서드
    //     (musicTableView.rowHeight = 120 대신에 사용가능)
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
        
        //    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        //        return UITableView.automaticDimension
    }
}

extension ViewController: UISearchBarDelegate {

    // 유저가 글자를 입력하는 순간마다 호출되는 메서드
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        print(searchText)
        // 다시 빈 배열로 만들기
        self.movieArrays = []

        // 네트워킹 시작
        networkManager.requestAPIToNaver(searchText) { movieList in
            if let movieList = movieList {
                self.movieArrays = movieList

                // 테이블뷰 리로드
                DispatchQueue.main.async {
                    self.movieTableView.reloadData()
                }
            }

    }


}
}
