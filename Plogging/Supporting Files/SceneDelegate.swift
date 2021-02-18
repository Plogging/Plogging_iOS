//
//  SceneDelegate.swift
//  Plogging
//
//  Created by 전소영 on 2021/01/03.
//

import UIKit
import AuthenticationServices
import NaverThirdPartyLogin

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        if PloggingCookie.shared.isFirstTimeUser() {
            // 유저 처음인지 확인하는 작업 필요
            SNSLoginManager.shared.setupLoginWithNaver()
            SNSLoginManager.shared.setupLoginWithKakao()
            // 회원 탈퇴한 유저 , 생 처음 유저
            if PloggingCookie.shared.getUserCookie() == nil {
                let storyboard = UIStoryboard(name: Storyboard.Onboarding.rawValue, bundle: nil)
                if let onboardingViewController = storyboard.instantiateViewController(withIdentifier: "OnboardingViewController") as? OnboardingViewController {
                    self.window?.rootViewController = onboardingViewController
                }
            } else {
                // 로그아웃한 유저
                let storyboard = UIStoryboard(name: Storyboard.SNSLogin.rawValue, bundle: nil)
                if let loginVeiwController = storyboard.instantiateViewController(withIdentifier: "SNSLoginViewController") as? SNSLoginViewController {
                    self.window?.rootViewController = loginVeiwController
                }
            }
        } else {
            // Plogging 메인
            self.window?.rootViewController?.makeDefaultRootViewController()
        }
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if PloggingCookie.shared.isFirstTimeUser() {
            NaverThirdPartyLoginConnection
                .getSharedInstance()?
                .receiveAccessToken(URLContexts.first?.url)
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if PloggingCookie.shared.isFirstTimeUser() {
            NaverThirdPartyLoginConnection.getSharedInstance()?.application(app, open: url, options: options)
        }
        return true
      }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

