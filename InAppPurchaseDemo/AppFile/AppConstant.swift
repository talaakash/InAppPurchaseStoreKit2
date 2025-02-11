
let isTestMode: Bool = true

enum PlanIds: String, CaseIterable {
    case lifetime = "com.akash.nonConsumable.lifetime"
    case weekly = "com.akash.autoRenew.weekly"
    case monthly = "com.akash.nonRenew.monthly"
    case gems = "com.akash.consumable.gems"
}

class AppConstant {
    static let sharedSecret = ""
}
