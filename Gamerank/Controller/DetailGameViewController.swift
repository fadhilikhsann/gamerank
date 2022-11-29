//
//  DetailGameViewController.swift
//  Gamerank
//
//  Created by Fadhil Ikhsanta on 17/06/22.
//

import UIKit
import RxSwift

class DetailGameViewController: UIViewController {
    
    // var game: GameModel? = nil
    var game: GameEntity? = nil
    var isFavorite: Bool = false
    let dateFormat = DateFormat()
    let disposeBag = DisposeBag()
    private var viewModel = DetailGameViewModel(gameUseCaseProtocol: GameInjection.init().provideGameUseCase())
    
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var gameReleasedLabel: UILabel!
    @IBOutlet weak var gameDetailLabel: UILabel!
    @IBOutlet weak var gameRatingLabel: UILabel!
    @IBOutlet weak var favoriteGame: UIImageView!
    
    // private lazy var favoriteGameProvider: FavoriteGameProvider = { return FavoriteGameProvider() }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="Detail"
        
        self.gameImageView.image = game?.imageGame ?? nil
        
        self.gameNameLabel.text = game!.nameGame
        
        self.gameReleasedLabel.text = "Released in \(dateFormat.getDate(releasedGame: game!.releasedGame!))"
        self.gameRatingLabel.text = "\(String(describing: Double(round(10 * game!.ratingGame) / 10)))/5"
        
        self.favoriteGame.image = favoriteGame.image?.withRenderingMode(.alwaysTemplate)
        
        getDescription()
        checkFavorite()
        
        
        
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
    
    func getDescription() {
        viewModel.getDetailGame(idGame: game!.idGame)
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: {result in

                self.gameDetailLabel.text = result.descriptionGame?.htmlToString ?? ""

            }
            )
            .disposed(by: disposeBag)
    }
    
    func checkFavorite() {
        
        viewModel.checkFavoriteGame(game!.idGame)
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: {result in
                if (result) {
                    self.isFavorite = true
                    
                    self.favoriteGame.tintColor = UIColor.systemPink
                    
                }
                
            }
            )
            .disposed(by: disposeBag)
    }
    
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
        
        viewModel.addFavoriteGame(
            game!.idGame,
            game!.nameGame!,
            game!.releasedGame!,
            game!.urlImageGame!,
            game!.ratingGame
        )
        .observe(on: MainScheduler.instance)
        .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
        .subscribe(onNext: {result in
            if (result) {
                let alert = UIAlertController(title: "Successful", message: "\(self.game!.nameGame!) has added to favorite game.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                    self.isFavorite = true
                    self.favoriteGame.tintColor = UIColor.systemPink
                })
                self.present(alert, animated: true, completion: nil)
            } else {
                print("gagal")
            }
        }
        )
        .disposed(by: disposeBag)

    }
    
    func removeFavoriteGame(){
        
        viewModel.removeFavoriteGame(
            game!.idGame
        )
        .observe(on: MainScheduler.instance)
        .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
        .subscribe(onNext: {result in
            if (result) {
                let alert = UIAlertController(title: "Successful", message: "\(self.game!.nameGame!) has removed from favorite game.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                    self.isFavorite = false
                    self.favoriteGame.tintColor = UIColor.systemGray4
                })
                self.present(alert, animated: true, completion: nil)
            } else {
                print("gagal")
            }
        }
        )
        .disposed(by: disposeBag)
        
    }
}
