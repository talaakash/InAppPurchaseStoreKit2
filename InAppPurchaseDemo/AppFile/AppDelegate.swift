import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        Bundle(path: "/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle")!.load()
        return true
    }
}

//extension UIViewController { //5
//    
//    #if DEBUG //1
//    @objc func injected() { //2
//        for subview in self.view.subviews { //3
//            subview.removeFromSuperview()
//        }
//        
//        viewDidLoad() //4
//    }
//    #endif
//}
