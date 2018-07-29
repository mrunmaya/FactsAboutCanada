//
//  ViewController.swift
//  FactsAboutCanada
//
//  Created by mrunmaya pradhan on 21/07/18.
//  Copyright © 2018 Self. All rights reserved.
//

import UIKit

protocol FactsTableViewControllerProtocol: class {
    func updateCell(with image: UIImage,at indexPath: IndexPath)
    func updateTableView(with facts: [Fact]?)
    func updateNavigationBarTitle(with title: String?)
    func showConnetionRequiredAlert(message: String)
}

class FactsTableViewController: UIViewController, FactsTableViewControllerProtocol {
    
    var presenter: FactsTableViewPresenterProtocol?
    var networkManager:  NetWorkManagerProtocol?
    var factsTableView: UITableView?
    var facts: [Fact]?
    private var navBarTitle: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCustomTableView()
        setCustomNavigationBar(with: "About Canada")
        presenter = FactsTableViewPresenter(factsViewController: self, networkManager: NetworkManager.sharedInstance)
        presenter?.getFactsFromServer()
    }

    // Setup TableView
    func setUpCustomTableView() {
        let topBarHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        factsTableView = UITableView(frame: CGRect(x: 0, y: topBarHeight+44 , width: self.view.frame.width, height: self.view.frame.height - topBarHeight - 44))
        factsTableView?.register(UITableViewCell.self, forCellReuseIdentifier: "tableViewCell")
        factsTableView?.dataSource = self
        factsTableView?.delegate = self
        if let tableview = factsTableView {
            self.view.addSubview(tableview)
        }
    }
    
    // Setup top navigation Bar
    func setCustomNavigationBar(with title: String?) {
        let topBarHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        
        let screenSize: CGRect = UIScreen.main.bounds
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: topBarHeight, width: screenSize.width, height: 44))
        if let title = title {
            let navItem = UINavigationItem(title: title)
            let refreshItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.refresh, target: nil, action: #selector(refresh))
            navItem.rightBarButtonItem = refreshItem
            navBar.setItems([navItem], animated: false)
        }

        navBar.backgroundColor = UIColor.blue
        self.view.addSubview(navBar)
    }

    @objc func refresh() {
        self.factsTableView?.reloadData()
    }

    func updateTableView(with facts: [Fact]?) {
        if let facts = facts {
            self.facts = facts.filter{($0.title != nil || $0.description != nil || $0.imageUrl != nil)}
            self.factsTableView?.reloadData()
        }
    }

    func updateNavigationBarTitle(with title: String?) {
        guard let title = title else { return }
        setCustomNavigationBar(with: title)
    }
    
    func updateCell(with image: UIImage,at indexPath: IndexPath) {
        let cell = self.factsTableView?.cellForRow(at: indexPath)
        cell?.imageView?.image = image
        cell?.setNeedsLayout()
    }

    func showConnetionRequiredAlert(message: String) {
        let alertController = UIAlertController(title: "Sorry", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }

}

extension FactsTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let facts = facts else { return 0 }
        return facts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle,
                                   reuseIdentifier: "tableViewCell")
        guard let facts = self.facts else { return cell}
        
        if let title = facts[indexPath.row].title {
            cell.textLabel?.text = title
        }
        
        if let description = facts[indexPath.row].description {
            cell.detailTextLabel?.text = description
        }
        
        if let imageURL = facts[indexPath.row].imageUrl {
            presenter?.getFactsImage(from: imageURL, for: indexPath)
        }
        
        return cell
    }
}

extension FactsTableViewController: UITableViewDelegate {}

