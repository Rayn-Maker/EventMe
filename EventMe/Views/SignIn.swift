//
//  SignIn.swift
//  EventMe
//
//  Created by Radiance Okuzor on 10/19/18.
//  Copyright © 2018 RayCo. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase
import FirebaseAuth

class SignIn: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate  {

    
    var ref: DatabaseReference!
    var ref2: DatabaseReference!
    var customerInfo = [String]()
    var doesHaveAcct = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let ref2 = Database.database().reference()
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
    }
    
    func signIn(signIn: GIDSignIn!,
                dismissViewController viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        // ...
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            ref = Database.database().reference()
            guard let authentication = user.authentication else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                           accessToken: authentication.accessToken)
  
            
            Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
                if let error = error {
                    self.customerInfo.append(user.profile.givenName); self.customerInfo.append(user.profile.familyName); self.customerInfo.append(user.profile.email)
                    return
                } else {
                    self.ref.child("Users").observeSingleEvent(of: .value, with: { (snapshot) in
                        if snapshot.hasChild(Auth.auth().currentUser?.uid ?? ""){
                            
                        } else {
                             self.customerInfo.append(user.profile.givenName); self.customerInfo.append(user.profile.familyName); self.customerInfo.append(user.profile.email)
                            
                            let userInfo: [String: Any] = ["uid": Auth.auth().currentUser?.uid ?? "",
                                                           "fName": user.profile.givenName ?? " ",
                                                           "lName": user.profile.familyName ?? " ",
                                                           "full_name": user.profile.name ?? " ",
                                                           "email": user.profile.email ?? " ",
                                                           "title":"user"]
                            
                            self.ref.child("Users").child(Auth.auth().currentUser?.uid ?? "").setValue(userInfo, withCompletionBlock: { (err, resp) in
                                if err != nil {
                                    
                                } else {
                                    
                                }
                            })
//                            self.addCustomer(child: Auth.auth().currentUser?.uid ?? "", userEmail: user.profile.email)
                        }
                    })
                    self.doesHaveAcct = true
                    self.performSegue(withIdentifier: "signInToEdit", sender: self)
                    // self.present(vc, animated: true, completion: nil)
//                    let appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
//                    appDel.logUser()
                }
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        //
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newAcctSeg" {
            let vc = segue.destination as? EditProfileVC 
            vc?.customerInfo = self.customerInfo
            vc?.doesHaveAcct = self.doesHaveAcct
        } //createAccSeg
        if segue.identifier == "signInToEdit" {
            let vc = segue.destination as? EditProfileVC
            vc?.customerInfo = self.customerInfo
            vc?.doesHaveAcct = self.doesHaveAcct
        }
    }

}
