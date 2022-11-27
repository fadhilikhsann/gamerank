//
//  DetailGameViewController.swift
//  Gamerank
//
//  Created by Fadhil Ikhsanta on 17/06/22.
//

import UIKit

class DetailGameViewController: UIViewController {
    
    //    var game: GameModel? = nil
    var game: GameEntity? = nil
    var isFavorite: Bool = false
    let dateFormat = DateFormat()
    
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var gameReleasedLabel: UILabel!
    @IBOutlet weak var gameDetailLabel: UILabel!
    @IBOutlet weak var gameRatingLabel: UILabel!
    @IBOutlet weak var favoriteGame: UIImageView!
    
//    private lazy var favoriteGameProvider: FavoriteGameProvider = { return FavoriteGameProvider() }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="Detail"
        
        self.gameImageView.image = game?.imageGame ?? nil
        
        self.gameNameLabel.text = game!.nameGame
        
        self.gameReleasedLabel.text = "Released in \(dateFormat.getDate(releasedGame: game!.releasedGame!))"
        self.gameRatingLabel.text = "\(String(describing: Double(round(10 * game!.ratingGame) / 10)))/5"
        
        self.favoriteGame.image = favoriteGame.image?.withRenderingMode(.alwaysTemplate)
        
        if(GamePresenter(
            gameUseCaseProtocol: GameInjection.init()
            .provideGameUseCase())
            .checkFavoriteGame(game!.idGame)
        ) {
            self.isFavorite = true
            self.favoriteGame.tintColor = UIColor.systemPink
        }
        
        
        //        favoriteGameProvider.checkFavoriteGame(
        //            game!.idGame
        //        ){
        //            isFavoriteGame in
        //            if isFavoriteGame {
        //                self.isFavorite = true
        //                DispatchQueue.main.async {
        //                    self.favoriteGame.tintColor = UIColor.systemPink
        //                }
        //
        //            }
        //        }
        
        self.gameDetailLabel.text = GamePresenter(gameUseCaseProtocol: GameInjection.init().provideGameUseCase())
            .getDetailGame(idGame: game!.idGame).descriptionGame?.htmlToString ?? ""
        
        if self.game!.imageGame == nil {
            if let imageData = try? Data(contentsOf: self.game!.urlImageGame!){
                DispatchQueue.main.async {
                    self.gameImageView.image = UIImage(data: imageData)
                }
            }
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped))
        favoriteGame.addGestureRecognizer(tapGestureRecognizer)
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
        print("CLICKED")
        if sender.state == .ended {
            if isFavorite{
                removeFavoriteGame()
            } else {
                addFavoriteGame()
            }
        }
    }
    
    func addFavoriteGame(){
        print("DI SINI")
        if (GamePresenter(
            gameUseCaseProtocol: GameInjection.init()
            .provideGameUseCase())
            .addFavoriteGame(
                game!.idGame,
                game!.nameGame!,
                game!.releasedGame!,
                game!.urlImageGame!,
                game!.ratingGame
            )
        ){
            print("TRY")
            let alert = UIAlertController(title: "Successful", message: "\(self.game!.nameGame!) has added to favorite game.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                self.isFavorite = true
                self.favoriteGame.tintColor = UIColor.systemPink
            })
            self.present(alert, animated: true, completion: nil)
        } else {
            print("gagal")
        }
        
//        favoriteGameProvider.addFavoriteGame(
//            game!.idGame,
//            game!.nameGame!,
//            game!.releasedGame!,
//            game!.urlImageGame!,
//            game!.ratingGame
//        ) {
//            DispatchQueue.main.async {
//                let alert = UIAlertController(title: "Successful", message: "\(self.game!.nameGame!) has added to favorite game.", preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
//                    self.isFavorite = true
//                    self.favoriteGame.tintColor = UIColor.systemPink
//                })
//                self.present(alert, animated: true, completion: nil)
//            }
//        }
        
    }
    
    func removeFavoriteGame(){
        if (GamePresenter(
            gameUseCaseProtocol: GameInjection.init()
            .provideGameUseCase())
            .removeFavoriteGame(
                game!.idGame
            )
        ){
            let alert = UIAlertController(title: "Successful", message: "\(self.game!.nameGame!) has removed from favorite game.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                self.isFavorite = false
                self.favoriteGame.tintColor = UIColor.systemGray4
            })
            self.present(alert, animated: true, completion: nil)
        }
        
//        favoriteGameProvider.removeFavoriteGame(
//            game!.idGame
//        ){
//            DispatchQueue.main.async {
//                let alert = UIAlertController(title: "Successful", message: "\(self.game!.nameGame!) has removed from favorite game.", preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
//                    self.isFavorite = false
//                    self.favoriteGame.tintColor = UIColor.systemGray4
//                })
//                self.present(alert, animated: true, completion: nil)
//            }
//        }
        
    }
}
