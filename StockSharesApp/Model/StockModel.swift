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
    
    var stockModelList: [Model] = []
    var networkManager: NetworkManager?
    var tickerList: [String] = []
    var array: [Model] = []
    var group = DispatchGroup()
    var total = 0
    var start = 0
    var startTicker = 0
    var end = 13
    var isFetchInProgress = false
    private weak var delegate: StockModelDelegate?
    var numOfTickers = 13
    let mineGroupGlobal = DispatchGroup()
    
    init(networkManager: NetworkManager, delegate: StockModelDelegate) {
        self.networkManager = networkManager
        self.delegate = delegate
    }
    
    func moderator(at index: Int) -> Model {
        return stockModelList[index]
    }
    
    var currentCount: Int {
        stockModelList.count
    }
    
    var totalCount: Int {
        return total
    }
    
    func loadTest() {
        guard !self.isFetchInProgress else {
            return
        }
        self.isFetchInProgress = true
        print("In background")
        self.networkManager?.loadCompanyPopularTest { result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isFetchInProgress = false
                    self.delegate?.onFetchFailed(with: error.reason)
                }
            case .success(let response):
                self.tickerList = Array(response.constituents[self.startTicker...self.end])
                self.startTicker += 10
                self.end += 10
                print("end \(self.end)")
                print("startTicker: \(self.startTicker)")
                print("numoftickers: \(self.numOfTickers)")
                self.isFetchInProgress = false
                self.total = response.constituents.count
                
                self.getDetails(tickerList: self.tickerList) { (result) in
                    self.stockModelList.append(result[self.start])
                    self.start += 1
                    print(self.start)
                    print("STOCKMODEL \(self.stockModelList.count)")
                }
                DispatchQueue.main.async {
                    if self.stockModelList.count > 29 {
                        let indexPathToReload = self.calculateIndexPathToReload(from: self.tickerList)
                        self.delegate?.onFetchCompleted(with: indexPathToReload)
                    } else {
                        self.delegate?.onFetchCompleted(with: .none)
                    }
                }
            }
        }
        print("STOCKMODEL TICKERLIST: \(tickerList.count)")
        
    }
    
    func getDetails(tickerList: [String], completion: @escaping ([Model]) -> Void ) {
        //походу идет двойной запрос нет?
        for i in tickerList  {
            mineGroupGlobal.enter()
            self.networkManager!.getDetails(company: i) { p, q in
                let name = p?.name ?? ""
                let current = q?.c ?? 0
                let logo = p?.logo ?? "NIL"
                guard let prevClosePrice = q?.pc else {
                    return
                }
                self.array.append(Model(ticker: i, name: name, logo: logo, price: current, changePrice: current - prevClosePrice , isFavourite: false))
                print("ARRAYCOUNT: \(self.array.count)")
                self.mineGroupGlobal.leave()
                self.group.notify(queue: .main) {
                    completion(self.array)
                }
            }
        }
    }
    
    private func calculateIndexPathToReload(from newModel: [String]) -> [IndexPath] {
        let startIndex = stockModelList.count - tickerList.count
        let endIndex = startIndex + newModel.count
        print("startIndex: \(startIndex)")
        print("endIndex: \(endIndex)")
        print("Index moderatorsCount: \(stockModelList.count)")
        print("Index newmoderatorsCount: \(tickerList.count)")
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0)}
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
        //favouriteList add?
        stockModelList.append(model)
    }
}

