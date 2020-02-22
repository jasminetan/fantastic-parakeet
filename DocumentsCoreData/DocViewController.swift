//
//  DocViewController.swift
//  DocumentsCoreData
//
//  Created by Jasmine Tan on 2/21/20.
//  Copyright © 2020 Jasmine Tan. All rights reserved.
//

import UIKit
class DocViewController: UIViewController {

    @IBOutlet weak var contentText: UITextView!
    @IBOutlet weak var nameText: UITextField!
    var document: Doc?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func save(_ sender: Any) {
        guard let name = nameText.text else {
            alertNotifyUser(message: "Document not saved.\nThe name is not accessible.")
            return
        }
        
        let documentName = name.trimmingCharacters(in: .whitespaces)
        if (documentName == "") {
            alertNotifyUser(message: "Document not saved.\nA name is required.")
            return
        }
        
        let content = contentText.text
        
        if document == nil {
            // document doesn't exist, create new one
            document = Doc(name: documentName, text: content)
        } else {
            // document exists, update existing one
            document?.update(name: documentName, text: content)
        }
        
        if let document = document {
            do {
                let managedContext = document.managedObjectContext
                try managedContext?.save()
            } catch {
                alertNotifyUser(message: "The document context could not be saved.")
            }
        } else {
            alertNotifyUser(message: "The document could not be created.")
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nameChange(_ sender: Any) {
        title = nameText.text
    }
    func alertNotifyUser(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
         
         self.present(alert, animated: true, completion: nil)
     }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
