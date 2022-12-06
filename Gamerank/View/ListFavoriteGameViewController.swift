//
//  ListFavoriteGameViewController.swift
//  Gamerank
//
//  Created by Fadhil Ikhsanta on 21/06/22.
//

import UIKit
import RxSwift
import Swinject

class ListFavoriteGameViewController: UIViewController {
    
    var tempIndexPath: IndexPath = []
    var tempIdGame: Int = 0
    private var favoriteGame: [ListGameUIModel]? = nil
    let disposeBag = DisposeBag()
    let dateFormat = DateFormat()
    private let _pendingOperations = PendingOperations()
    @IBOutlet weak var favoriteGameTableView: UITableView!
    var viewModel: ListFavoriteGameViewModel?
    
    override func viewWillAppear(_ animated: Bool) {
        
        if tempIdGame != 0 {
            
            checkFavorite(idGame: tempIdGame)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Favorite"
        loadListFavoriteGameData()
        
        self.favoriteGameTableView.dataSource = self
        self.favoriteGameTableView.delegate = self
        
        favoriteGameTableView.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "GameCell")
    }
    
    func loadListFavoriteGameData(){
        viewModel?.getAllFavoriteGame()
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: {result in
                self.favoriteGame = result
                self.favoriteGameTableView.reloadData()
            }
            )
            .disposed(by: disposeBag)
    }
    
}

extension ListFavoriteGameViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteGame?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath) as? GameTableViewCell else{
            return UITableViewCell()
        }
        
        let game = favoriteGame?[indexPath.row]
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
    
    func checkFavorite(idGame: Int) {
        viewModel?.checkFavoriteGame(idGame)
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: {result in
                if (!result) {
                    self.favoriteGame!.remove(at: self.tempIndexPath.row)
                    self.favoriteGameTableView.beginUpdates()
                    self.favoriteGameTableView.deleteRows(at: [self.tempIndexPath], with: .automatic)
                    self.favoriteGameTableView.endUpdates()
                }
            }
            )
            .disposed(by: disposeBag)
    }
    
}

extension ListFavoriteGameViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailGameViewController: DetailGameViewController = {
            let container = Container()
            container.register(GameUseCase.self) { _ in GameInjection.init().provideGameUseCase() as! GameUseCase }
            container.register(DetailGameViewModel.self) { r in DetailGameViewModel(gameUseCaseProtocol: r.resolve(GameUseCase.self)!) }
            container.register(DetailGameViewController.self) { r in
                let detailGame = DetailGameViewController(nibName: "DetailGameViewController", bundle: nil)
                detailGame.viewModel = r.resolve(DetailGameViewModel.self)
                return detailGame
            }
            return container
        }().resolve(DetailGameViewController.self)!
        
        tempIdGame = favoriteGame![indexPath.row].idGame
        tempIndexPath = indexPath
        detailGameViewController.idGame = favoriteGame![indexPath.row].idGame
        detailGameViewController.imageGame = favoriteGame![indexPath.row].imageGame
        detailGameViewController.modalPresentationStyle = .popover
        
        self.navigationController?.pushViewController(detailGameViewController, animated: true)
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
