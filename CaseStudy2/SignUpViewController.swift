//
//  SignUpViewController.swift
//  CaseStudy2
//
//  Created by Capgemini-DA233 on 30/06/1944 Saka.
//

import UIKit  //UIKit is the framework that you'll user most often when developing iOS applications
import Firebase  //Firebase provides detailed documentation and cross-platform SDKs to help you build and ship apps
import FirebaseAuth  // to give authentication
import CoreData //CoreData is the framework provided by Apple to save, track, filter, and modify the data within the iOS applications. It is not the database, but it uses SQLite as it's persistent store.

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var picture: UIImageView!
    
    @IBOutlet weak var confirmPasswordError: UILabel!
    @IBOutlet weak var passwordError: UILabel!
    @IBOutlet weak var mobileError: UILabel!
    @IBOutlet weak var emailError: UILabel!
    @IBOutlet weak var usernameError: UILabel!
 
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var confirmPasswordSignUp: UITextField!
    @IBOutlet weak var passwordSignup: UITextField!
    @IBOutlet weak var mobileSignUp: UITextField!
    @IBOutlet weak var emailIdSignUp: UITextField!
    @IBOutlet weak var usernameSignUp: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // setting the image from rectangle to circle
        picture.layer.cornerRadius = picture.frame.width / 2
        picture.clipsToBounds = true
        applyCornerRadiusOnBtn(radiusValue: 10.0) // applying corner radius on the button
        // dis - abling all the auto correction keyboard text
        usernameSignUp.autocorrectionType = .no
        emailIdSignUp.autocorrectionType = .no
        mobileSignUp.autocorrectionType = .no
        passwordSignup.autocorrectionType = .no
        confirmPasswordSignUp.autocorrectionType = .no
    }
    
    
    private func applyCornerRadiusOnBtn(radiusValue : CGFloat) {  // function to set corner radius
        
        usernameSignUp.layer.cornerRadius = radiusValue
        emailIdSignUp.layer.cornerRadius = radiusValue
        mobileSignUp.layer.cornerRadius = radiusValue
        passwordSignup.layer.cornerRadius = radiusValue
        confirmPasswordSignUp.layer.cornerRadius = radiusValue
        signUpBtn.layer.cornerRadius = radiusValue
    }
   
    @IBOutlet weak var usernameAction: UILabel!
    
    @IBAction func usernameActions(_ sender: Any) {
        // name action function to check if the name is as per the regex function or not
       let text = usernameSignUp.text ?? ""
       if text.isValidName() {
           usernameError.text = ""
       } else {
           usernameError.text = "not valid name"
       }
    }
    
    @IBAction func emailAction(_ sender: Any) {
        // email action function to check if the email is as per the regex function or not
       let text = emailIdSignUp.text ?? ""
       if text.isValidEmail() {
           emailError.text = ""
       } else {
           emailError.text = "not valid email id"
       }
    }
    
    @IBAction func mobileAction(_ sender: Any) {
        // phone action function to check if the phone is as per the regex function or not
           let text = mobileSignUp.text ?? ""
           if text.filterPhoneNumber().isValidPhone(){
               mobileError.text = ""
           } else {
               mobileError.text = "not valid phone"
           }
    }
    
    @IBAction func passwordAction(_ sender: Any) {
        // password action function to check if the password is as per the regex function or not
               let text = passwordSignup.text ?? ""
               if text.isValidPassword() {
                   passwordError.text = ""
               } else {
                   passwordError.text = "Password must be at least 6 characters"
               }
    }
    
    @IBAction func confirmPasswordAction(_ sender: Any) {
        // function to check if password and confirm password match or not
           let pass1 = passwordSignup.text!
           let pass2 = confirmPasswordSignUp.text!
           if(pass1 == pass2) {                       // if both password and confirm password matched
               confirmPasswordError.text = ""
           } else if(pass1 != pass2)       // if both password and confirm password does not matched then show alert message
           {
               let alertController = UIAlertController(title: "Error", message: "Passwords don't Match.Try again!", preferredStyle: .alert)
               let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
               alertController.addAction(defaultAction)
               self.present(alertController, animated: true, completion: nil)
           }
    }
  
    @IBAction func signUpAction(_ sender: Any) {
        if(usernameSignUp.text == "" || emailIdSignUp.text == "" || mobileSignUp.text == "" || passwordSignup.text == "" || confirmPasswordSignUp.text == "")     // if any fields is empty then generate an alert message
        {
                let alertController = UIAlertController(title: "Error", message: "Please Enter All text Fields", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
        }
        else{
            signUp()
        }
    }
    func signUp(){
        Auth.auth().createUser(withEmail: usernameSignUp.text!, password: confirmPasswordSignUp.text!)
        { (authResult, error) in
            guard let user = authResult?.user, error == nil else {
                print("Error \(String(describing: error?.localizedDescription))")
                return
            }
            
        }
        // last step is to go to the CategoryScreenViewController
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CategoryScreenViewController") as! CategoryScreenViewController
        self.present(nextViewController, animated:true, completion:nil)
    }

}
// extensions for regex functions for checking if the text input by the user is valid or not
extension String {
    func isValidName() -> Bool {                        // to check the name regex expression
        let inputRegEx = "^[a-zA-Z\\_]{4,16}$"
        let inputpred = NSPredicate(format: "SELF MATCHES %@", inputRegEx)
        return inputpred.evaluate(with:self)
    }
    func isValidEmail() -> Bool {                          // to check the email regex expression
        let inputRegEx = "[A-Za-z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[A-Za-z]{2,3}"
        let inputpred = NSPredicate(format: "SELF MATCHES %@", inputRegEx)
        return inputpred.evaluate(with:self)
    }
    func isValidPhone() -> Bool {                  // to check the phone regex expression
        let inputRegEx = "^[6-9]{1}[0-9]{9}$"
        let inputpred = NSPredicate(format: "SELF MATCHES %@", inputRegEx)
        return inputpred.evaluate(with:self)
    }
    func isValidPassword() -> Bool {                    // to check the password regex expression
        let inputRegEx = "^([a-zA-Z0-9@*#]{6,})$"
        let inputpred = NSPredicate(format: "SELF MATCHES %@", inputRegEx)
        return inputpred.evaluate(with:self)
    }
    public func filterPhoneNumber() -> String {        // to filter the phone number
        return String(self.filter {!" ()._-\n\t\r".contains($0)})
    }
}
