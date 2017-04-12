//
//  AppDelegate.swift
//  Socket_Chat
//
//  Created by devloper65 on 4/6/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import SocketRocket
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,SRWebSocketDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        Util.copyFile("Socket_chat.sqlite")
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let nav = UINavigationController()
        nav.pushViewController(HomeScreenViewController(), animated: true)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        return true
    }

    func webSocketDidOpen(_ webSocket: SRWebSocket!) {
        print("Connected")
        do {
            var dic:[String:Any]!
            dic = ["senderId":987654321,"type":"initConnection"]
            let jsonData = try JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
            webSocket.send(NSData(data: jsonData))
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func connect(){
        Constants.websocket = SRWebSocket(url: URL(string: "https://udtwcwkuru.localtunnel.me"))
        Constants.websocket.delegate = self
        Constants.websocket.open()
    }
    
    func webSocket(_ webSocket: SRWebSocket!, didReceiveMessage message: Any!) {
        let dic = convertToDictionary(text: message as! String)
        print(dic!)
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
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

