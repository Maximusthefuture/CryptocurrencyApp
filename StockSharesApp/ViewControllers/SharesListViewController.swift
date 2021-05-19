//
//  ViewController.swift
//  StockSharesApp
//
//  Created by Maximus on 24.02.2021.
//

import UIKit

enum Section {
    case main
}

class SharesListViewController: DataLoadingViewController {
    
    var tableView: UITableView!
    var searchBar = UISearchBar()
    var finhub: DataProvider?
    var networkManager = NetworkManager()
    var favouriteList = [Model]()
    var isSetFavourite = false
    var stockModel: StockModel?
    var searchViewController: SearchViewController!
    var dataSource: UITableViewDiffableDataSource<Section, Model>! = nil
    private  let tableViewInsetHight: CGFloat = 60
    
    var modelList: [Model] = []
    var tickerList = [String]()
    var searchController: UISearchController!
    
    func dummyData() {
        for i in 0...12 {
            if i % 2 == 1 {
                modelList.append(Model(ticker: "AAPL", name: "Apple something", logo: "", price: 200000, changePrice: 0.12, isFavourite: false))
            } else {
                modelList.append(Model(ticker: "ZOPA", name: "Zopa something", logo: "", price: 2000, changePrice: -0.12, isFavourite: false))
            }
        }
    }
  
    func setInitialSnapShot() {
        var initialSnapShot = NSDiffableDataSourceSnapshot<Section, Model>()
        initialSnapShot.appendSections([.main])
        initialSnapShot.appendItems(self.modelList)
        self.dataSource.apply(initialSnapShot, animatingDifferences: true)
        
    }
    
    func diffableDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, Model>(tableView: tableView, cellProvider: { (tableView: UITableView, indexPath: IndexPath, model: Model) -> UITableViewCell? in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SharesListCell", for: indexPath) as? StockTableViewCell
            let activeArray = self.isSetFavourite ? self.favouriteList : self.modelList
            let ticker = activeArray[indexPath.row]
//            cell?.stock = ticker
            cell?.delegate = self
            //            var updatedSnapshot = self.dataSource.snapshot()
            //            if let dataSourceIndex = updatedSnapshot.indexOfItem(ticker) {
            //                let item = self.modelList[dataSourceIndex]
            DispatchQueue.main.async {
                cell?.set(profile: ticker)
                //                    updatedSnapshot.reloadItems([item])
                //                DispatchQueue.main.async {
                //                        self.dataSource.apply(updatedSnapshot, animatingDifferences: true)
                //                }
                if indexPath.row % 2 == 0 {
                    cell?.roundedRect.backgroundColor = UIColor(red: 0.9412, green: 0.9569, blue: 0.9686, alpha: 1.0)
                }
            }
            //            }
            return cell
        })
        
        self.dataSource.defaultRowAnimation = .fade
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backButtonTitle = ""
        self.view.backgroundColor = .white
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.sizeToFit()
            //MARK: TODO DI
//        finhub = FinhubDataProvider()
        //        var manager = NetworkManager(finhubDataProvider: finhub!)
        configureTabView()
        configureTableView()
        searchControllerConfig()
        stockModel = StockModel(networkManager: networkManager, delegate: self)
        self.stockModel?.fetchDataFromNetwork()
//        showLoadingViews()
    }
    
    var tabView: TabView = {
        var tab = TabView()
        return tab
    }()
    
    let behindView = UIView()
    
    func searchControllerConfig() {
        searchViewController = SearchViewController()
        searchController = UISearchController(searchResultsController: searchViewController)
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.searchBar.placeholder  = "Find company or ticker"
        searchController.searchBar.delegate = self
        searchController.searchBar.autocapitalizationType = .none
        self.navigationItem.searchController = searchController
    }
    
    private func configureTabView() {
        behindView.backgroundColor = .white
        self.view.addSubview(tabView)
        self.view.addSubview(behindView)
        tabView.delegate = self
        let guide = view.safeAreaLayoutGuide
        behindView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 60, enableInsets: true, identifier: "behindView")
        behindView.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        behindView.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
        tabView.translatesAutoresizingMaskIntoConstraints = false
        tabView.backgroundColor = .white
        tabView.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        tabView.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        tabView.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
        tabView.heightAnchor.constraint(equalToConstant: tableViewInsetHight).isActive = true
        
    }
 
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y > 0 {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            print(targetContentOffset.pointee.y)
        } else {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            print(targetContentOffset.pointee.y)
        }
    }
    
    func configureTableView() {
        tableView = UITableView()
        view.addSubview(tableView)
        tableView.backgroundColor = .white
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.register(StockTableViewCell.self, forCellReuseIdentifier: "SharesListCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: tabView.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -8).isActive = true
        tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 8).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -8).isActive = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.rowHeight = 120.0
        tableView.allowsSelection = true
    }
    
    func setToSuggestedSearches() {
        // Show suggested searches only if we don't have a search token in the search field.
        if searchController.searchBar.searchTextField.tokens.isEmpty {
            searchViewController.showSuggestingSearch = true
            // We are no longer interested in cell navigating, since we are now showing the suggested searches.
            searchViewController.tableView.delegate = searchViewController
        }
    }
}

