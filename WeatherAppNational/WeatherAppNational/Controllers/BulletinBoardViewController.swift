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

    let bulletinBoardView = BulletinBoardView()

    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setBulletinBoardView()
        setCells()
    }
    
    // MARK: - Helpers
    
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
