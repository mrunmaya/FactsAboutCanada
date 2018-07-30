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
        presenter = FactsTableViewPresenter(factsViewController: self, networkManager: NetworkManager.sharedInstance)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpCustomTableView()
        setUpNavigation()
        presenter?.getFactsFromServer()
    }

    // Setup TableView
    func setUpCustomTableView() {
        factsTableView = UITableView(frame: CGRect(x: 0, y: 0 , width: self.view.frame.width, height: self.view.frame.height ))
        if let tableview = factsTableView {
            self.view.addSubview(tableview)
        }

        factsTableView?.translatesAutoresizingMaskIntoConstraints = false
        factsTableView?.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        factsTableView?.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        factsTableView?.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        factsTableView?.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true

        factsTableView?.register(FactsTableViewCell.self, forCellReuseIdentifier: "tableViewCell")
        factsTableView?.dataSource = self
        factsTableView?.delegate = self

    }

    func setUpNavigation() {
        navigationItem.title = "About Canada"
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        let refreshItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.refresh, target: self, action: #selector(refresh))
        navigationItem.rightBarButtonItem = refreshItem
    }

    // Setup top navigation Bar
    func setCustomNavigationBar(with title: String?) {
        navigationItem.title = title
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
        self.navigationItem.title = title
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

        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! FactsTableViewCell

        guard let facts = self.facts else { return cell}

        if let title = facts[indexPath.row].title {
            cell.factTitleLabel.text = title
        }
        
        if let description = facts[indexPath.row].description {
            cell.factDetailLabel.text = description
        }
        
        if let imageURL = facts[indexPath.row].imageUrl {
            presenter?.getFactsImage(from: imageURL, for: indexPath)
        }
        
        return cell
    }
}

extension FactsTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

