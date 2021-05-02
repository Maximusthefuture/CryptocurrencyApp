//
//  FavouriteListViewController.swift
//  StockSharesApp
//
//  Created by Maximus on 02.03.2021.
//

import UIKit
import SwiftUI

class DetailViewController: UIViewController {
    
    
    var label: UILabel = UILabel()
    var model: Model?
    var button: UIButton = UIButton()
    var tabView = TabView()
    let behindView = UIView()
    var favourite: UIBarButtonItem?
    
    fileprivate func configureLabel() {
        view.addSubview(label)
        label.textColor = .red
        label.text = model?.name
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configuresView()
        self.view.backgroundColor = .white
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = true
        modifyBackButton()
        self.navigationItem.setTitle(title: model!.ticker, subtitle: model!.name)
        configureLabel()
//        configureTabView()
        self.navigationItem.rightBarButtonItem = favourite
        configureButton()
       
        
    }
    @objc func isFavourite(_ selector: UIButton) -> Bool {
        print("isFavourite")
        return model!.isFavourite ? selector.isSelected : !selector.isSelected
    }
    
    
    
    func modifyBackButton() {
        let backButtonBackgroundImage = UIImage(named: "back_button")
        self.navigationController?.navigationBar.backIndicatorImage = backButtonBackgroundImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backButtonBackgroundImage
        self.navigationController?.navigationBar.tintColor = .black
        
        let backBarButtton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backBarButtton
       
    }
    
    private func configuresView() {
        let uiButton = UIButton()
        uiButton.setImage(UIImage(named:"Star_black"), for: .normal)
        uiButton.setImage(UIImage(named:"FavouriteFilled"), for: .selected)
        uiButton.isSelected = model!.isFavourite
        uiButton.target(forAction: #selector(isFavourite(_:)), withSender: self)
         favourite = UIBarButtonItem.init(customView: uiButton)
    }
    
    func configureButton() {
        let button = UIButton()
        self.view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        let guide = view.safeAreaLayoutGuide
//        button.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
////        button.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
        button.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: 100).isActive = true
//        button.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
      
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setTitle("Buy for \(model?.formattedPrice()!)", for: .normal)
       
       
        
        
       
    }
    
    private func configureTabView() {
        behindView.backgroundColor = .white
        self.view.addSubview(tabView)
        self.view.addSubview(behindView)
//        tabView.delegate = self
        let guide = view.safeAreaLayoutGuide
        behindView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 60, enableInsets: true, identifier: "behindView")
        behindView.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        behindView.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
        tabView.translatesAutoresizingMaskIntoConstraints = false
        tabView.backgroundColor = .white
        tabView.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        tabView.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        tabView.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
        tabView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
    }
}

extension UINavigationItem {
    func setTitle(title: String, subtitle: String) {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.text = title
        titleLabel.sizeToFit()
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = subtitle
        subtitleLabel.font = UIFont.systemFont(ofSize: 12)
        subtitleLabel.textAlignment = .center
        subtitleLabel.sizeToFit()
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.distribution = .equalCentering
        stackView.alignment = .center
        stackView.axis = .vertical
        let width = max(titleLabel.frame.width, subtitleLabel.frame.width)
        stackView.frame = CGRect(x: 0, y: 0, width: width, height: 50)
//        stackView.addSubview(self.titleView)
        titleLabel.sizeToFit()
        subtitleLabel.sizeToFit()
        self.titleView = stackView
    }
}

#if DEBUG
struct ContentViewControllerContainerView:
    UIViewControllerRepresentable {
    
    typealias UIViewControllerType = DetailViewController
    
    func makeUIViewController(context: Context) -> UIViewControllerType {
        return DetailViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

struct ContentViewController_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
        ContentViewControllerContainerView().colorScheme(.light)
        }// or .dark
    }
}
#endif



