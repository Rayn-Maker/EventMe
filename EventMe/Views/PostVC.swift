//
//  PostVC.swift
//  EventMe
//
//  Created by Radiance Okuzor on 12/4/18.
//  Copyright © 2018 RayCo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class PostVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    
    @IBOutlet weak var profilePic: UIImageView!
    
    var userStorage: StorageReference!
    var ref: DatabaseReference!
    
    
    let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        picker.delegate = self
        editImage()
    }
    
    @IBAction func addPic(_ sender: Any) {
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
        imageDidChange = true
    }
    
    @IBAction func uploadPost(_ sender: Any) {
        let alert = UIAlertController(title: "Post", message: "Add text before you post", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        
        let post = UIAlertAction(title: "Ok", style: .default) { (_) in
           saveImage()
        }
    }
    
    func saveImage() {
        let user = Auth.auth().currentUser
        let imageRef = self.userStorage.child("\(user?.uid ?? "").jpg")
        let data = self.profilePic.image!.jpegData(compressionQuality: 0.5)
        let dateString = String(describing: Date())
        
        let uploadTask = imageRef.putData(data!, metadata: nil, completion: { (metadata, err) in
            if err != nil {
                print(err!.localizedDescription)
                let alert = UIAlertController(title: "Oopps", message: err?.localizedDescription, preferredStyle: .alert)
                
                let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                return
            } else {
                UserDefaults.standard.set(data, forKey: "pictureData")
            }
            
            imageRef.downloadURL(completion: { (url, er) in
                if er != nil {
                    print(er!.localizedDescription)
                }
                if let url = url {
                    let params: [String:Any] = ["Author":Auth.]
                    self.ref.child("Users").child(user!.uid).child("pictureUrl").updateChildValues(url.absoluteString)
                    let appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDel.logUser()
                    
                }
            })
        })
        uploadTask.resume()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) { // UIImagePickerControllerEditedImage
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.profilePic.image = image
            let data = self.profilePic.image!.jpegData(compressionQuality: 0.5)
            UserDefaults.standard.set(data, forKey: "pictureData")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func editImage(){
        profilePic.layer.borderWidth = 1
        profilePic.layer.masksToBounds = false
        profilePic.layer.borderColor = UIColor.black.cgColor
        profilePic.layer.cornerRadius = profilePic.frame.height/2
        profilePic.clipsToBounds = true
    }
    
}
