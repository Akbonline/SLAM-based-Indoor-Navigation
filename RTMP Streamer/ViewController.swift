//
//  ViewController.swift
//  RTMP Streamer
//
//  Created by Alexander Kozhevin on 09/01/2020.
//  Copyright © 2020 Alexander Kozhevin. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UITextFieldDelegate {

    
    
    
    
    var txtField: UITextField = UITextField(frame: CGRect(x: 0, y: 0, width: 300.00, height: 50.00));
    var buttonField: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 200.00, height: 50.00));
    
    
    
    let screenSize: CGRect = UIScreen.main.bounds
    let myView = UIView(frame: CGRect(x: 0, y: 0, width: 350, height: 50))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
//        var label = UILabel(frame: CGRectMake(0, 0, 200, 21))
        
        let color2 = hexStringToUIColor(hex: "#303952")
        buttonField.backgroundColor = color2
        
        view.addSubview(myView)
        
        let nameurl = StorageGet(key: "push_url") as String
        
        print(nameurl)
        txtField.text = nameurl
        
        txtField.delegate = self
        
        
        buttonField.setTitle("Next", for: .normal)
        buttonField.setTitleColor(.white, for: .normal)
        //buttonField.addTarget(self, action: "buttonClicked", for: .touchUpInside)
        
        buttonField.addTarget(self, action: #selector(didButtonClick), for: .touchUpInside)

        //txtField.sizeToFit()
        let sizer : CGSize = CGSize(width: 300, height: 50)
        txtField.sizeThatFits(sizer)
        var CGRectframer = txtField.frame
        CGRectframer.size.height = 360
        txtField.frame = CGRectframer
        
        
        //txtField.backgroundColor = .red
////        let color3 = hexStringToUIColor(hex: "#303952")
////        buttonField.setTitleColor(color3, for: <#UIControl.State#>)
////        buttonField.background = color3
        buttonField.layer.cornerRadius = 20
        buttonField.layer.masksToBounds = true
        
        buttonField.frame.size.height = 50
        buttonField.frame.size.width = 150
        
        
        txtField.placeholder = "rtmp://your_rtmp_destination"
        txtField.layer.borderWidth = 1.0
        txtField.borderStyle = UITextField.BorderStyle.roundedRect
        
        
//        txtField.setLeftPaddingPoints(10)
//        txtField.setRightPaddingPoints(10)
        
        txtField.layer.borderColor = UIColor(red:0.19, green:0.22, blue:0.32, alpha:1.0).cgColor
        txtField.frame.size.height = 50
        txtField.frame.size.width = 350
        txtField.textAlignment = .center
        
        //self.view.addSubview(txtField)
        
        self.view.addSubview(buttonField)
  
        
        
        
        
//        myView.translatesAutoresizingMaskIntoConstraints = true
//        myView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        myView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        
        myView.frame.origin.x = view.bounds.midX - myView.bounds.midX
        myView.frame.origin.y = view.bounds.midY - myView.bounds.midY
        
        
        
        
        
       
        
        
        myView.addSubview(txtField)
        
        buttonField.frame.origin.x = view.bounds.midX - buttonField.bounds.midX
        buttonField.frame.origin.y = view.bounds.midY + 50
        
//        txtField.translatesAutoresizingMaskIntoConstraints = false
//        txtField.centerXAnchor.constraint(equalTo: myView.centerXAnchor).isActive = true
//        txtField.centerYAnchor.constraint(equalTo: myView.centerYAnchor).isActive = true
  
//        buttonField.translatesAutoresizingMaskIntoConstraints = false
//        buttonField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        buttonField.centerYAnchor.constraint(lessThanOrEqualTo: view.centerYAnchor, constant: 50).isActive = true
        
        
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
//        labelthing.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
//        labelthing.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
//        labelthing.widthAnchor.constraint(equalToConstant: 128).isActive = true
//        labelthing.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//            // Excecute after 3 seconds
//            print("wait pizda 4 seconds")
//            self.labelthing.textColor = .red
//            self.labelthing.font = self.labelthing.font.withSize(30)
//
//
//        }
        
    }
    
    
 
    
    @objc func didButtonClick(_ sender: UIButton) {
        
        if self.txtField.text == ""{
            // either textfield 1 or 2's text is empty
            let alert = UIAlertController(title: "Alert", message: "Invalid rtmp link", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            
            
            StorageSave(key: "push_url", value: self.txtField.text ?? "")
            
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "streamingpage") as? UIViewController
            //            testboard
            //            streamingscreen
            
            self.navigationController?.pushViewController(vc!, animated: true)
            //let nameurler = StorageGet(key: "push_url") as String
            //pizda(texter : nameurler ?? "")
            print(" - - - -")
            //print(nameurler)
        }
       
        // your code goes here
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        
        view.endEditing(true)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .landscapeRight
        } else {
            return .all
        }
    }


}

