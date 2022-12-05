//
//  ViewController.swift
//  Gamerank
//
//  Created by Fadhil Ikhsanta on 14/06/22.
//

import UIKit
import RxSwift
import RxCocoa

class ListGameViewController: UIViewController {
    let dateFormat = DateFormat()
    private var viewModel = ListGameViewModel(gameUseCaseProtocol: GameInjection.init().provideGameUseCase())
    //    var games:[GameModel]? = nil
    private var disposeBag = DisposeBag()
    var games:[ListGameUIModel]? = nil
    private let _pendingOperations = PendingOperations()
    @IBOutlet weak var gameTableView: UITableView!
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        toggleSuspendOperations(isSuspended: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        loadListGameData()
        
        self.gameTableView.dataSource = self
        self.gameTableView.delegate = self
        
        gameTableView.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "GameCell")
    }
    
    
    private func loadListGameData() {
        viewModel.getListGame()
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: {result in
                if(result.count > 0) {
                    self.games = result
                    self.gameTableView.reloadData()
                    print("masukkkk")
                }
            }
            )
            .disposed(by: disposeBag)
        
    }
    
    @IBAction func showProfile(_ sender: Any) {
        let profile = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
        self.navigationController?.pushViewController(profile, animated: true)
    }
    @IBAction func showFavoriteGame(_ sender: Any) {
        let favoriteGame = ListFavoriteGameViewController(nibName: "ListFavoriteGameViewController", bundle: nil)
        self.navigationController?.pushViewController(favoriteGame, animated: true)
    }
    
}

extension ListGameViewController: UINavigationBarDelegate{
    func navigationBar(_ navigationBar: UINavigationBar, shouldPush item: UINavigationItem) -> Bool {
        item.setValue(true, forKey: "__largeTitleTwoLineMode")
        return true
    }
}

extension ListGameViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath) as? GameTableViewCell else{
            return UITableViewCell()
        }
        
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

extension ListGameViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail = DetailGameViewController(nibName: "DetailGameViewController", bundle: nil)
        
        detail.idGame = games![indexPath.row].idGame
        detail.imageGame = games![indexPath.row].imageGame
        
        detail.modalPresentationStyle = .popover
        
        self.navigationController?.pushViewController(detail, animated: true)
        //        self.present(detail, animated: true)
    }
}

extension ListGameViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        toggleSuspendOperations(isSuspended: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        toggleSuspendOperations(isSuspended: false)
    }
}

extension ListGameViewController {
    
    fileprivate func startOperations(game: ListGameUIModel, indexPath: IndexPath) {
        if game.state == .new {
            startDownload(game: game, indexPath: indexPath)
        }
    }
    
    fileprivate func startDownload(game: ListGameUIModel, indexPath: IndexPath) {
        guard _pendingOperations.downloadInProgress[indexPath] == nil else { return }
        let downloader = ImageDownloader(game: game)
        downloader.completionBlock = {
            if downloader.isCancelled { return }
            
            DispatchQueue.main.async {
                self._pendingOperations.downloadInProgress.removeValue(forKey: indexPath)
                self.gameTableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        
        _pendingOperations.downloadInProgress[indexPath] = downloader
        _pendingOperations.downloadQueue.addOperation(downloader)
    }
    
    fileprivate func toggleSuspendOperations(isSuspended: Bool) {
        _pendingOperations.downloadQueue.isSuspended = isSuspended
    }
}
