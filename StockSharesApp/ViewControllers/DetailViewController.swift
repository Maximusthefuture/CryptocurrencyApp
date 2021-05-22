//  StockSharesApp
//
//  Created by Maximus on 02.03.2021.
//

import UIKit
import SwiftUI
import Charts

class DetailViewController: UIViewController {
    
    var label: UILabel = UILabel()
    var model: Model?
    var buyButton: UIButton!
    var tabView = TabView()
    let behindView = UIView()
    var favourite: UIBarButtonItem?
    var newsVC = NewsViewController()
    var chartView = LineChartView()
    var chooseButtonStackView: UIStackView!
    var networkManager = NetworkManager(provider: FinhubDataProvider())
    var detailModel: DetailModel?
    let detailTabView = DetailTabView()
    var navController = UINavigationController(rootViewController: NewsViewController())
    
    var chartDataEntry: [ChartDataEntry] = [
        ChartDataEntry(x: 1, y: 2),
        ChartDataEntry(x: 2, y: 10),
        ChartDataEntry(x: 3, y: 8),
        ChartDataEntry(x: 4, y: 15),
        ChartDataEntry(x: 5, y: 18),
        ChartDataEntry(x: 6, y: 3),
        ChartDataEntry(x: 7, y: 44),
        ChartDataEntry(x: 8, y: 9),
        ChartDataEntry(x: 9, y: 10)
        
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationItem.setTitle(title: model!.ticker, subtitle: model!.name)
        detailModel = DetailModel()
        configureFavouriteButton()
        self.navigationItem.rightBarButtonItem = favourite
        modifyBackButton()
        configureBuyButton()
        chooseButtonConfig()
        configureTabView()
        configureChartView()
        setData()
        
        
        
    }
    
    func setData() {
        let set1 = LineChartDataSet(entries: chartDataEntry, label: "some label")
        set1.mode = .cubicBezier
        set1.drawCirclesEnabled = false
        set1.lineWidth = 3
        set1.setColor(.black)
        let data = LineChartData(dataSet: set1)
        chartView.data = data
    }
    
    fileprivate func configureLabel() {
        view.addSubview(label)
        label.textColor = .red
        label.text = model?.name
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    func configureChartView() {
        view.addSubview(chartView)
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        chartView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        chartView.bottomAnchor.constraint(equalTo: chooseButtonStackView.topAnchor, constant: -40).isActive = true
        chartView.topAnchor.constraint(equalTo: detailTabView.topAnchor, constant: 40).isActive = true
        chartView.backgroundColor = .systemBlue
    }
    var chooseButton = [UIButton]()
    
    @objc func chooseDate(sender: UIButton) {
        chooseButton.forEach { (button) in
            button.backgroundColor = .black
        }
        sender.backgroundColor = .red
        let type = detailModel!.getSelectedDateType(buttons: chooseButton)
        print(type)
        print(sender.title(for: .normal)!)
    }
    
    func chooseButtonConfig() {
        let day = ["D", "W", "M", "6M","Y", "All"]
        
        var button: UIButton?
        
        chooseButtonStackView = UIStackView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100))
        self.view.addSubview(chooseButtonStackView)
        chooseButtonStackView.axis = .horizontal
        chooseButtonStackView.spacing = 10.0
        chooseButtonStackView.distribution = .fillEqually
        chooseButtonStackView.alignment = .fill
        
        for (index, i) in day.enumerated() {
            button = UIButton()
            button!.frame = CGRect(x: 0, y: 0, width: 42, height: 44)
            chooseButton.append(button!)
            button!.setTitle(i, for: .normal)
        }
        
        chooseButton[5].backgroundColor = .red
        chooseButton.forEach { (button) in
            
            button.addTarget(self, action: #selector(chooseDate(sender:)), for: .touchUpInside)
            button.backgroundColor = .black
            button.layer.cornerRadius = 12
            
            chooseButtonStackView.addArrangedSubview(button)
        }
        chooseButtonStackView.translatesAutoresizingMaskIntoConstraints = false
        chooseButtonStackView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        chooseButtonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        chooseButtonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        chooseButtonStackView.bottomAnchor.constraint(equalTo: self.buyButton.topAnchor, constant: -52).isActive = true
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
    
    private func configureFavouriteButton() {
        let favouriteButton = UIButton()
        favouriteButton.setImage(UIImage(named:"Star_black"), for: .normal)
        favouriteButton.setImage(UIImage(named:"FavouriteFilled"), for: .selected)
        favouriteButton.isSelected = model!.isFavourite
        favouriteButton.target(forAction: #selector(isFavourite(_:)), withSender: self)
        favourite = UIBarButtonItem.init(customView: favouriteButton)
    }
    
    func configureBuyButton() {
        let button: UIButton = {
            let button = UIButton()
            button.layer.cornerRadius = 16
            button.titleLabel?.font = .systemFont(ofSize: 16)
            return button
        }()
        //        let button = UIButton()
        buyButton = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 56))
        self.view.addSubview(buyButton)
        buyButton.layer.cornerRadius = 16
        buyButton.translatesAutoresizingMaskIntoConstraints = false
        let guide = view.safeAreaLayoutGuide
        buyButton.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -20).isActive = true
        buyButton.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 16).isActive = true
        buyButton.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -16).isActive = true
        buyButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        buyButton.setTitleColor(.white, for: .normal)
        buyButton.backgroundColor = .black
        buyButton.setTitle("Buy for \(model!.formattedPrice()!)", for: .normal)
    }
    
    private func configureTabView() {
        behindView.backgroundColor = .white
        self.view.addSubview(detailTabView)
        let guide = view.safeAreaLayoutGuide
        detailTabView.tabDelegate = self
        detailTabView.addToSubView(titles: ["Chart", "Summary","News","Forecasts", "Ideas"])
        detailTabView.translatesAutoresizingMaskIntoConstraints = false
        detailTabView.backgroundColor = .white
        detailTabView.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        detailTabView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 20).isActive = true
        detailTabView.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
        detailTabView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
}

extension DetailViewController: TabDelegate {
    
    func tabClicked(option: TabOptions) {
        switch option {
        case .one:
            break
        case .two:
            break;
        case .three:
            self.navigationController?.present(navController, animated: true, completion: nil)
        case .four:
            break
        case .five:
            break
        case .six:
            break
        }
        print("tab is: \(option)")
    }
    
}

extension DetailViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
    }
}



//MARK: SwiftUI preview
#if DEBUG
struct ContentViewControllerContainerView:
    UIViewControllerRepresentable {
    
    typealias UIViewControllerType = DetailViewController
    
    func makeUIViewController(context: Context) -> UIViewControllerType {
        DetailViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

struct ContentViewController_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewControllerContainerView()
    }
}
#endif



