//
//  SceneDelegate.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2022/10/12.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    var locationForDecoder: [LocationGridModel]?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        guard let window else { return }
        ViewByLoginManager.shared.show(in: window)
        
        // MARK: - JSON decoder part
        
        let existedData = CoreDataManager.shared.getLocationGridList()
        var locationGridModel: [LocationGridModel]?
        let fileName = CoreDataNames.fileName
        let fileType = CoreDataNames.fileType
        
        guard let jsonPath = Bundle.main.path(forResource: fileName, ofType: fileType),
              let jsonDataLoaded = loadJsonData(fileLocation: jsonPath) else { return }
        
        if UserDefaults.standard.bool(forKey: UserDefaultsKeys.launchedBefore) == true {
        } else {
            do {
                self.locationForDecoder = try JSONDecoder().decode([LocationGridModel].self, from: jsonDataLoaded)
                if let locationForDecoder = locationForDecoder {
                    locationForDecoder.forEach {
                        CoreDataManager.shared.saveLocationGridData(locationGrid: $0, completion: {})
                    }
                    UserDefaults.standard.set(true, forKey: UserDefaultsKeys.launchedBefore)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        
        func loadJsonData(fileLocation: String) -> Data? {
            let data = try? String(contentsOfFile: fileLocation).data(using: .utf8)
            return data
        }
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

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}

