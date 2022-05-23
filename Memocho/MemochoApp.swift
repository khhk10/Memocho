//
//  MemochoApp.swift
//  Memocho
//
//  Created by Kohei Ikeda on 2021/08/27.
//

import SwiftUI
import PartialSheet

@main
struct MemochoApp: App {
    let persistenceController = PersistenceController.shared
    let sheetManager: PartialSheetManager = PartialSheetManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(sheetManager)
        }
    }
}
