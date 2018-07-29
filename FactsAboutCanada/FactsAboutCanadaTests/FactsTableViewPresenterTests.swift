//
//  FactsTableViewPresenterTests.swift
//  FactsAboutCanadaTests
//
//  Created by mrunmaya pradhan on 22/07/18.
//  Copyright © 2018 Self. All rights reserved.
//

import XCTest
@testable import FactsAboutCanada

class FactsTableViewControllerStub:  FactsTableViewControllerProtocol {


    var updateCellCalled = false
    var updateTableViewCalled = false
    var updateNavigationBarTitleCalled = false
    var showConnetionRequiredAlertCalled = false
    var asyncExpectation: XCTestExpectation?
    var navigationTitle = "Before Facts"
    var facts: [Fact]?
    var indexPath : IndexPath?
    var image: UIImage?


    func updateCell(with image: UIImage, at indexPath: IndexPath) {
        updateCellCalled = true
        self.image = getImageWithColor(color: .blue, size: CGSize.init(width: 20.0, height: 20.0))
        self.indexPath = indexPath
        asyncExpectation?.fulfill()
    }

    func updateTableView(with facts: [Fact]?) {
        updateTableViewCalled = true
        self.facts = facts
    }

    func updateNavigationBarTitle(with title: String?) {
        updateNavigationBarTitleCalled = true
        navigationTitle = "After facts"
        asyncExpectation?.fulfill()
    }
    func showConnetionRequiredAlert(message: String) {
        showConnetionRequiredAlertCalled = true
    }
}

class FactsTableViewPresenterTests: XCTestCase {
    
    var sut: FactsTableViewPresenter!
    var viewControllerStub: FactsTableViewControllerStub!
    var netWorkManagerProtocolStub: NetWorkManagerProtocolStub!

    override func setUp() {
        super.setUp()
        viewControllerStub = FactsTableViewControllerStub()
        netWorkManagerProtocolStub = NetWorkManagerProtocolStub()
        sut = FactsTableViewPresenter(factsViewController: viewControllerStub, networkManager: netWorkManagerProtocolStub)
    }
    
    override func tearDown() {
        viewControllerStub = nil
        netWorkManagerProtocolStub = nil
        sut = nil
        super.tearDown()
    }
    
    func testGetFactsFromServer() {
        XCTAssertEqual(self.viewControllerStub.navigationTitle, "Before Facts")
        XCTAssertNil(self.viewControllerStub.facts)

        viewControllerStub.asyncExpectation = expectation(description: "asyncExpectation")
        sut.getFactsFromServer()

        waitForExpectations(timeout: 2) { _ in
            XCTAssertTrue(self.viewControllerStub.updateTableViewCalled)
            XCTAssertTrue(self.viewControllerStub.updateNavigationBarTitleCalled)
            XCTAssertEqual(self.viewControllerStub.navigationTitle, "After facts")
            XCTAssertNotNil(self.viewControllerStub.facts)
            XCTAssertEqual(self.viewControllerStub.facts?.count, 1)
        }
    }

    func testGetFactsImage() {
        XCTAssertNil(self.viewControllerStub.indexPath)
        XCTAssertNil(self.viewControllerStub.image)

        viewControllerStub.asyncExpectation = expectation(description: "asyncExpectation2")
        let indexPath = IndexPath(row: 0, section: 0)
        sut.getFactsImage(from: "Some URL", for: indexPath)

        waitForExpectations(timeout: 2) { _ in
            XCTAssertNotNil(self.viewControllerStub.indexPath)
            XCTAssertNotNil(self.viewControllerStub.image)

            XCTAssertTrue(self.viewControllerStub.updateCellCalled)
            XCTAssertEqual(self.viewControllerStub.image?.size,CGSize.init(width: 20.0, height: 20.0))
        }
    }
}
