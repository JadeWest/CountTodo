//
//  DataController.swift
//  CountTodo
//
//  Created by 서현규 on 2023/03/08.
//

import Foundation
import Combine
import SwiftUI
import CoreData

class DataController: ObservableObject {
    
    @Published var workingEntities: [TodoEntity] = []
    @Published var savedDeadlines: [UUID:String] = [:]
    
    static let shared = DataController()
    
    let container: NSPersistentContainer
    
    let formatter: DateComponentsFormatter = {
        let format = DateComponentsFormatter()
        guard var calendar = format.calendar else {return DateComponentsFormatter()}
        calendar.timeZone = .current
        calendar.locale = Locale(identifier: "ko_KR")
        format.calendar = calendar
        format.unitsStyle = .full
        format.allowedUnits = [.year, .month, .day, .hour, .minute, .second]
        return format
    }()
    
    let dateFormatter: DateFormatter = {
        let format = DateFormatter()
        format.calendar.locale = .current
        format.locale = Locale(identifier: "ko_KR")
        format.timeZone = .current
        format.dateStyle = .medium
        format.timeStyle = .medium
        return format
    }()
    
    @Published var secondTimer = Timer.publish(every: 1, on: .current, in: .common).autoconnect()
    @Published var milisecondTimer = Timer.publish(every: 0.1, on: .current, in: .common).autoconnect()
    
    private init() {
        container = NSPersistentContainer(name: "Todo")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("--- CORE DATA LOAD ERROR: \(error.localizedDescription)")
            }
        }
        fetchWorkingEntity()
    }
    
    func save() {
        do {
            try container.viewContext.save()
            fetchWorkingEntity()
        } catch let saveError {
            print("--- CORE DATA SAVE ERROR: \(saveError.localizedDescription)")
        }
    }
    
    func fetchWorkingEntity() {
        
        let request = NSFetchRequest<TodoEntity>(entityName: "TodoEntity")
        request.sortDescriptors = [
            NSSortDescriptor(key: "success", ascending: true),
            NSSortDescriptor(key: "importance", ascending: false),
            NSSortDescriptor(key: "deadline", ascending: true)
        ]
        
        do {
            workingEntities = try container.viewContext.fetch(request)
        } catch let fetchError {
            print("--- CORE DATA FETCH ERROR: \(fetchError.localizedDescription)")
        }
    }
    
    func addEntity(title: String?, deadline: Date?) {
        guard let title = title, let deadline = deadline else {return}
        let newEntity = TodoEntity(context: self.container.viewContext)
        newEntity.id = UUID()
        newEntity.title = title
        newEntity.deadline = deadline
        newEntity.fail = false
        newEntity.success = false
        newEntity.importance = false
        newEntity.createdAt = Date()
        self.save()
    }
    
    func updateEntity(entity: TodoEntity, title: String?) {
        if let title = title {
            entity.title = title
            self.save()
        }
    }
    
    func deleteEntity(offset: IndexSet) {
        guard let index = offset.first else {return}
        let entity = self.workingEntities[index]
        self.deleteSavedDeadline(id: entity.id)
        self.deleteWorkingEntity(index: index)
        self.container.viewContext.delete(entity)
        save()
    }
    
    func deleteWorkingEntity(index: Int) {
        if !workingEntities.isEmpty {
            self.workingEntities.remove(at: index)
        }
    }
    
    func deleteSavedDeadline(id: UUID?) {
        guard let id = id else {return}
        if !savedDeadlines.isEmpty {
            self.savedDeadlines.removeValue(forKey: id)
        }
    }
    
    func calculateDeadline(id: UUID?, deadline: Date?, entity: TodoEntity) {
        guard let index = workingEntities.firstIndex(of: entity) else {return}
        guard let id = id, let deadline = deadline else {return}
        if deadline >= Date() {
            let time = formatter.string(from: Date(), to: deadline)
            savedDeadlines[id] = time
        } else {
            workingEntities[index].fail = true
            savedDeadlines[id] = "Time Expired"
        }
    }
    
    func getCountdownString(id: UUID?) -> String {
        if let id = id, let timeString = self.savedDeadlines[id] {
            return timeString
        }
        return ""
    }
    
    func dateToDate(deadline: Date?) -> Date {
        guard let date = deadline else {return Date()}
        let string = self.dateFormatter.string(from: date)
        guard let result = self.dateFormatter.date(from: string) else {return Date()}
        return result
    }
}
