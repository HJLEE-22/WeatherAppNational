//
//  SecondWelcomeViewController.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2023/03/21.
//

import SnapKit

protocol SecondNextButtonTappedDelegate: AnyObject {
    func moveToMain()
}

final class SecondWelcomeViewController: UIViewController {
    
    
    // MARK: - Properties
    
    private let secondView = SecondWelcomeView()
    
    weak var delegate: SecondNextButtonTappedDelegate?

    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        setupUI()
        setNextButtonAction()
    }
    
    
    // MARK: - Helpers
    
    private func setNextButtonAction() {
        secondView.nextPageButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    @objc func nextButtonTapped() {
        delegate?.moveToMain()
    }
    
    private func setupUI() {
        view.addSubview(secondView)
        secondView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.bottom.equalTo(view.snp.bottom)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }
    }
    
}
