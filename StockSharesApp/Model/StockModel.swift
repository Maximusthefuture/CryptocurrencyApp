//
//  StockModel.swift
//  StockSharesApp
//
//  Created by Maximus on 18.03.2021.
//

import Foundation


protocol StockModelDelegate: class {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
    func onFetchFailed(with reason: String)
}

class StockModel {
    
    //Получить все данные и кинуть их в array
    var stockModelList: [Model] = []
    var listOfCompanies = [String]()
    var networkManager: NetworkManager?
    var tickerList: [String] = []
    var total = 0
    var isLoading: Bool?
    private weak var delegate: StockModelDelegate?
    
    init(networkManager: NetworkManager, delegate: StockModelDelegate) {
        self.networkManager = networkManager
        self.delegate = delegate
    }
    
    func moderator(at index: Int) -> Model {
      return stockModelList[index]
    }
    
    
    func loadQuotes() {
        networkManager?.loadCompanyPopularIndices { [weak self] result in
            self?.tickerList = result?.constituents.suffix(10) ?? []
            self?.total = (self?.tickerList.count)!
            print("result symbol is: \(result?.symbol ?? "")")
            for i in self!.tickerList {
                print("TICKER LIST: \(i)")
                self?.networkManager!.getDetails(company: i) { [weak self] p, q in
                    let name = p?.name ?? "HER"
                    let current = q?.c ?? 0
                    let logo = p?.logo ?? "NIL"
                    guard let prevClosePrice = q?.pc else {
                        return
                    }
                    self?.stockModelList.append(Model(ticker: i, name: name, logo: logo, price: current, changePrice: current - prevClosePrice , isFavourite: false))
                    DispatchQueue.main.async {
                        self?.delegate?.onFetchCompleted(with: .none)
                    }
                }
            }
        }
    }
    
    func filterResults(modelList: [Model], text: String) -> [Model] {
        let searchResult = modelList.filter { (model: Model) -> Bool in
            return model.ticker.lowercased().contains(text.lowercased()) ||
                model.name.lowercased().contains(text.lowercased())
        }
        return searchResult
    }
    
    @objc func loadSearch() {
        
    }
    
    func addToFavourite(model: Model) {
        //Favourite list?
        stockModelList.append(model)
    }
}

