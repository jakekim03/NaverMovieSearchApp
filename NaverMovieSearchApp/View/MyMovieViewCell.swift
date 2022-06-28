//
//  MyMovieViewCell.swift
//  NaverMovieSearchApp
//
//  Created by 김용민 on 2022/06/13.
//

import UIKit

class MyMovieViewCell: UITableViewCell {

    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var movieNameLable: UILabel!
    @IBOutlet weak var directorNameLabel: UILabel!
    @IBOutlet weak var actorNameLabel: UILabel!
    

    
    
    var imageUrl: String? {
        didSet {
            loadImage()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // 일반적으로 이미지가 바뀌는 것처럼 보이는 현상을 없애기 위해서 실행 ⭐️
        self.mainImageView.image = nil
        mainImageView.contentMode = .scaleToFill
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        guard let imgview = mainImageView else { return }
        imgview.contentMode = .scaleToFill
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    // URL ===> 이미지를 셋팅하는 메서드
    private func loadImage() {
        guard let urlString = self.imageUrl, let url = URL(string: urlString)  else { return }
        
        DispatchQueue.global().async {
        
            guard let data = try? Data(contentsOf: url) else { return }
            // 오래걸리는 작업이 일어나고 있는 동안에 url이 바뀔 가능성 제거 ⭐️⭐️⭐️
            guard urlString == url.absoluteString else { return }
            
            DispatchQueue.main.async {
                self.mainImageView.image = UIImage(data: data)
            }
        }
    }
    
}
