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
        
        IAPManager.shared.getActivePlan(success: { _ in
            print(UserManager.shared.currentUserType)
        }, failure: { error in
            print(error)
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
        Task {
            if let introOffer = await IAPManager.shared.getIntroOffer(from: product) {
                cell.planDescription.text = "\(introOffer.period)"
            }
        }
        cell.planDescription.text = product.description
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedProduct = availableProducts[indexPath.row]
        IAPManager.shared.purchaseProduct(selectedProduct, in: self, success: { _ in
            
        }, failure: { purchaseError in
            switch purchaseError {
            case .pending:
                print("Purchase go in pending")
            case .userCancelled:
                print("user canceled Purchase")
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
