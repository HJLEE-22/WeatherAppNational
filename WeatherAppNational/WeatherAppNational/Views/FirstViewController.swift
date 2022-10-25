
//
//  FirstViewController.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2022/10/17.
//


import UIKit

class FirstViewController: UIViewController {
    
    let mainView = MainView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .green
        setupUI()
    }
    
    
    func setupUI() {
        self.view.addSubview(mainView)
        mainView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            
        ])
        
        
        
    }
    
    
}
