import UIKit
import StoreKit

class HomeVC: UIViewController {

    @IBOutlet private weak var plansTbl: UITableView!
    private var availableProducts: [Product] = [] {
        didSet {
            DispatchQueue.main.async {
                self.plansTbl.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        IAPManager.shared.getActivePlan(success: { purchasedProductIds in
            print(purchasedProductIds)
        }, failure: { error in
            print(error)
        })
        doInitSetup()
    }
    
    private func doInitSetup() {
        self.plansTbl.register(UINib(nibName: "PlanCell", bundle: nil), forCellReuseIdentifier: "PlanCell")
        let productsId = ["com.akash.nonConsumable.lifetime",
                          "com.akash.autoRenew.weekly",
                          "com.akash.nonRenew.monthly",
                          "com.akash.consumable.gems"]
        IAPManager.shared.loadProducts(productIDs: productsId, success: { products in
            self.availableProducts = products
        })
    }
}

// MARK: - Action Methods
extension HomeVC {
    @IBAction private func restoreBtnTapped(_ sender: UIButton) {
        IAPManager.shared.restorePurchases(success: { allPurchasedProductId in
            
        }, failure: { error in
            
        })
    }
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availableProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlanCell", for: indexPath) as! PlanCell
        let product = availableProducts[indexPath.row]
        cell.planTitle.text = product.displayName
        cell.planPrice.text = product.displayPrice
        cell.planDescription.text = product.description
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedProduct = availableProducts[indexPath.row]
        IAPManager.shared.purchaseProduct(selectedProduct, success: { _ in
            
        }, failure: { purchaseError in
            switch purchaseError {
            case .pending:
                print("Purchase go in pending")
            case .userCancelled:
                print("user canceled Purchase He He Hello Pratik")
            case .unknown:
                print("Purchase Fail")
            case .error(let error):
                print("Purchase Fail: \(error)")
            case .unverified:
                print("unverified purchase")
            }
        })
    }
}
