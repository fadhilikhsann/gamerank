//
//  DetailGameViewController.swift
//  Gamerank
//
//  Created by Fadhil Ikhsanta on 17/06/22.
//

import UIKit

class DetailGameViewController: UIViewController {
    
    var game: GameModel? = nil
    var isFavorite: Bool = false
    let apiRequest = ApiRequest()
    let apiEndPoint = ApiEndPoint()
    let dateFormat = DateFormat()
    
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var gameReleasedLabel: UILabel!
    @IBOutlet weak var gameDetailLabel: UILabel!
    @IBOutlet weak var gameRatingLabel: UILabel!
    @IBOutlet weak var favoriteGame: UIImageView!
    
    private lazy var favoriteGameProvider: FavoriteGameProvider = { return FavoriteGameProvider() }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="Detail"
        
        self.gameImageView.image = game?.imageGame ?? nil
        
        self.gameNameLabel.text = game!.nameGame
        
        self.gameReleasedLabel.text = "Released in \(dateFormat.getDate(releasedGame: game!.releasedGame!))"
        self.gameRatingLabel.text = "\(String(describing: Double(round(10 * game!.ratingGame) / 10)))/5"
        
        self.favoriteGame.image = favoriteGame.image?.withRenderingMode(.alwaysTemplate)
        
        favoriteGameProvider.checkFavoriteGame(
            game!.idGame
        ){
            isFavoriteGame in
            if isFavoriteGame {
                self.isFavorite = true
                DispatchQueue.main.async {
                    self.favoriteGame.tintColor = UIColor.systemPink
                }
                
            }
        }
        
        apiRequest.request(endPoint: apiEndPoint.getDetailGame(id: game!.idGame),{
            result in
            
            switch result {
            case .failure(let error):
                print(error)
                break
            case .success(let data):
                let decoder = JSONDecoder()
                
                if let gameData = try? decoder.decode(GameModel.self, from: data.0) as GameModel {
                    
                    DispatchQueue.main.async {
                        self.gameDetailLabel.text = gameData.descriptionGame?.htmlToString ?? ""
                    }
                    
                    if self.game!.imageGame == nil {
                        if let imageData = try? Data(contentsOf: self.game!.urlImageGame!){
                            DispatchQueue.main.async {
                                self.gameImageView.image = UIImage(data: imageData)
                            }
                        }
                    }
                    
                } else {
                    print("ERROR: Can't Decode JSON")
                }
                break
            }
            
            
        })
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped))
        favoriteGame.addGestureRecognizer(tapGR)
        favoriteGame.isUserInteractionEnabled = true
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension DetailGameViewController{
    @objc func imageTapped(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            if isFavorite{
                removeFavoriteGame()
            } else {
                addFavoriteGame()
            }
        }
    }
    
    func addFavoriteGame(){
        favoriteGameProvider.addFavoriteGame(
            game!.idGame,
            game!.nameGame!,
            game!.releasedGame!,
            game!.urlImageGame!,
            game!.ratingGame
        ) {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Successful", message: "\(self.game!.nameGame!) has added to favorite game.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                    self.isFavorite = true
                    self.favoriteGame.tintColor = UIColor.systemPink
                })
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func removeFavoriteGame(){
        favoriteGameProvider.removeFavoriteGame(
            game!.idGame
        ){
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Successful", message: "\(self.game!.nameGame!) has removed from favorite game.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                    self.isFavorite = false
                    self.favoriteGame.tintColor = UIColor.systemGray4
                })
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
