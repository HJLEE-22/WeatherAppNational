//
//  SettingViewController.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2022/10/17.
//
import UIKit
import CoreLocation
import SafariServices
import MessageUI
import FirebaseAuth

final class SettingViewController: UITableViewController {
    
    // MARK: - Properties
    
    private let profileCell = ProfileCell()
    
    private var nickname: String? {
        didSet {
            tableView.reloadSections(IndexSet(0...0), with: .automatic)
        }
    }
    
    private var email: String? {
        didSet {
            tableView.reloadSections(IndexSet(0...0), with: .automatic)
        }
    }

    private var locationManager = CLLocationManager()

    private var settingViewModel = SettingViewModel()

    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.setupNav()
        self.setupProfile()

    }
    
    // MARK: - Helpers
    
    private func setupProfile() {
        guard let currentUser = Auth.auth().currentUser else { return }
        let uid = currentUser.uid
        self.email = currentUser.email
        collectionUsers.document(uid).getDocument { (document, error) in

            if let document = document, document.exists {
                let documentData = document.data().map { data in
                    self.nickname = data["name"] as? String
                    self.email = data["email"] as? String
                }
            } else {
                self.nickname = "  🦹 익명"
                self.email = "로그인을 원하시면 터치하세요"
                print("Document does not exist")
            }
        }
    }
    
    private func setupNav() {
        self.navigationItem.title = "Settings"
        let backButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(setupNavPopVCAnimation))
        self.navigationItem.setLeftBarButton(backButtonItem, animated: true)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingViewCell.self, forCellReuseIdentifier: CellID.forSettingsCell)
        tableView.register(ProfileCell.self, forCellReuseIdentifier: CellID.forProfileCell)
        tableView.estimatedRowHeight = 30
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .singleLine
    }
    
    @objc private func setupNavPopVCAnimation() {
            let transition = CATransition()
            transition.duration = 0.3
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromRight
            navigationController?.view.layer.add(transition, forKey: kCATransition)
            self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - TableviewDatasource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0 :
            return "프로필"
        case 1 :
            return "현재위치정보"
        case 2 :
            return "개인정보 처리방침"
        case 3 :
            return "개발자 문의하기"
        case 4 :
            return " Weather"
        case 5 :
            return ""
        default :
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let settingViewCell = tableView.dequeueReusableCell(withIdentifier: CellID.forSettingsCell, for: indexPath) as! SettingViewCell
        let profileCell = tableView.dequeueReusableCell(withIdentifier: CellID.forProfileCell, for: indexPath) as! ProfileCell
        switch indexPath.section {
        case 0 :
            profileCell.nicknameLabel.text = self.nickname
            profileCell.emailLabel.text = self.email
            return profileCell
        case 1 :
            settingViewCell.mainLabel.text = "사용가능"
            settingViewCell.switchBtn.isEnabled = true
            settingViewCell.switchBtn.isHidden = false
            settingViewCell.selectionStyle = .none
            settingViewCell.switchBtn.isOn = settingViewModel.isSwitchButtonOn
            settingViewCell.cellDelegate = self
        case 2 :
            settingViewCell.mainLabel.text = "링크"
        case 3:
            settingViewCell.mainLabel.text = "leehyungju20@gmail.com"
        case 4 :
            settingViewCell.mainLabel.text = "WeatherKit - Data Sources"
        case 5 :
            settingViewCell.mainLabel.text = ""
            settingViewCell.logoutView.isHidden = false
            settingViewCell.selectionStyle = .none
            settingViewCell.logoutView.setOpaqueTapGestureRecognizer { [weak self] in
                // logout code
                self?.showAlert("Log-Out", "로그아웃 하시겠습니까?", self?.firebaseAuthSignout)
            }
        case 6 :
            settingViewCell.mainLabel.text = ""
            settingViewCell.deleteAccountView.isHidden = false
            settingViewCell.deleteAccountView.setOpaqueTapGestureRecognizer { [weak self] in
                self?.showAlert("회원탈퇴 하시겠습니까?", "본 앱에서 계정이 삭제됩니다.\n설정의 '애플 ID를 사용하는 앱'에서 본 앱을 제거해 주세요.", self?.firebaseDeleteAccount)
            }
            settingViewCell.selectionStyle = .none
            settingViewCell.logoutView.setOpaqueTapGestureRecognizer {
                
            }
        default:
            break
        }
        
        return settingViewCell
  
    }
    
    func firebaseAuthSignout() {
        FirebaseAuthentication.shared.signOut()
    }
    
    func firebaseDeleteAccount() {
        FirebaseAuthentication.shared.deleteAccount()
    }
    
    // MARK: - TableviewDelegates
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if !UserDefaults.standard.bool(forKey: UserDefaultsKeys.isUserDataExist) {
                setLoginViewAnywhere()
            }
        case 2:
            let personalInformationUrl = "https://thread-pike-aca.notion.site/4a2cacda469448ba836d9d9d572b1b02"
            openSFSafari(url: personalInformationUrl)
        case 3:
            guard let email else { return }
            sendEmail(self: self, userEmail: email, nil, nil, {})
        case 4:
            let weatherKitPolicyUrl = "https://weatherkit.apple.com/legal-attribution.html"
            openSFSafari(url: weatherKitPolicyUrl)
        default:
            break
        }
    }
}

extension SettingViewController: SwitchButtonDelegate {
    
    func gpsSwitchTapped() {
        if settingViewModel.isSwitchButtonOn {
            showAlert("위치 정보 이용", "위치 서비스를 중단하시겠습니까?\n디바이스의 '설정 > 개인정보 보호'에서 위치 서비스를 꺼주세요.", requestLocationServiceToSettings)
        } else {
            showAlert("위치 정보 이용", "위치 서비스를 사용하시겠습니까?\n디바이스의 '설정 > 개인정보 보호'에서 위치 서비스를 켜주세요.", requestLocationServiceToSettings)
        }
    }
    
    func requestLocationServiceToSettings() {
        if let appSetting = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(appSetting)
        }
    }
}

extension SettingViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
           controller.dismiss(animated: true, completion: nil)
       }

}


