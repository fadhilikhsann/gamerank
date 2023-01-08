//
//  ListFavoriteGameViewController.swift
//  Gamerank
//
//  Created by Fadhil Ikhsanta on 21/06/22.
//

import UIKit
import RxSwift
import Swinject
import FavoriteGame
import ImageDownloader
import DetailGame
import CoreModule

class ListFavoriteGameViewController: UIViewController {
    
    var tempIndexPath: IndexPath = []
    var tempIdGame: Int = 0
    private var favoriteGame: [FavoriteGameUIModel] = []
    private var uiImageModel: [UIImageModel] = []
    let disposeBag = DisposeBag()
    let dateFormat = DateFormat()
    private let _pendingOperations = PendingOperations()
    @IBOutlet weak var favoriteGameTableView: UITableView!
    var favoriteGamePresenter: FavoriteGamePresenter<
        FavoriteGameInteractor<
            FavoriteGameRepository<
                FavoriteGameDataSource
            >
        >
    >?
    
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
        favoriteGamePresenter?.getData(request: nil)
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
        return favoriteGame.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath) as? GameTableViewCell else{
            return UITableViewCell()
        }
        
        let game = favoriteGame[indexPath.row]
        cell.layoutMargins = UIEdgeInsets.zero
        cell.gameNameLabel.text = game.nameGame
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"

        cell.gameReleasedLabel.text = "Released in \(dateFormat.getDate(releasedGame: (game.releasedGame)!))"
        cell.gameRatingLabel.text = "\(String(describing: Double(round(10 * game.ratingGame) / 10)))/5"
        
        uiImageModel.append(UIImageModel(forUrlImage: game.urlImageGame!))
        cell.gameImageView.image = uiImageModel[indexPath.row].image

        cell.gameImageView.layer.cornerRadius = 10
        cell.gameImageView.clipsToBounds = true
        
        uiImageModel[indexPath.row].urlImage = game.urlImageGame
        
        if uiImageModel[indexPath.row].state == .new {
            startOperations(model: uiImageModel[indexPath.row], indexPath: indexPath)
        }
        
        return cell
        
    }
    
    func checkFavorite(idGame: Int) {
        favoriteGamePresenter?.checkByID(idGame)
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: {result in
                if (!result) {
                    self.favoriteGame.remove(at: self.tempIndexPath.row)
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
            
            container.register(
                DetailGameInteractor<
                DetailGameRepository<
                DetailGameDataSource
                >>.self
            ) { _ in DetailGameInjection.init().provideUseCase() }
            container.register(DetailGamePresenter.self) { r in DetailGamePresenter(useCase: r.resolve(
                DetailGameInteractor<
                DetailGameRepository<
                DetailGameDataSource
                >>.self
            )!) }
            
            container.register(
                FavoriteGameUseCase.self
            ) {
                _ in FavoriteGameInjection.init().provideLocaleUseCase()
            }
            container.register(
                FavoriteGameInteractor<
                FavoriteGameRepository<
                FavoriteGameDataSource
                >>.self
            ) {
                _ in FavoriteGameInjection.init().provideRemoteUseCase()
            }
            
            container.register(
                FavoriteGamePresenter<
                FavoriteGameInteractor<
                FavoriteGameRepository<
                FavoriteGameDataSource
                >>>.self
            ) {
                r in FavoriteGamePresenter(
                localeUseCase: r.resolve(
                    FavoriteGameUseCase.self
                )!
            )
            }
            
            container.register(DetailGameViewController.self) { r in
                let detailGame = DetailGameViewController(nibName: "DetailGameViewController", bundle: nil)
                detailGame.detailGamePresenter = r.resolve(DetailGamePresenter.self)
                detailGame.favoriteGamePresenter = r.resolve(
                    FavoriteGamePresenter<
                    FavoriteGameInteractor<
                    FavoriteGameRepository<
                    FavoriteGameDataSource
                    >>>.self
                )
                return detailGame
            }
            return container
        }().resolve(DetailGameViewController.self)!
        
        tempIdGame = favoriteGame[indexPath.row].idGame
        tempIndexPath = indexPath
        detailGameViewController.idGame = favoriteGame[indexPath.row].idGame
        detailGameViewController.imageGame = uiImageModel[indexPath.row].image
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
    fileprivate func startOperations(model: UIImageModel, indexPath: IndexPath) {
        if model.state == .new {
            startDownload(model: model, indexPath: indexPath)
        }
    }
 
    fileprivate func startDownload(model: UIImageModel, indexPath: IndexPath) {
        guard _pendingOperations.downloadInProgress[indexPath] == nil else { return }
        let downloader = ImageDownloader(model: model)
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
