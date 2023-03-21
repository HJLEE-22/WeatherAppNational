//
//  FirstWelcomeViewController.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2023/03/21.
//

import SnapKit

final class FirstWelcomeViewController: UIViewController {
    
    
    // MARK: - Properties
    
    let firstView = FirstWelcomeView()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        setupUI()
    }
    
    
    // MARK: - Helpers
    
    private func setupUI() {
        view.addSubview(firstView)
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    
}
