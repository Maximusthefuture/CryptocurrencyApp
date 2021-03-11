//
//  ViewController.swift
//  StockSharesApp
//
//  Created by Maximus on 24.02.2021.
//

import UIKit

class SharesListViewController: UIViewController{
    var tableView: UITableView!
    var searchBar = UISearchBar()
    var networkManager = NetworkManager()
    var group = DispatchGroup()
    
    private  let tableViewInsetHight: CGFloat = 60
    
    var modelList = [Model]()
    var quotesList = [Stock]()
    var quotesList2 = [String]()
    var stockPrice = [String: Double]()
 
    
    override func viewWillAppear(_ animated: Bool) {
        print("VIEWWILLAPPEAR")
        
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.sizeToFit()
        let searchController = UISearchController(searchResultsController: nil)
        //        searchController.searchResultsUpdater = self
        self.navigationItem.searchController = searchController
        searchController.searchBar.placeholder  = "Find company or ticker"
        let titleLable = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        configureTabView()
        configureTableView()
        networkManager.delegate = self
        
        networkManager.loadQuotes {  result in
            
            self.quotesList2 = result![0].quotes
            print(self.quotesList2.map{ $0 })
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
        }
    
        networkManager.group.notify(queue: .main) {
            self.tableView.reloadData()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    var tabView: TabView = {
        var tab = TabView()
        return tab
    }()
    
    let behindView = UIView()
    
    private func configureTabView() {
        //        navigationController?.hidesBarsOnSwipe = true
        behindView.backgroundColor = .white
        self.view.addSubview(tabView)
        self.view.addSubview(behindView)
        
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
    }
    
    var priceDelegate: Double?
    
}




extension SharesListViewController: UITableViewDelegate, UITableViewDataSource, PriceDelegate {
    
    func didUpdatePrice(price: Double) {
        //        DispatchQueue.main.async {
        //            self.priceDelegate = price
        //        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quotesList2.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SharesListCell", for: indexPath) as? StockTableViewCell
        //        let quotes = quotesList[indexPath.row]
        var quotes2 = quotesList2[indexPath.row]
        
        
        
        cell?.companyShortNameLabel.text = quotes2
        networkManager.loadCompanyProfile(companyName: quotes2) { result in
            DispatchQueue.main.async {
                cell?.companyFullNameLabel.text = result?.name ?? ""
                let url = URL(string: result?.logo ?? " ")
                let data = try? Data(contentsOf: (url ?? URL(string: "https://finnhub.io/api/logo?symbol=SDGR"))!)
               
                let image = UIImage(data: data!)
                DispatchQueue.main.async {
                    cell?.companyImage.image = image
                }
                print("LOGO: \(result?.logo)")
            }
        }
        
        
        
        networkManager.loadStockPrice(companyName: quotes2) { result in
            DispatchQueue.main.async {
                
                cell?.companyPrice.text = String(result?.c ?? 0)
            }
        }
        
        if indexPath.row % 2 == 0 {
            cell?.backgroundColor = UIColor(red: 0.9412, green: 0.9569, blue: 0.9686, alpha: 1.0)
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

