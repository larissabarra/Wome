//
//  SceneDelegate.swift
//  Wome
//
//  Created by Larissa Barra Conde on 08/02/2021.
//

import SwiftUI
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?
  let context = CoreDataStorage.mainQueueContext()
  
  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    let contentView = ContentView().environment(\.managedObjectContext, context)
    
    if let windowScene = scene as? UIWindowScene {
      let window = UIWindow(windowScene: windowScene)
      window.rootViewController = UIHostingController(rootView: contentView)
      self.window = window
      window.makeKeyAndVisible()
    }
  }

  func sceneDidEnterBackground(_ scene: UIScene) {
    saveContext()
  }
  
  func saveContext() {
    CoreDataStorage.saveContext(context)
  }
}
