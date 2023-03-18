//
//  CountTodoApp.swift
//  CountTodo
//
//  Created by 서현규 on 2023/03/07.
//

import SwiftUI

@main
struct CountTodoApp: App {
    let persistenceController = DataController.shared

    var body: some Scene {
        WindowGroup {
            SplashScreen()
                .background(Color(uiColor: .secondarySystemFill))
        }
    } 
}
