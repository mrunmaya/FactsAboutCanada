//
//  FactsTableViewPresenter.swift
//  FactsAboutCanada
//
//  Created by mrunmaya pradhan on 22/07/18.
//  Copyright © 2018 Self. All rights reserved.
//

import UIKit
protocol FactsTableViewPresenterProtocol: class {
    func getFactsFromServer()
    func getFactsImage(from urlString: String, for cellAtIndexPath: IndexPath)
    
}

class FactsTableViewPresenter: FactsTableViewPresenterProtocol {
    
    var factsViewControler: FactsTableViewControllerProtocol?
    var networkManager:  NetWorkManagerProtocol?

    init(factsViewController: FactsTableViewControllerProtocol,networkManager: NetWorkManagerProtocol?) {
        self.factsViewControler = factsViewController
        self.networkManager = networkManager
    }
    
    // Get Facts Data using NetworkManager API
    func getFactsFromServer() {
        guard Reachability.isConnectedToNetwork() else {
            self.factsViewControler?.showConnetionRequiredAlert(message:"Internet Connection is required")
            return
        }

        DispatchQueue.global(qos: .userInteractive).async() {
            self.networkManager?.fetchAllFacts {[weak self] facts,title  in
                guard let facts = facts else {
                     self?.factsViewControler?.showConnetionRequiredAlert(message:"We couldn't get any facts")
                    return
                }
                DispatchQueue.main.async {
                    self?.factsViewControler?.updateNavigationBarTitle(with: title)
                    self?.factsViewControler?.updateTableView(with: facts)
                }
            }
        }
    }
    
    // Get Facts Image Data using NetworkManager API
    func getFactsImage(from urlString: String, for cellAtIndexPath: IndexPath) {
        DispatchQueue.global(qos: .userInteractive).async() {[weak self] in
            self?.networkManager?.requestImage(path:urlString, completionHandler: {[weak self] image in
                DispatchQueue.main.async {
                    self?.factsViewControler?.updateCell(with: image,at: cellAtIndexPath)
                }
            })
        }
    }
    
    
}
