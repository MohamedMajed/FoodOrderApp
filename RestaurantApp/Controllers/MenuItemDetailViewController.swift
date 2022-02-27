//
//  MenuItemDetailViewController.swift
//  RestaurantApp
//
//  Created by Mohamed Maged on 25/02/2022.
//

import UIKit

class MenuItemDetailViewController: UIViewController {
    let menuItem: MenuItem
    
    let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
    
        return formatter
    }()
    
        init?(coder: NSCoder, menuItem: MenuItem) {
            self.menuItem = menuItem
            super.init(coder: coder)
        }
    
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addToOrderButton.layer.cornerRadius = 5.0
        updateUI()
    }
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var detailTextLabel: UILabel!
    @IBOutlet weak var addToOrderButton: UIButton!
    
    @IBAction func orderButtonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, delay: 0,
               usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1,
               options: [], animations: {
                self.addToOrderButton.transform =
                   CGAffineTransform(scaleX: 2.0, y: 2.0)
                self.addToOrderButton.transform =
                   CGAffineTransform(scaleX: 1.0, y: 1.0)
            }, completion: nil)
        MenuController.shared.order.menuItems.append(menuItem)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
//    func updateUI() {
//        nameLabel.text = menuItem.name
//        priceLabel.text = MenuItem.priceFormatter.string(from:
//              NSNumber(value: menuItem.price))
//
//        detailTextLabel.text = menuItem.detailText
//    }
//    func updateUI() {
//        nameLabel.text = menuItem.name
//        priceLabel.text = MenuItem.priceFormatter.string(from:
//           NSNumber(value: menuItem.price))
//        detailTextLabel.text = menuItem.detailText
//        MenuController.shared.fetchImage(url: menuItem.imageURL)
//           { (image) in
//            guard let image = image else { return }
//            DispatchQueue.main.async {
//                self.imageView.image = image
//            }
//        }
//    }
    func updateUI() {
            nameLabel.text = menuItem.name
            priceLabel.text = menuItem.price.formatted(.currency(code: "usd"))
            detailTextLabel.text = menuItem.detailText
        
            Task.init {
                if let image = try? await
                   MenuController.shared.fetchImage(from: menuItem.imageURL) {
                    imageView.image = image
                }
            }
        }
   
}

