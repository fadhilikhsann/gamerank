//
//  ViewController.swift
//  Gamerank
//
//  Created by Fadhil Ikhsanta on 14/06/22.
//

import UIKit

class ListGamesViewController: UIViewController {
    let apiRequest = ApiRequest()
    let apiEndPoint = ApiEndPoint()
    let dateFormat = DateFormat()
    var games:[GameModel]? = nil
    private let _pendingOperations = PendingOperations()
    @IBOutlet weak var gamesTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        toggleSuspendOperations(isSuspended: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        apiRequest.request(endPoint: apiEndPoint.getListGames(),{
            result in
            
            switch result {
            case .failure(let error):
                print(error)
            break
            case .success(let data):
                let decoder = JSONDecoder()
                
                if let gamesData = try? decoder.decode(RootModel.self, from: data.0) as RootModel {
                    
                    self.games = gamesData.listGames!
                    
                    DispatchQueue.main.async {
                        self.gamesTableView.reloadData()
                    }
                    
                } else {
                    print("ERROR: Can't Decode JSON")
                }
            break
            }
            
            
            
            
            
        })
        self.gamesTableView.dataSource = self
        
        // Menambahkan delegate ke table view
        self.gamesTableView.delegate = self
        
        // Menghubungkan berkas XIB untuk HeroTableViewCell dengn heroTableView.
        gamesTableView.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "GameCell")
    }
    @IBAction func showProfile(_ sender: Any) {
        let profile = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
        self.navigationController?.pushViewController(profile, animated: true)
    }
    
}

extension ListGamesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath) as? GameTableViewCell else{
            return UITableViewCell()
        }
        
        // Menetapkan nilai hero ke view di dalam cell
        let game = games?[indexPath.row]
        cell.layoutMargins = UIEdgeInsets.zero
        cell.gameNameLabel.text = game?.nameGame
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        
        cell.gameReleasedLabel.text = "Released in \(dateFormat.getDate(releasedGame: (game?.releasedGame)!))"
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

extension ListGamesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail = DetailGameViewController(nibName: "DetailGameViewController", bundle: nil)
        
        // Mengirim data hero
        detail.game = games![indexPath.row]
        
        // Push/mendorong view controller lain
        self.navigationController?.pushViewController(detail, animated: true)
    }
}

extension ListGamesViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        toggleSuspendOperations(isSuspended: true)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        toggleSuspendOperations(isSuspended: false)
    }
}

extension ListGamesViewController{
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
                self.gamesTableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
 
        _pendingOperations.downloadInProgress[indexPath] = downloader
        _pendingOperations.downloadQueue.addOperation(downloader)
    }
 
    fileprivate func toggleSuspendOperations(isSuspended: Bool) {
        _pendingOperations.downloadQueue.isSuspended = isSuspended
    }
}
