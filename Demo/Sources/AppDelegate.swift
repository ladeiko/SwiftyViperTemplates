//
//  AppDelegate.swift
//  Demo
//
//  Created by Siarhei Ladzeika.
//  Copyright © 2017-present Siarhei Ladzeika. All rights reserved.
//

import UIKit
import MagicalRecord

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        MagicalRecord.setupCoreDataStack(withStoreNamed: "Model")
        NSManagedObjectContext.mr_default().mr_save(blockAndWait: { (context) in
            SomeModuleDatabaseModel.mr_deleteAll(matching: NSPredicate(value: true), in: context)
            for val in ["1", "2", "3"] {
                let e = SomeModuleDatabaseModel.mr_createEntity(in: context)!
                e.xxx = val
            }
        })
        window = UIWindow(frame: UIScreen.main.bounds)

        var repeatCounter = 0
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in

            repeatCounter += 1

            let stop = repeatCounter > 3

            if stop {
                timer.invalidate()
            }

            NSManagedObjectContext.mr_default().mr_save(blockAndWait: { (context) in
                SomeModuleDatabaseModel.mr_deleteAll(matching: NSPredicate(value: true), in: context)

                if stop {
                    return
                }

                for val in ["1", "2", "3"] {
                    let e = SomeModuleDatabaseModel.mr_createEntity(in: context)!
                    e.xxx = val
                }
            })
        }

        #if !SwiftyViperService && !SwiftyViperReduxService && !service && !redux_service
            let configurator = TestedConfigurator()
            #if extended_configure
                #if extended_configurator_create
                    #if SwiftyViperMcFlurryAlert || alert
                        let viewController = (configurator.create(with: TestedModuleInputConfig(title: nil, message: nil)) as! TestedViewController)
                    #elseif extended_configure_vars
                        let viewController = (configurator.create(with: TestedModuleInputConfig(a: AClass(), b: nil)) as! TestedViewController)
                    #else
                        let viewController = (configurator.create(with: TestedModuleInputConfig()) as! TestedViewController)
                    #endif
                #else
                    let viewController = (configurator.create() as! TestedViewController)
                    #if SwiftyViperMcFlurryAlert || alert
                        (viewController.output as! TestedModuleInput).configure(with: TestedModuleInputConfig(title: nil, message: nil))
                    #else
                        #if extended_configure_vars
                            (viewController.output as! TestedModuleInput).configure(with: TestedModuleInputConfig(a: AClass(), b: nil))
                        #else
                            (viewController.output as! TestedModuleInput).configure(with: TestedModuleInputConfig())
                        #endif
                    #endif
                #endif
            #else
                let viewController = (configurator.create() as! TestedViewController)
                #if SwiftyViperMcFlurryAlert || alert
                    (viewController.output as! TestedModuleInput).configure(with: TestedModuleInputConfig(title: nil, message: nil))
                #else
                    (viewController.output as! TestedModuleInput).configure()
                #endif
            #endif
            window?.rootViewController = viewController
        #else
            window?.rootViewController = UIViewController()
        #endif

        window?.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

#if !extended_configure
#if SwiftyViperMcFlurryAlert
typealias TestedModuleInputConfig = SwiftyViperMcFlurryAlertModuleInputConfig
#elseif alert
typealias TestedModuleInputConfig = alertModuleInputConfig
#endif
#endif
