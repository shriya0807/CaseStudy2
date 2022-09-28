//
//  LoginPageViewController.swift
//  CaseStudy2
//
//  Created by Capgemini-DA233 on 03/07/1944 Saka.
//

import UIKit    //UIKit is the framework that you'll user most often when developing iOS applications
import LocalAuthentication   // importing this to authenticate the user with a face or fingerprint scan.
import Firebase  //Firebase provides detailed documentation and cross-platform SDKs to help you build and ship apps
import FirebaseAuth  // to give authentication
//import CoreData //CoreData is the framework provided by Apple to save, track, filter, and modify the data within the iOS applications. It is not the database, but it uses SQLite as it's persistent store.


class LoginPageViewController: UIViewController , UITextFieldDelegate{

    @IBOutlet weak var signUpBtn: UIButton!  // a weak variable button is created
    @IBOutlet weak var loginBtn: UIButton!      // a weak variable button is created
    @IBOutlet weak var passwordError: UILabel!   // defining a label to display the error in the password
    @IBOutlet weak var passwordLoginPage: UITextField!   // defining a text field to enter the password
    @IBOutlet weak var emailError: UILabel!          // defining a label to display the error in the email id
    @IBOutlet weak var emailLoginPage: UITextField!     // defining a text field to enter the email id
    @IBOutlet weak var profilePicture: UIImageView!      // it is the image of the tree shown in the welcome screen
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // setting the image from rectangle to circle
        profilePicture.layer.cornerRadius = profilePicture.frame.width / 2
        profilePicture.clipsToBounds = true
        applyCornerRadiusOnBtn(radiusValue: 10.0)  // applying corner radius on the button
        // disabling all the auto correction keyboard text
        emailLoginPage.autocorrectionType = .no
        passwordLoginPage.autocorrectionType = .no
       // authenticateUserByFaceTouchID()   // a function is called to authenticate user by face scanning
        authenticateUserByTouchID()      // a function is called to authenticate user by fingerprint scanning
    }
    private func applyCornerRadiusOnBtn(radiusValue : CGFloat){  // function to set corners radius
         emailLoginPage.layer.cornerRadius = radiusValue
         passwordLoginPage.layer.cornerRadius = radiusValue
         signUpBtn.layer.cornerRadius = radiusValue
         loginBtn.layer.cornerRadius = radiusValue
     }
     func authenticateUserByFaceTouchID(){// a function is created to authenticate user by face scanning
         let context = LAContext()
         var error: NSError?
         let reasonStr = "Identify yourself"  // a show message will show on the popup screen
         
         if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
             context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reasonStr){
                 
                 [weak self] success, authenticationError in
                 DispatchQueue.main.async {
                     if success{
                         self?.showAlert(msgStr: "Authenticated successfully", title: "Success") // if user is same as saved in the system
                     }else{  // if saved face by the user is not the same as saved in the system
                         
                     }
                 }
                 
             }
         }
         else{
             showAlert(msgStr: "No biometric authentication available", title: "Error") // if there is no face authentication available
         }
     }
     func authenticateUserByTouchID(){ // note : when simulator asked for password-- give any value to it. It will work
         // a function is called to authenticate user by fingerprint scanning
         let context : LAContext = LAContext()
         let reasonStr = "Authentication is needed to access your app"  // a show message will show on the popup screen
         var authError : NSError?
         if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &authError){
             context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reasonStr, reply: {succes, error in
                 if succes{
                     print("user authentication successfully")  // if the fingerprint matches with the saved one in the system
                 }
             else{   // if the fingerprint does not match
                 if let error = error {
                     let message = self.showmessageWithErrorCode(errorcode: error as! Int)
                     print(message)
                 }
             }
             })
         }
     }
     func showAlert(msgStr: String, title:String){   // this function is thrown if the user face does not match
         let alert = UIAlertController(title: title, message: msgStr, preferredStyle: UIAlertController.Style.alert)
         alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: nil))
         self.present(alert, animated: true,completion: nil)
     }
     func showmessageWithErrorCode(errorcode: Int) -> String{  // this function is thrown if the user fingerprint does not match
         var msgStr = ""
         switch errorcode{
             
         case LAError.appCancel.rawValue:
             msgStr = "Authentication was cancelled by the application"
         
         case LAError.authenticationFailed.rawValue:
             msgStr = "unable to authenticate the user"
         
         default:
             msgStr = ""
         }
         return msgStr
     }
    
    @IBAction func emailAction(_ sender: Any) {
        // email action function to check if the email is as per the regex function or not
           let text = emailLoginPage.text ?? ""
           if text.isValidEmail1() {   // if the email id is valid
               emailError.text = ""
           } else {                 // if the email id is not valid
               emailError.text = "Not valid email"
           }
    }
    
    @IBAction func passwordAction(_ sender: Any) {
        //password action function to check if the password is as per the regex function or not
        do {
              
              
              let text = passwordLoginPage.text ?? ""
              if text.isValidPassword1() {  // if the password is valid
                  passwordError.text = ""
              } else {                      // if the password is not valid
                  passwordError.text="Not valid password"
              }
          }
    }
    @IBAction func loginAction(_ sender: Any) {
        if(emailLoginPage.text == "" || passwordLoginPage.text == "") // if any text field is empty
        {
            // alert message is thrown
                let alertController = UIAlertController(title: "Error", message: "Please Enter All text Fields", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
        }
        else   // if text field is not empty then
        {
            // checking in the firebase if user has entered correct username and password or not
            login()
        }
    }
   /* @objc func didTapLoginButton() {
        let loginManager = FirebaseAuthManager()
        guard let email = emailLoginPage.text, let password = passwordLoginPage.text else { return }
        loginManager.signIn(email: email, pass: password) {[weak self] (success) in
            guard let `self` = self else { return }
            var message: String = ""
            if (success) {
                message = "User was sucessfully logged in."
            } else {
                message = "There was an error."
            }
            let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.display(alertController: alertController)
        }
    } */
    
    func login(){
        Auth.auth().signIn(withEmail: emailLoginPage.text!, password: passwordLoginPage.text!, completion: { (auth, error) in
        if let _ = auth?.user {
                    print("correct email id and password entered by the user") //user is authenticated
                    // last step is to go to the CategoryScreenViewController
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CategoryScreenViewController") as! CategoryScreenViewController
                    self.present(nextViewController, animated:true, completion:nil)
                }
            else {  // if the user is not authenticated
                    print("authentication failed - no authenticated user found")  // a failed authentication message will be shown
                    // also showing alert message
                    let alertController = UIAlertController(title: "Error", message: "“User does not exist. Please signup", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
        })
    }
}
// extension to show regex expression functions
extension String {
        func isValidEmail1() -> Bool {                                          // to check the email regex expression
            let inputRegEx = "[A-Za-z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[A-Za-z]{2,3}"     // input for the email
            let inputpred = NSPredicate(format: "SELF MATCHES %@", inputRegEx)
            return inputpred.evaluate(with:self)
        }
        func isValidPassword1() -> Bool {                                           // to check the password regex expression
            let inputRegEx = "^([a-zA-Z0-9@*#]{6,})$"                       // input for the password
            let inputpred = NSPredicate(format: "SELF MATCHES %@", inputRegEx)
            return inputpred.evaluate(with:self)
        }
}
