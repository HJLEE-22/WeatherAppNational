//
//  BulletinBoardViewController.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2023/01/17.
//

import UIKit
import SnapKit


class BulletinBoardViewController: UIViewController {
    
    // MARK: - Properties
    
        // MARK:  Models
    
    var weatherKitModel: WeatherKitModel?
    
    var backgroundGradientLayer: CAGradientLayer?
    
        // MARK:  Other Properties
    
    let bulletinBoardView = BulletinBoardView()

    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setBulletinBoardView()
        setCells()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupBackgroundLayer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.backgroundGradientLayer?.removeFromSuperlayer()
    }


    // MARK: - Helpers
    
    func setupBackgroundLayer() {
        DispatchQueue.main.async {
            if let backgroundGradientLayer = self.backgroundGradientLayer {
                backgroundGradientLayer.frame = CGRect(x: 0, y: -59, width: 500, height: 103)
                self.navigationController?.navigationBar.layer.addSublayer(backgroundGradientLayer)
            }
        }
    }

    
    func setBulletinBoardView() {
        self.view.addSubview(bulletinBoardView)
        bulletinBoardView.snp.makeConstraints { make in
            make.right.left.top.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalTo(self.view)
        }
        
    }
    
    func setCells() {
        bulletinBoardView.chattingsTableView.delegate = self
        bulletinBoardView.chattingsTableView.dataSource = self
        bulletinBoardView.chattingsTableView.register(UserChatCell.self, forCellReuseIdentifier: "UserChatCell")
        bulletinBoardView.chattingsTableView.register(OthersChatCell.self, forCellReuseIdentifier: "OthersChatCell")
        bulletinBoardView.chattingsTableView.estimatedRowHeight = 70
        bulletinBoardView.chattingsTableView.rowHeight = UITableView.automaticDimension
        bulletinBoardView.chattingsTableView.separatorStyle = .none
    }
}


extension BulletinBoardViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "OthersChatCell", for: indexPath) as! OthersChatCell
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "OthersChatCell", for: indexPath) as! OthersChatCell
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserChatCell", for: indexPath) as! UserChatCell
            return cell
        default:
            break
        }
        return UITableViewCell()
        
    }
}

extension BulletinBoardViewController: UITextFieldDelegate {
    
}
