//
//  Extensions.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2023/03/15.
//

import UIKit
import MessageUI

extension UIViewController {
    func showAlert(_ title: String, _ message: String, _ okAction: (() -> Void)?) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "취소", style: .cancel))
        if let okAction {
            let ok = UIAlertAction(title: "확인", style: .default){ _ in
                okAction()
            }
            alertVC.addAction(ok)
        }
        present(alertVC, animated: true, completion: nil)
    }
}

extension UIViewController {
    func setLoginViewAnywhere() {
        let loginVC = LoginViewController()
        loginVC.loginView.signInAnonymousButton.isHidden = true
        show(loginVC, sender: nil)
    }
}

extension MFMailComposeViewControllerDelegate {
    
    func sendEmail(self: UIViewController, userEmail: String, _ reportType: ReportType?, _ chat: ChatModel?, _ completion: () -> Void) {
           if MFMailComposeViewController.canSendMail() {
               let compseVC = MFMailComposeViewController()
               compseVC.mailComposeDelegate = (self as! any MFMailComposeViewControllerDelegate)
               compseVC.setToRecipients(["leehyungju20@gmail.com"])
               if let reportType, let chat {
                   let type = reportType.rawValue
                   compseVC.setSubject("'어제보다' 게시글 신고: \(type)")
                   compseVC.setMessageBody("게시글 시간 : \(chat.timestamp)\n게시글 주소 : \(chat.documentID)\n게시글 작성자:\(chat.userUid)\n\n신고 신청 계정 : \(userEmail)\n신고 이유 : \(type)\n자세한 이유를 서술해주세요 : ", isHTML: false)
                   
               } else {
                   compseVC.setSubject("'어제보다' 문의")
                   compseVC.setMessageBody("문의계정: \(userEmail)\n문의하실 내용을 입력하세요.", isHTML: false)
               }

               self.present(compseVC, animated: true, completion: nil)
           }
           else {
               self.showAlert("메일을 전송 실패", "아이폰 이메일 설정을 확인하고 다시 시도해주세요.", nil)
           }
       }
}
