//
//  FactsTableViewControllerTests.swift
//  FactsAboutCanadaTests
//
//  Created by mrunmaya pradhan on 22/07/18.
//  Copyright © 2018 Self. All rights reserved.
//

import XCTest
@testable import FactsAboutCanada

class FactsTableViewPresenterStub:  FactsTableViewPresenterProtocol {
    var getFactsFromServerCalled = false
    var getFactsImageCalled = false
    
    func getFactsFromServer() {
        getFactsFromServerCalled = true
    }
    
    func getFactsImage(from urlString: String, for cellAtIndexPath: IndexPath) {
        getFactsImageCalled = true
    }
    
}


class NetWorkManagerProtocolStub:  NetWorkManagerProtocol {
    var fetchAllFactsFromServerCalled = false
    var requestImageCalled = false
    
    func fetchAllFacts(completion: @escaping ([Fact]?, String?) -> Void) {
        fetchAllFactsFromServerCalled = true
        let fact1 = Fact(
            title: "test title",
            description:"Some Description",
            imageUrl: "some URL"
        )
        completion([fact1],"Some Title")
    }
    
    func requestImage(path: String, completionHandler: @escaping (UIImage) -> Void) {
        requestImageCalled = true
        let image1 = getImageWithColor(color: .blue, size: CGSize.init(width: 20, height: 20))
        completionHandler(image1)
    }
    
}

class FactsTableViewControllerTests: XCTestCase {
    var sut: FactsTableViewController!
    var presenterStub: FactsTableViewPresenterStub!
    var netWorkManagerProtocolStub: NetWorkManagerProtocolStub!
    override func setUp() {
        super.setUp()
        presenterStub = FactsTableViewPresenterStub()
        netWorkManagerProtocolStub = NetWorkManagerProtocolStub()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: "FactsTableViewController") as? FactsTableViewController
        sut.presenter = presenterStub
        sut.networkManager = netWorkManagerProtocolStub
        
        
    }
    
    override func tearDown() {
        presenterStub = nil
        netWorkManagerProtocolStub = nil
        sut = nil
        super.tearDown()
    }
    
    func testCustomTableView() {
        sut.presenter = presenterStub
        sut.setUpCustomTableView()
        XCTAssertNotNil(sut.factsTableView)
    }
    
    func testUpdateTableViewWithFacts() {
        sut.setUpCustomTableView()
        
        let fact1 = Fact(
            title: "test title",
            description:"Some Description",
            imageUrl: "some URL"
        )
        sut.facts?.append(fact1)
        sut.updateTableView(with: [fact1])
        
        let noOfRows =  sut.factsTableView?.numberOfRows(inSection: 0)
        XCTAssertEqual(noOfRows, 1)
        
        let fact2 = Fact(
            title: "test title 2",
            description:"Some Description2",
            imageUrl: "some URL2"
        )
        sut.facts?.append(fact2)
        sut.updateTableView(with: [fact1,fact2])
        
        let noOfRows2 =  sut.factsTableView?.numberOfRows(inSection: 0)
        XCTAssertEqual(noOfRows2, 2)
        
        let indexPath = IndexPath(row: 0, section: 0)
        let cell1 = sut.factsTableView?.cellForRow(at: indexPath) as? FactsTableViewCell
        XCTAssertEqual(cell1?.factTitleLabel.text, "test title")
        XCTAssertEqual(cell1?.factDetailLabel.text, "Some Description")
        
        let indexPath2 = IndexPath(row: 1, section: 0)
        let cell2 = sut.factsTableView?.cellForRow(at: indexPath2) as? FactsTableViewCell
        XCTAssertEqual(cell2?.factTitleLabel.text, "test title 2")
        XCTAssertEqual(cell2?.factDetailLabel.text, "Some Description2")
        
    }
    
    
    
    func testUpdateTableViewCellImageWithImage() {
        sut.setUpCustomTableView()
        
        let fact1 = Fact(
            title: "test title",
            description:"Some Description",
            imageUrl: "some URL"
        )
        sut.facts?.append(fact1)
        sut.updateTableView(with: [fact1])
        
        
        let indexPath = IndexPath(row: 0, section: 0)
        let image1 = getImageWithColor(color: .blue, size: CGSize.init(width: 20, height: 20))
        sut.updateCell(with: image1, at: indexPath)
        let cell1 = sut.factsTableView?.cellForRow(at: indexPath) as? FactsTableViewCell
        XCTAssertEqual(cell1?.factTitleLabel.text, "test title")
        XCTAssertEqual(cell1?.factDetailLabel.text, "Some Description")
        let cellImage = cell1?.imageView?.image
        XCTAssertEqual(cellImage, image1)
        
        
    }
    
    
}

//helper method to create image with color
func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
    let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    color.setFill()
    UIRectFill(rect)
    let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return image
}
