//
//  NodeTutorialSwiftUiCodeApp.swift
//  NodeTutorialSwiftUiCode
//
//  Created by Ahmed on 26/10/22.
//

import SwiftUI

@main
struct NodeTutorialSwiftUiCodeApp: App {
    var body: some Scene {
        WindowGroup {
            // When loading todo from mongodb or memory
            TodoHome()
            
            // When loading todo with auth and JWT
            MyApp()
        }
    }
}
