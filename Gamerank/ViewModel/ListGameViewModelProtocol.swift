//
//  ApiPresenterProtocol.swift
//  Gamerank
//
//  Created by Fadhil Ikhsanta on 26/11/22.
//

import Foundation
import RxSwift

protocol ListGameViewModelProtocol {
    func getListGame(
    ) -> Observable<[ListGameUIModel]>
}
