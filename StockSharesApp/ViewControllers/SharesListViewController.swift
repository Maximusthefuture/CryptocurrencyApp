//
//  ViewController.swift
//  StockSharesApp
//
//  Created by Maximus on 24.02.2021.
//

import UIKit

class SharesListViewController: DataLoadingViewController {
     var tableView: UITableView!
    var searchBar = UISearchBar()
    var networkManager = NetworkManager()
    var favouriteList = [Model]()
    var isSetFavourite = false
    private  let tableViewInsetHight: CGFloat = 60
    
    var modelList = [Model]()
    var tickerList = [String]()

  
    func dummyData() {
        for _ in 0...12 {
            modelList.append(Model(ticker: "AAPL", name: "asdqweAdqwdeqwdqwdqwd", logo: "", price: 2000, changePrice: 0.12, isFavourite: false))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.sizeToFit()
        let searchController = UISearchController(searchResultsController: nil)
        //        searchController.searchResultsUpdater = self
        self.navigationItem.searchController = searchController
        searchController.searchBar.placeholder  = "Find company or ticker"
        let titleLable = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        loadQuotes()
        //        dummyData()
        configureTabView()
        configureTableView()
        //        showLoadingViews()
        //        networkManager.group.notify(queue: .main) {
        ////            self.tableView.reloadData()
        //            print("DONE")
        //        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    func loadQuotes() {
        networkManager.loadCompanyPopularIndices { result in
            self.tickerList = result?.constituents ?? []
            print("result symbol is: \(result?.symbol)")
            for i in self.tickerList {
                print("TICKER LIST: \(i)")
                self.networkManager.getDetails(company: i) { p, q in
                    var name = p?.name ?? "HER"
                    var current = q?.c ?? 0
                    var logo = p?.logo ?? "NIL"
                    guard let prevClosePrice = q?.pc else {
                        return
                    }
                    self.modelList.append(Model(ticker: i, name: name, logo: logo, price: current, changePrice: current - prevClosePrice , isFavourite: false))
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    var tabView: TabView = {
        var tab = TabView()
        return tab
    }()
    
    let behindView = UIView()
    
    private func configureTabView() {
        behindView.backgroundColor = .white
        self.view.addSubview(tabView)
        self.view.addSubview(behindView)
        tabView.delegate = self
        
        let guide = view.safeAreaLayoutGuide
        behindView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 60, enableInsets: true)
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
            //            UIView.animate(withDuration: 0.5, animations: {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            //            }, completion: nil)
            print(targetContentOffset.pointee.y)
        } else {
            //            UIView.animate(withDuration: 0.0, animations: {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            //            }, completion: nil)
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
        tableView.rowHeight = 120.0
        tableView.allowsSelection = false
    }
}

extension SharesListViewController: UITableViewDelegate, UITableViewDataSource, FavouriteDelegate {
    
    func setFavourite(cell: StockTableViewCell) {
        print("BUTTON TAPPED")
    }
    
    
    func isFavourite(cell: StockTableViewCell) -> Bool {
        print(cell.favouriteButton.isSelected)
        cell.favouriteButton.isSelected = true
        print(cell.companyShortNameLabel)
        print()
        modelList[tableView.indexPath(for: cell)!.row].isFavourite = true
        print(modelList[tableView.indexPath(for: cell)!.row].name)
        //MARK: TODO Get prev state of tableview, then go back when clicked to Stocks
        return true
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSetFavourite ? favouriteList.count : modelList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SharesListCell", for: indexPath) as? StockTableViewCell
        //        let ticker = tickerList[indexPath.row]
        let activeArray = isSetFavourite ? favouriteList : modelList
        let ticker = activeArray[indexPath.row]
        cell?.companyShortNameLabel.text = ticker.ticker
        cell?.delegate = self
        DispatchQueue.main.async {
            cell?.companyFullNameLabel.text = ticker.name
            cell?.companyPrice.text = String(ticker.price)
            cell?.favouriteButton.isSelected = ticker.isFavourite
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 2
            let priceChange = NSNumber(value: ticker.changePrice)
            let formattedValue = formatter.string(from: priceChange)
            if ticker.changePrice < 0 {
                cell?.changePrice.textColor = .red
            } else {
                cell?.changePrice.textColor = .green
            }
            cell?.changePrice.text = "\(formattedValue!)"
            cell?.set(profile: ticker)
        }
        if indexPath.row % 2 == 0 {
            cell?.roundedRect.backgroundColor = UIColor(red: 0.9412, green: 0.9569, blue: 0.9686, alpha: 1.0)
        }
        //MARK:TODO forceunwrap ristrict!
        return cell!
    }
}

//extension SharesListViewController: UISearchResultsUpdating {
//    func updateSearchResults(for searchController: UISearchController) {
//        self.tableView.reloadData()
//    }
//}

extension SharesListViewController: FavouriteListDelegate {
    func showFavouriteList() {
        isSetFavourite = true
        favouriteList = modelList.filter { $0.isFavourite	}
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        print("COUNT IS: \(modelList.filter { $0.isFavourite}.count)")
    }
    
    func showList() {
        isSetFavourite = false
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}



