//
//  CountTodoApp.swift
//  CountTodo
//
//  Created by 서현규 on 2023/03/07.
//

import SwiftUI

@main
struct CountTodoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
