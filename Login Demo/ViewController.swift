//
//  ViewController.swift
//  Login Demo
//
//  Created by TrungLD on 5/29/20.
//  Copyright © 2020 TrungLD. All rights reserved.
//

import UIKit
import CoreData
class ViewController: UIViewController {
    var isLoginIn  = false
    @IBOutlet weak var logout: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult> (entityName: "Users")
        
        
           request.predicate = NSPredicate(format: "username = %@", "trung")
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            for result in results as! [NSManagedObject] {
                if let username = result.value(forKey: "username") as? String {
                  
                    loginButton.setTitle("Update username", for: [])
                    logout.alpha = 1
                    label.alpha = 1
                    label.text = "Hi there " + username + "!"
                    isLoginIn = true
                  //  print(username)
                    
                }
            }
        } catch {
            print("fetch error")
        }
    }

    @IBAction func login(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        if isLoginIn {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
            
            do {
            let results =      try context.fetch(request)
                if results.count > 0 {
                    for result in results  as! [NSManagedObject]{
                        result.setValue(textField.text, forKey: "username")
                        do {
                            try context.save()
                        } catch {
                            print("update username save faild")
                        }
                    }
                    label.text = "hi there " + textField.text! + "!"
                  
                }
            } catch {
                print("update username faild")
            }
            
        } else {
            
        
        
        let newValue = NSEntityDescription.insertNewObject(forEntityName: "Users", into: context)
        newValue.setValue(textField.text, forKey: "username")
        
        do {
            try context.save()
         
                                 loginButton.setTitle("updated user name", for: [])
                               label.alpha = 1
            label.text = "Hi there " + textField.text! + "!"
            isLoginIn = true
            logout.alpha = 1
        } catch {
            print("failed to save")
        }
        }
    }
    
    @IBAction func logout(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
         
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult> (entityName: "Users")
        
        do {
            let results = try context.fetch(request)
            
            for result in results as! [NSManagedObject] {
                context.delete(result )
                do {
                    try context.save()
                } catch {
                    print("invividual delete faild")
                }
            }
            
            label.alpha = 0
            logout.alpha = 0
            loginButton.alpha = 1
            loginButton.setTitle("login", for: [])
            isLoginIn = false
            
            
        } catch {
            print("delete faild")
            
        }
        
    }
}

