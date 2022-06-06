//
//  ViewController.swift
//  CardGameDemo
//
//  Created by TELOLAHY Hugues Stéphano on 30/05/2022.
//

import UIKit
import CardGameMechanics

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        _ = Cards.getAll(type: .playable)
    }
}
