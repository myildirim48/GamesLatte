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
    
    func presentSafariVC(with url:URL) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemGreen
        present(safariVC, animated: true)
    }
}
