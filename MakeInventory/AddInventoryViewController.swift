//
//  AddInventoryViewController.swift
//  MakeInventory
//
//  Created by Eliel A. Gordon on 11/12/17.
//  Copyright © 2017 Eliel Gordon. All rights reserved.
//

import UIKit
import CoreData

class AddInventoryViewController: UIViewController {
    let coreDataStack = CoreDataStack.instance
    
    var item: Inventory?
    var context: NSManagedObjectContext?
    
    @IBOutlet weak var inventoryNameField: UITextField!
    @IBOutlet weak var inventoryQuantityField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let item = item, (context != nil), inventoryNameField != nil, inventoryQuantityField != nil {
            self.title = item.name
            inventoryNameField.text = item.name
            inventoryQuantityField.text = String(item.quantity)
        }
    }
    
    @IBAction func savePressed(_ sender: Any) {
        guard let name = inventoryNameField.text, let quantity = Int64(inventoryQuantityField.text!) else {return}
        if let item = item, let context = context {
            item.name = name
            item.quantity = quantity
            item.date = Date()
            
            coreDataStack.saveTo(context: context)
        } else {
            let inv = Inventory(
                context: coreDataStack.privateContext
            )
            
            inv.name = name
            inv.quantity = quantity
            inv.date = Date()
            
            coreDataStack.saveTo(context: coreDataStack.privateContext)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
}
