//
//  DetailGameViewController.swift
//  Gamerank
//
//  Created by Fadhil Ikhsanta on 17/06/22.
//

import UIKit
import RxSwift
import Swinject
import FavoriteGame
import DetailGame

class DetailGameViewController: UIViewController {
    
    var detailGame: DetailGameUIModel? = nil
    var idGame: Int = 0
    var imageGame: UIImage? = nil
    var isFavorite: Bool = false
    let dateFormat = DateFormat()
    let disposeBag = DisposeBag()
    
    var detailGamePresenter: DetailGamePresenter?
    var favoriteGamePresenter: FavoriteGamePresenter?
    
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var gameReleasedLabel: UILabel!
    @IBOutlet weak var gameDetailLabel: UILabel!
    @IBOutlet weak var gameRatingLabel: UILabel!
    @IBOutlet weak var favoriteGame: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="Detail"
        
        self.gameImageView.image = imageGame ?? nil
        
        self.favoriteGame.image = favoriteGame.image?.withRenderingMode(.alwaysTemplate)
        
        getDescription()
        checkFavorite()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped))
        favoriteGame.addGestureRecognizer(tapGestureRecognizer)
        favoriteGame.isUserInteractionEnabled = true
        
        // Do any additional setup after loading the view.
    }
    
    func getDescription() {
        detailGamePresenter?.getDetail(idGame: idGame)
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: {result in

                self.detailGame = result
                
                self.gameNameLabel.text = self.detailGame!.nameGame
                
                self.gameReleasedLabel.text = "Released in \(self.dateFormat.getDate(releasedGame: self.detailGame!.releasedGame!))"
                self.gameRatingLabel.text = "\(String(describing: Double(round(10 * self.detailGame!.ratingGame) / 10)))/5"
                if self.imageGame == nil {
                    if let imageData = try? Data(contentsOf: self.detailGame!.urlImageGame!){
                        DispatchQueue.main.async {
                            self.gameImageView.image = UIImage(data: imageData)
                        }
                    }
                }
                
                self.gameDetailLabel.text = result.descriptionGame?.htmlToString ?? ""

            }
            )
            .disposed(by: disposeBag)
    }
    
    func checkFavorite() {
        
        favoriteGamePresenter?.checkByID(idGame)
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
        if sender.state == .ended {
            if isFavorite {
                removeFavoriteGame()
            } else {
                addFavoriteGame()
            }
        }
    }
    
    func addFavoriteGame(){
        
        print("Masuk loo")
        
        favoriteGamePresenter?.add(
            detailGame!.idGame,
            detailGame!.nameGame!,
            detailGame!.releasedGame!,
            detailGame!.urlImageGame!,
            detailGame!.ratingGame
        )
        .observe(on: MainScheduler.instance)
        .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
        .subscribe(onNext: {result in
            if (result) {
                print("harusnya berubah")
                let alert = UIAlertController(title: "Successful", message: "\(self.detailGame!.nameGame!) has added to favorite game.", preferredStyle: .alert)
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
        
        favoriteGamePresenter?.removeByID(
            idGame
        )
        .observe(on: MainScheduler.instance)
        .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
        .subscribe(onNext: {result in
            if (result) {
                let alert = UIAlertController(title: "Successful", message: "\(self.detailGame!.nameGame!) has removed from favorite game.", preferredStyle: .alert)
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
