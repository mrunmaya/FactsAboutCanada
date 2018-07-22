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
        DispatchQueue.global(qos: .userInteractive).async() {
            self.networkManager?.fetchAllFacts {[weak self] facts,title  in
                DispatchQueue.main.async {
                    self?.factsViewControler?.updateTableView(with: facts)
                    self?.factsViewControler?.updateNavigationBarTitle(with: title)
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
