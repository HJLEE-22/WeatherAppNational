//
//  BulletinBoardViewController.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2023/01/17.
//

import UIKit


class BulletinBoardViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Helpers
    
    func setupView() {
        let bulletinBoardView = BulletinBoardView()
        self.view.addSubview(bulletinBoardView)
    }


    
}
