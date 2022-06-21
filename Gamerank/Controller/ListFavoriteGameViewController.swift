//
//  ListFavoriteGameViewController.swift
//  Gamerank
//
//  Created by Fadhil Ikhsanta on 21/06/22.
//

import UIKit

class ListFavoriteGameViewController: UIViewController {
    
    var tempIndexPath: IndexPath = []
    var tempIdGame: Int = 0
    private var favoriteGames: [GameModel]? = nil
    let dateFormat = DateFormat()
    private let _pendingOperations = PendingOperations()
    @IBOutlet weak var favoriteGameTableView: UITableView!
    private lazy var favoriteGameProvider: FavoriteGameProvider = { return FavoriteGameProvider() }()
    
    override func viewWillAppear(_ animated: Bool) {
        if tempIdGame != 0 {
            favoriteGameProvider.checkFavoriteGame(
                tempIdGame
            ){
                isFavoriteGame in
                if !isFavoriteGame {
                    DispatchQueue.main.async {
                        self.favoriteGames!.remove(at: self.tempIndexPath.row)
                        self.favoriteGameTableView.beginUpdates()
                        self.favoriteGameTableView.deleteRows(at: [self.tempIndexPath], with: .automatic)
                        self.favoriteGameTableView.endUpdates()
                    }
                    
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Favorite"
        loadFavoriteGame()
        self.favoriteGameTableView.dataSource = self
        
        self.favoriteGameTableView.delegate = self
        
        favoriteGameTableView.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "GameCell")
    }
    
    func loadFavoriteGame(){
        self.favoriteGameProvider.getAllFavoriteGame{
            result in
            DispatchQueue.main.async {
                self.favoriteGames = result
                self.favoriteGameTableView.reloadData()
            }
        }
    }
    
}

extension ListFavoriteGameViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteGames?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath) as? GameTableViewCell else{
            return UITableViewCell()
        }
        
        let game = favoriteGames?[indexPath.row]
        cell.layoutMargins = UIEdgeInsets.zero
        cell.gameNameLabel.text = game?.nameGame
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"

//        cell.gameReleasedLabel.text = "Released in \(dateFormat.getDate(releasedGame: game?.releasedGame))"
        cell.gameRatingLabel.text = "\(String(describing: Double(round(10 * game!.ratingGame) / 10)))/5"

        cell.gameImageView.image = game?.imageGame

        cell.gameImageView.layer.cornerRadius = 10
        cell.gameImageView.clipsToBounds = true

        if game!.state == .new {
            startOperations(game: game!, indexPath: indexPath)
        }
        
        return cell
        
    }
    
}

extension ListFavoriteGameViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail = DetailGameViewController(nibName: "DetailGameViewController", bundle: nil)
        
        detail.game = favoriteGames![indexPath.row]
        tempIndexPath = indexPath
        tempIdGame = favoriteGames![indexPath.row].idGame
        
        self.navigationController?.pushViewController(detail, animated: true)
    }
}

extension ListFavoriteGameViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        toggleSuspendOperations(isSuspended: true)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        toggleSuspendOperations(isSuspended: false)
    }
}

extension ListFavoriteGameViewController{
    fileprivate func startOperations(game: GameModel, indexPath: IndexPath) {
        if game.state == .new {
            startDownload(game: game, indexPath: indexPath)
        }
    }
 
    fileprivate func startDownload(game: GameModel, indexPath: IndexPath) {
        guard _pendingOperations.downloadInProgress[indexPath] == nil else { return }
        let downloader = ImageDownloader(game: game)
        downloader.completionBlock = {
            if downloader.isCancelled { return }
 
            DispatchQueue.main.async {
                self._pendingOperations.downloadInProgress.removeValue(forKey: indexPath)
                self.favoriteGameTableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
 
        _pendingOperations.downloadInProgress[indexPath] = downloader
        _pendingOperations.downloadQueue.addOperation(downloader)
    }
 
    fileprivate func toggleSuspendOperations(isSuspended: Bool) {
        _pendingOperations.downloadQueue.isSuspended = isSuspended
    }
}
