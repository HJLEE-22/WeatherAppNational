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

class SettingViewController: UITableViewController {
    
    // MARK: - Properties
    
    let profileCell = ProfileCell()
    
    var nickname: String? {
        didSet {
            tableView.reloadSections(IndexSet(0...0), with: .automatic)
        }
    }
    
    var email: String? {
        didSet {
            tableView.reloadSections(IndexSet(0...0), with: .automatic)
        }
    }
//    var anonymousText: String? {
//        didSet {
//            tableView.reloadSections(IndexSet(0...0), with: .automatic)
//        }
//    }
    var locationManager = CLLocationManager()

    private var settingViewModel = SettingViewModel()

    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.setupNav()
        self.setupProfile()

    }
    
    // MARK: - Helpers
    
    func setupProfile() {
        guard let currentUser = Auth.auth().currentUser else { return }
        let uid = currentUser.uid
        self.email = currentUser.email
        COLLECTION_USERS.document(uid).getDocument { (document, error) in

            if let document = document, document.exists {
                let documentData = document.data().map { data in
                    self.nickname = data["name"] as? String
                    self.email = data["email"] as? String
                }
            } else {
                self.nickname = "  🦹"
                self.email = "익명으로 로그인되었습니다."
                print("Document does not exist")
            }
        }
    }
    
    func setupNav() {
        self.navigationItem.title = "Settings"
        let backButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(setupNavPopVCAnimation))
        self.navigationItem.setLeftBarButton(backButtonItem, animated: true)
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingViewCell.self, forCellReuseIdentifier: CellID.forSettingsCell)
        tableView.register(ProfileCell.self, forCellReuseIdentifier: CellID.forProfileCell)
        tableView.estimatedRowHeight = 30
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .singleLine
    }
    
    @objc func setupNavPopVCAnimation() {
            let transition = CATransition()
            transition.duration = 0.3
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromRight
            navigationController?.view.layer.add(transition, forKey: kCATransition)
            self.navigationController?.popViewController(animated: true)
    }
    
    func openSFSafariForPersonalInformation(_sender: Any) {
        guard let url = URL(string: "https://thread-pike-aca.notion.site/4a2cacda469448ba836d9d9d572b1b02") else { return }
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true, completion: nil)
    }
    
    func openSFSafariForWeatherKit(_sender: Any) {
        guard let url = URL(string: "https://weatherkit.apple.com/legal-attribution.html") else { return }
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true, completion: nil)
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
            
            // 스위치 버튼 상태 업데이트 하는 곳
            print("DEBUG: location status \(CLLocationManager.authorizationStatus() )")
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
            settingViewCell.logoutView.setOpaqueTapGestureRecognizer {
                // logout code
                self.setupLogoutAlert()
            }
        case 6 :
            settingViewCell.mainLabel.text = ""
            settingViewCell.deleteAccountView.isHidden = false
            settingViewCell.deleteAccountView.setOpaqueTapGestureRecognizer {
                self.setupDeleteAccountAlert()
            }
            settingViewCell.selectionStyle = .none
            settingViewCell.logoutView.setOpaqueTapGestureRecognizer {
                
            }
        default:
            break
        }
        
        return settingViewCell
  
    }
    
    func setupLogoutAlert() {
        let requestAlert = UIAlertController(title: "Log-Out", message: "로그아웃 하시겠습니까?" , preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default){ _ in
            FirebaseAuthentication.shared.signOut()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        requestAlert.addAction(ok)
        requestAlert.addAction(cancel)
        present(requestAlert, animated: true)
    }
    
    func setupDeleteAccountAlert() {
        let requestAlert = UIAlertController(title: "회원탈퇴 하시겠습니까?", message: "본 앱에서 계정이 삭제됩니다.\n설정의 '애플 ID를 사용하는 앱'에서 본 앱을 제거해 주세요." , preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default){ _ in
            FirebaseAuthentication.shared.deleteAccount()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        requestAlert.addAction(ok)
        requestAlert.addAction(cancel)
        present(requestAlert, animated: true)
    }
    
    // MARK: - TableviewDelegates
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 2:
            self.openSFSafariForPersonalInformation(_sender: self)
        case 3:
            self.sendEmail()
        case 4:
            self.openSFSafariForWeatherKit(_sender: self)
        default:
            break
        }
    }
}

extension SettingViewController: SwitchButtonDelegate {
    func gpsSwitchTapped() {
        
        // 버튼이 on일때 눌리면 위치정보 거절
        // 버튼이 off일때 눌리면 위치정보 허용
        if settingViewModel.isSwitchButtonOn {
         showRequestDisableLocationServiceAlert()
        } else {
            showRequestEnableLocationServiceAlert()
        }
    }
    
    func showRequestDisableLocationServiceAlert() {
        let requestLocationServiceAlert = UIAlertController(title: "위치 정보 이용", message: "위치 서비스를 중단하시겠습니까?\n디바이스의 '설정 > 개인정보 보호'에서 위치 서비스를 꺼주세요.", preferredStyle: .alert)
        let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
            if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSetting)
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel) { _ in
            
        }
        requestLocationServiceAlert.addAction(cancel)
        requestLocationServiceAlert.addAction(goSetting)
        
        present(requestLocationServiceAlert, animated: true)
    }
    func showRequestEnableLocationServiceAlert() {
        let requestLocationServiceAlert = UIAlertController(title: "위치 정보 이용", message: "위치 서비스를 사용하시겠습니까?\n디바이스의 '설정 > 개인정보 보호'에서 위치 서비스를 켜주세요.", preferredStyle: .alert)
        let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
            if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSetting)
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        requestLocationServiceAlert.addAction(cancel)
        requestLocationServiceAlert.addAction(goSetting)
        
        present(requestLocationServiceAlert, animated: true)
    }
}

extension SettingViewController: MFMailComposeViewControllerDelegate {
    
    func showSendMailErrorAlert() {
           let sendMailErrorAlert = UIAlertController(title: "메일을 전송 실패", message: "아이폰 이메일 설정을 확인하고 다시 시도해주세요.", preferredStyle: .alert)
           let confirmAction = UIAlertAction(title: "확인", style: .default) {
               (action) in
               print("확인")
           }
           sendMailErrorAlert.addAction(confirmAction)
           self.present(sendMailErrorAlert, animated: true, completion: nil)
       }
       
    func sendEmail() {
           if MFMailComposeViewController.canSendMail() {
               
               let compseVC = MFMailComposeViewController()
               compseVC.mailComposeDelegate = self
               
               compseVC.setToRecipients(["leehyungju20@gmail.com"])
               compseVC.setSubject("'어제보다' 문의")
               compseVC.setMessageBody("Message Content", isHTML: false)
               
               self.present(compseVC, animated: true, completion: nil)
               
           }
           else {
               self.showSendMailErrorAlert()
           }
       }
       
       func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
           controller.dismiss(animated: true, completion: nil)
       }
}

