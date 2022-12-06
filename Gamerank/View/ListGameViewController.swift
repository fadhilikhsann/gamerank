//
//  ViewController.swift
//  Gamerank
//
//  Created by Fadhil Ikhsanta on 14/06/22.
//

import UIKit
import RxSwift
import RxCocoa
import Swinject

class ListGameViewController: UIViewController {
    let dateFormat = DateFormat()
    var viewModel: ListGameViewModel?
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
        self.gameTableView.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "GameCell")
        self.gameTableView.dataSource = self
        self.gameTableView.delegate = self
        loadListGameData()
    }
        
    private func loadListGameData() {
        viewModel?.getListGame()
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: {result in
                if(result.count > 0) {
                    self.games = result
                    self.gameTableView.reloadData()
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
        
        let listFavoriteGameViewController: ListFavoriteGameViewController = {
            let container = Container()
            container.register(GameUseCase.self) { _ in GameInjection.init().provideGameUseCase() as! GameUseCase }
            container.register(ListFavoriteGameViewModel.self) { r in ListFavoriteGameViewModel(gameUseCaseProtocol: r.resolve(GameUseCase.self)!) }
            container.register(ListFavoriteGameViewController.self) { r in
                let favoriteGame = ListFavoriteGameViewController(nibName: "ListFavoriteGameViewController", bundle: nil)
                favoriteGame.viewModel = r.resolve(ListFavoriteGameViewModel.self)
                return favoriteGame
            }
            return container
        }().resolve(ListFavoriteGameViewController.self)!
        
        listFavoriteGameViewController.modalPresentationStyle = .popover
        
        self.navigationController?.pushViewController(listFavoriteGameViewController, animated: true)
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
        guard let games = games else {return 0}
        return games.count
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
        
        detailGameViewController.idGame = games![indexPath.row].idGame
        detailGameViewController.imageGame = games![indexPath.row].imageGame
        detailGameViewController.modalPresentationStyle = .popover
        
        self.navigationController?.pushViewController(detailGameViewController, animated: true)
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