extension SharesListViewController: UITableViewDelegate, UITableViewDataSource, FavouriteDelegate {
    
    func setFavourite(cell: StockTableViewCell) {
        print("BUTTON TAPPED")
    }
    
    func isFavourite(cell: StockTableViewCell) -> Bool {
        cell.favouriteButton.isSelected = !cell.favouriteButton.isSelected
        print(cell.favouriteButton.isSelected)
        if cell.favouriteButton.isSelected {
            self.stockModel?.stockModelList[self.tableView.indexPath(for: cell)!.row].isFavourite = true
            self.favouriteList.append((self.stockModel?.stockModelList[self.tableView.indexPath(for: cell)!.row])!)
            print("\(self.tableView.indexPath(for: cell)!.row)")
        } else {
            self.stockModel?.stockModelList[self.tableView.indexPath(for: cell)!.row].isFavourite = false
                //MARK: TODO Index out of range
//            self.favouriteList.remove(at: self.tableView.indexPath(for: cell)!.row)
            print("\(self.tableView.indexPath(for: cell)!.row)")
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        //MARK: TODO Get prev state of tableview, then go back when clicked to Stocks
        return cell.favouriteButton.isSelected
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSetFavourite ? favouriteList.count : stockModel?.total ?? 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SharesListCell", for: indexPath) as? StockTableViewCell
        cell?.delegate = self
        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        if isLoadingCell(for: indexPath) {
            cell?.configure(with: .none)
        } else {
            cell?.configure(with:  stockModel?.moderator(at: indexPath.row))
            cell?.set(profile:  stockModel?.moderator(at: indexPath.row))
        }
        DispatchQueue.main.async {
            if indexPath.row % 2 == 0 {
                cell?.roundedRect.backgroundColor = UIColor(red: 0.9412, green: 0.9569, blue: 0.9686, alpha: 1.0)
            }
        }
        return cell!
    }
}

extension SharesListViewController: FavouriteListDelegate {
    func showFavouriteList() {
        self.isSetFavourite = true
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func showList() {
        self.isSetFavourite = false
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension SharesListViewController: UISearchControllerDelegate {
    func presentSearchController(_ searchController: UISearchController) {
        searchController.showsSearchResultsController = true
        setToSuggestedSearches()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected indexPath:\(indexPath)")
        let index = stockModel?.stockModelList[indexPath.row]
        let detail = DetailViewController()
        detail.model = index
        self.navigationController?.pushViewController(detail, animated: true)
    }
    
}

extension SharesListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text!.isEmpty {
            // Text is empty, show suggested searches again.
            setToSuggestedSearches()
        } else {
            searchViewController.showSuggestingSearch = false
        }
    }
}

extension SharesListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print("UPDATING")
        
        guard let list = stockModel?.stockModelList else {
            return
        }
        let searchResult = stockModel!.filterResults(modelList: list, text: searchController.searchBar.text!)
        
        if searchResult.isEmpty {
            print("Nothing to find")
            //            stockModel.startNetworkSearch
            //searchedArray.append?
        }
        //can use GCD
        //        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(stockModel.loadSearch), object: nil)
        //        perform(#selector(stockModel.loadSearch), with: nil, afterDelay: 0.5)
        
        if let result = searchController.searchResultsController as? SearchViewController {
            if !searchResult.isEmpty {
                result.filteredItems = searchResult
            } else {
                //fetch from network?
                //                result.filteredItems = searcherArray
                //stockModel.searchResult(searchController.searchBar.text!)э
                
            }
            result.tableView.reloadData()
        }
    }
}

extension SharesListViewController: StockModelDelegate {
    
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        DispatchQueue.main.async {
        print("UPDATING ROWS ON MAIN QUEUE")
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            self.tableView.reloadData()
            self.dismissLoadingView()
            return
        }
            let indexPathToReload = self.visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
            self.tableView.reloadRows(at: indexPathToReload, with: .automatic)
        }
    }
    
    func onFetchFailed(with reason: String) {
        print("ERROR: \(reason)")
    }
        
}

extension SharesListViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            stockModel?.fetchDataFromNetwork()
            print("prefetchRowsAt \(indexPaths)")
        }
    }
}

private extension SharesListViewController {
    func isLoadingCell(for indexPath: IndexPath ) -> Bool {
        return indexPath.row >= stockModel!.currentCount
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathForVisibleRows = tableView.indexPathsForVisibleRows ?? []
        let indexPathIntersection = Set(indexPathForVisibleRows).intersection(indexPaths)
        return Array(indexPathIntersection)
    }
}






