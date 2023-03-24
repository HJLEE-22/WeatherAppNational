//
//  FirstWelcomeViewController.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2023/03/21.
//

import SnapKit

protocol FirstNextButtonTappedDelegate: AnyObject {
    func moveToNextPage()
}

final class FirstWelcomeViewController: UIViewController {
    
    
    // MARK: - Properties
    
    let firstView = FirstWelcomeView()
    
    weak var delegate: FirstNextButtonTappedDelegate?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        setupUI()
        setNextButtonAction()
    }
    
    
    // MARK: - Helpers
    
    private func setNextButtonAction() {
        firstView.nextPageButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    @objc func nextButtonTapped() {
        delegate?.moveToNextPage()
    }
    
    private func setupUI() {
        view.addSubview(firstView)
        firstView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.bottom.equalTo(view.snp.bottom)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }
    }

    
}
