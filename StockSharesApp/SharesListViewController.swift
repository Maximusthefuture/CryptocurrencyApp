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
  
    func createSearchBar() {
        searchBar.placeholder = "Find company or ticker"
    }

    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        createSearchBar()
        configureTableView()
        navigationItem.titleView = searchBar
        createDummyList()

//        searchBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        searchBar.bottomAnchor.constraint(equalTo: tableView.topAnchor).isActive = true
//        searchBar.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 8).isActive = true
//        searchBar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: -8).isActive = true
  
    }
    func createDummyList() {
        modelList.append(Model(title: "YAND", subtitle: "Yandex, LLC", price: 4769.6, changePrice: "+0.55(1,15%)"))
        modelList.append(Model(title: "NTFX", subtitle: "Yandex, LLC", price: 4769.6, changePrice: "+0.55(1,15%)"))
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SharesListCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 8).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -8).isActive = true
        tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 8).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -8).isActive = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60.0
    }

}


extension SharesListViewController: UITableViewDelegate, UITableViewDataSource {



    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SharesListCell", for: indexPath)
        cell.textLabel?.text = modelList[indexPath.row].title
        cell.detailTextLabel?.text = modelList[indexPath.row].subtitle
        
        return cell
        
        
        
    }


}

