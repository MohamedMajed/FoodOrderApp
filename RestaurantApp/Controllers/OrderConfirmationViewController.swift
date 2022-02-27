//
//  OrderconfirmationViewController.swift
//  RestaurantApp
//
//  Created by Mohamed Maged on 26/02/2022.
//

import UIKit

class OrderConfirmationViewController: UIViewController {
    

     let minutesToPrepare: Int
    
        init?(coder: NSCoder, minutesToPrepare: Int) {
            self.minutesToPrepare = minutesToPrepare
            super.init(coder: coder)
        }
    
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

    override func viewDidLoad() {
        super.viewDidLoad()

        confirmationLabel.text = "Thank you for your order! Your wait time is approximately \(minutesToPrepare) minutes."
        
    }
    
    @IBOutlet weak var confirmationLabel: UILabel!
    


}
