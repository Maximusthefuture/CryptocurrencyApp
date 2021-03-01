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
    
    var modelList: [Model] = [Model]()
  
    
    override func viewDidLoad() {
       
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.sizeToFit()
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        self.navigationItem.searchController = searchController
        let titleLable = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLable.text = "HOME"
        navigationController?.navigationBar.isTranslucent = false
        configureTabView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.hidesBarsOnSwipe = true
    }
    
    
    var tabView: TabView = {
        var tab = TabView()
        return tab
    }()
    
    private func configureTabView() {
        self.view.addSubview(tabView)
        let guide = view.safeAreaLayoutGuide
        tabView.translatesAutoresizingMaskIntoConstraints = false
        tabView.backgroundColor = .red
        tabView.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        tabView.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        tabView.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
        tabView.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y > 0 {
            UIView.animate(withDuration: 0.4, animations: {
                self.navigationController?.setNavigationBarHidden(true, animated: true)
            }, completion: nil)
        }
    }

    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        configureTableView()
        createDummyList()
    }

    
    func createDummyList() {
        modelList.append(Model(title: "YAND", subtitle: "Yandex, LLC",image: #imageLiteral(resourceName: "YNDX"), price: 4769.6, changePrice: "+0.55(1,15%)"))
        modelList.append(Model(title: "NTFX", subtitle: "Yandex, LLC",image: #imageLiteral(resourceName: "YNDX"), price: 4769.6, changePrice: "+0.55(1,15%)"))
        modelList.append(Model(title: "AAPL", subtitle: "Yandex, LLC", price: 4769.6, changePrice: "+0.55(1,15%)"))
        modelList.append(Model(title: "GOOGL", subtitle: "Yandex, LLC", price: 4769.6, changePrice: "+0.55(1,15%)"))
        modelList.append(Model(title: "AMZN", subtitle: "Yandex, LLC", price: 4769.6, changePrice: "+0.55(1,15%)"))
        modelList.append(Model(title: "BAC", subtitle: "Yandex, LLC", price: 4769.6, changePrice: "+0.55(1,15%)"))
        modelList.append(Model(title: "YAND", subtitle: "Yandex, LLC", price: 4769.6, changePrice: "+0.55(1,15%)"))
        modelList.append(Model(title: "YAND", subtitle: "Yandex, LLC", price: 4769.6, changePrice: "+0.55(1,15%)"))
        modelList.append(Model(title: "YAND", subtitle: "Yandex, LLC", price: 4769.6, changePrice: "+0.55(1,15%)"))
    }
   

    func configureTableView() {
        tableView = UITableView()
        view.addSubview(tableView)
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.register(StockTableViewCell.self, forCellReuseIdentifier: "SharesListCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 40).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -8).isActive = true
        tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 8).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -8).isActive = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 120.0
        
    }
}


extension SharesListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SharesListCell", for: indexPath) as? StockTableViewCell
        var stock = modelList[indexPath.row]
        cell?.stock = stock
        if indexPath.row % 2 == 0 {
            cell?.backgroundColor = UIColor(red: 0.9412, green: 0.9569, blue: 0.9686, alpha: 1.0)
        }
        //MARK:TODO forceunwrap ristrict!
        return cell!
    }
}

extension SharesListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        self.tableView.reloadData()
    }
}

