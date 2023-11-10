//
//  AppDelegate.swift
//  test
//
//  Created by cyanboo on 2022/2/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(testList), userInfo: nil, repeats: false)
//        testList()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    @objc func testList() {
        var people1 = People()
        people1.name = "y"
        people1.age = 9
        people1.sex = true
        var people2 = People()
        people2.name = "pop"
        people2.age = 7166
        people2.sex = false
        var people3 = People()
        people3.name = "po1p"
        people3.age = 20
        people3.sex = false
        var people4 = People()
        people4.name = "top"
        people4.age = 33
        people4.sex = false
        var people5 = People()
        people5.name = "p2"
        people5.age = 65
        people5.sex = true
        var people6 = People()
        people6.name = "zz"
        people6.age = 199921
        people6.sex = nil
        var people7 = People()
        people7.name = "gfd"
        people7.age = 7000
        people7.sex = true
        let a = [people1,people2,people3,people4,people5,people6,people7]
        
        
        
        let array = a
        let bbb = array.filter { item in
            return item.sex == true
        }.max { item1, item2 in
            return item2.age > item1.age
        }
        
        let ccc = array.filter { item in
            return item.sex == false
        }.max { item1, item2 in
            return item2.age > item1.age
        }
        
        
        print(bbb)
        print(ccc)
    }


}

struct People {
    var name = ""
    var age = 0
    var sex:Bool? = nil
}
