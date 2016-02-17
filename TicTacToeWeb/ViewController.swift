//
//  ViewController.swift
//  TicTacToeWeb
//
//  Created by Klaus Villaca on 2/9/16.
//  Copyright © 2016 Klaus Villaca. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        callServiceTest()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func callServiceTest() {
        let jsonUtils: JSONUtils = JSONUtils()
        var userTemp: User!
        jsonUtils.callRequestForUserServices(name: "Klaus7", method: Constants.PUT_METHOD, service: Constants.USER_CREATE, controller: self, completionHandler: { (result, errorString) -> Void in
            if let errorMessage = errorString  {
                print(errorMessage)
            } else {
                userTemp = result
                print(userTemp)
            }
        })
    }

}

