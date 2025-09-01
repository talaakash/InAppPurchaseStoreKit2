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
        Task {
            do {
                let products = try await IAPManager.shared.loadProducts(productIDs: productsId)
                self.availableProducts = products
            } catch let error as ProductLoadError {
                switch error {
                case .inValidProductIds:
                    debugPrint("Invalid product id's")
                case .notLoadedProductIds(let productIds):
                    debugPrint("Not Loaded product id's: \(productIds)")
                case .error(let error):
                    debugPrint("Error: \(error)")
                }
            }
        }
        
        Task {
            let allTransactions = await IAPManager.shared.getActiveTransaction()
            print(allTransactions.isEmpty ? "No purchase found" : allTransactions)
        }
    }
}

// MARK: - Action Methods
extension HomeVC {
    @IBAction private func restoreBtnTapped(_ sender: UIButton) {
        Task {
            do {
                let allTransactions = try await IAPManager.shared.restorePurchases()
            } catch let error as RestoreError {
                switch error {
                case .expired:
                    debugPrint("Your purchase expired")
                case .neverPurchased:
                    debugPrint("You have never purchase")
                case .error(let error):
                    debugPrint("Error: \(error)")
                }
            }
        }
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
        Task {
            do {
                let transaction = try await IAPManager.shared.purchaseProduct(selectedProduct, in: self)
            } catch let error as PurchaseError {
                switch error {
                case .pending:
                    debugPrint("Purchase go in pending")
                case .userCancelled:
                    debugPrint("user canceled Purchase")
                case .unverified:
                    debugPrint("unverified purchase")
                case .unknown:
                    debugPrint("Purchase Fail")
                case .error(let string):
                    debugPrint("Purchase Fail: \(error)")
                }
            }
        }
    }
}
