import Foundation

enum UserType {
    case free, paid, trial
}

class UserManager {
    static let shared = UserManager()
    var currentUserType: UserType = .free {
        didSet {
            switch currentUserType {
            case .free:
                UserDefaults.standard.setValue(false, forKey: "isPremiumUnlocked")
            case .paid:
                UserDefaults.standard.setValue(true, forKey: "isPremiumUnlocked")
            case .trial:
                UserDefaults.standard.setValue(true, forKey: "isPremiumUnlocked")
            }
        }
    }
    
    private init(){ }
 
    func getUserType() -> UserType {
        return currentUserType
    }
    
    func setUserType(type: UserType){
        self.currentUserType = type
    }
    
    func setTransactionId(id: String){
        UserDefaults.standard.setValue(id, forKey: "transactionId")
    }
    
    func getTransactionId() -> String {
        if let transactionId = UserDefaults.standard.value(forKey: "transactionId") as? String{
            return transactionId
        }
        return ""
    }
    
    func getPlanId() -> String? {
        if let planId = UserDefaults.standard.value(forKey: "purchasedPlanId") as? String {
            return planId
        }
        return nil
    }
    
    func setPlanId(productId: String){
        UserDefaults.standard.setValue(productId, forKey: "purchasedPlanId")
        UserDefaults.standard.synchronize()
    }
    
    func removeUserDetails(){
        UserDefaults.standard.removeObject(forKey: "purchasedPlanId")
        UserDefaults.standard.removeObject(forKey: "transactionId")
    }
}
