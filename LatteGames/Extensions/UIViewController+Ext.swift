//
//  UIViewController+Ext.swift
//  LatteGames
//
//  Created by YILDIRIM on 28.02.2023.
//

import UIKit
import SafariServices

extension UIViewController {
    func presentAlertWithError(message: UserFriendlyError, callback: @escaping(Bool) -> Void){
        DispatchQueue.main.async {
        let alert = UIAlertController(title: message.title, message: message.message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Report", style: .default,handler: { _ in callback(true) }))
        alert.addAction(UIAlertAction(title: "Ok", style: .default,handler: { _ in callback(false) }))
         self.present(alert, animated: true) }
    }
    func presentDefaultAlert(){
        DispatchQueue.main.async {
        let alert = UIAlertController(title: "Something went wrong.", message: "We were unable to complete your task at this time. Please try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Report", style: .default))
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
         self.present(alert, animated: true) }
    }
    func presentSafariVC(with url:URL) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemRed
        present(safariVC, animated: true)
    }
}
