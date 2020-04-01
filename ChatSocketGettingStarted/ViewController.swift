//
//  ViewController.swift
//  ChatSocketGettingStarted
//
//  Created by Felipe Petersen on 31/03/20.
//  Copyright © 2020 Felipe Petersen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    
    var users = [[String : AnyObject]]()
//    var nickname: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
////        if nickname == nil {
////            askForNickname()
////        }
//    }

//    func askForNickname() {
//        let alertController = UIAlertController(title: "SocketChat", message: "Please enter a nickname:", preferredStyle: UIAlertController.Style.alert)
//
//        alertController.addTextField(configurationHandler: nil)
//
//        let OKAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (action) -> Void in
//               let textfield = alertController.textFields![0]
//               if textfield.text?.count == 0 {
//                   self.askForNickname()
//               }
//               else {
//                   self.nickname = textfield.text
//
//                SocketIOManager.sharedInstance.connectToServerWithNickname(nickname: self.nickname ?? "", completionHandler: { (userList) -> Void in
//                    DispatchQueue.main.async {
//                        if userList != nil {
//                            self.users = userList!
//                            self.tblUserList.reloadData()
////                            self.tblUserList.hidden = false
//                        }
//                    }
//
//                   })
//               }
//           }
//
//              alertController.addAction(OKAction)
//        present(alertController, animated: true, completion: nil)
//          }

    @IBAction func didTapEntere(_ sender: Any) {
        if let nick = nameTextField.text, nick.isEmpty == false {
            SocketIOManager.sharedInstance.connectToServerWithNickname(nickname: nick) {
                self.performSegue(withIdentifier: "chatSegue", sender: self)
            }
            
        }
    }
}

