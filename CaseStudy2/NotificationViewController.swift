//
//  NotificationViewController.swift
//  CaseStudy2
//
//  Created by Capgemini-DA233 on 05/07/1944 Saka.
//

import UIKit
import UserNotifications  // importing this to handle local and remote notifications
class NotificationViewController: UIViewController {
    let notificationCentre = UNUserNotificationCenter.current()
    @IBOutlet weak var notificationBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        notificationBtn.layer.cornerRadius = 12   // setting the corder radius of the button
        notificationBtn.layer.borderWidth = 10  //  setting the border of the button
        notificationBtn.layer.borderColor = UIColor.blue.cgColor  // setting the color of the border of the button
    }
    
    @IBAction func localNotification(_ sender: Any) {
        
        // Local notifications have three main parts. The content, trigger and request. These three parts will allow you to create a local notification.
        let notificationContent = UNMutableNotificationContent()
        // The content of a notification  will include things such as title, body, badge number, user info, attachments etc
        notificationContent.title = "Local notification"
        notificationContent.body = "Your order has been placed"
        notificationContent.sound = .default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)  // create the trigger
        let request = UNNotificationRequest(identifier: "testNotification", content: notificationContent, trigger: trigger)// create the request
        // add the request to notificationCentre
        notificationCentre.add(request) { (error) in
            if let error = error {
                print("notification error :", error.localizedDescription)
            }
        }
    }
}


