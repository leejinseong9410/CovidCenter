//
//  AppDelegate.swift
//  CovidCenter
//
//  Created by Lee jinseong on 2022/03/28.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

   
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setUpNavigationBarUpdateFromiOS15()
        
        return true
    }
    
    private func setUpNavigationBarUpdateFromiOS15(){
        // ios 15 부턴 navigationBar 가 자동 투명이고 scroll이 이루어질때 불투명으로 변한다.
        // 그걸 방지하기 위해선 밑 코드가 필요.
        if #available(iOS 15.0, *) {
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithDefaultBackground()
            UINavigationBar.appearance().standardAppearance = navigationBarAppearance
            UINavigationBar.appearance().compactAppearance = navigationBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        }
        
    }

    
    

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role) }
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}


}

