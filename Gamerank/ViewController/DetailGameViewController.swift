//
//  DetailGameViewController.swift
//  Gamerank
//
//  Created by Fadhil Ikhsanta on 17/06/22.
//

import UIKit

class DetailGameViewController: UIViewController {
    
    var game:GameModel? = nil
    let apiRequest = ApiRequest()
    let apiEndPoint = ApiEndPoint()
    let dateFormat = DateFormat()
    
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var gameReleasedLabel: UILabel!
    @IBOutlet weak var gameDetailLabel: UILabel!
    @IBOutlet weak var gameRatingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="Detail"
        
        self.gameImageView.image = game?.imageGame ?? nil
        
        self.gameNameLabel.text = game!.nameGame
        
        self.gameReleasedLabel.text = "Released in \(dateFormat.getDate(releasedGame: (game?.releasedGame)!))"
        self.gameRatingLabel.text = "\(String(describing: Double(round(10 * game!.ratingGame) / 10)))/5"
        
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
