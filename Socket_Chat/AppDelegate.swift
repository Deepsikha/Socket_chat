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
    static var websocket: SRWebSocket!
    static var senderId = "8454649"
    static var senderDisplayName = "MIKE"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //connect()
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
        
    }
    
    func connect(){
        AppDelegate.websocket = SRWebSocket(url: URL(string: "https://zyksiueabm.localtunnel.me"))
        AppDelegate.websocket.delegate = self
        AppDelegate.websocket.open()
    }
    
    func webSocket(_ webSocket: SRWebSocket!, didReceiveMessage message: Any!) {
//        let dic = convertToDictionary(text: message as! String)
//        print(dic!)
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
//        if let data = text.data(using: .utf8) {
//            do {
//                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
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
