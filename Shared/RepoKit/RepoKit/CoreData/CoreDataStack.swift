//
//  CoreDataStack.swift
//  RepoKit
//
//  Created by Mushfiq Humayoon on 04/07/23.
//

import Foundation
import CoreData

public class CoreDataStack {

    // MARK: - Singleton instance
    private static var sharedInstance: CoreDataStack = {
        let dataStack = CoreDataStack()
        return dataStack
    }()

    // MARK: - Intialization
    private init() {}

    // MARK: - Accessor
    public static func shared() -> CoreDataStack {
        return sharedInstance
    }

    // MARK: - NSPersistentContainer
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MVVMStarter")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                print(error)
                // fatalError("Unresolved coredata error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.undoManager = nil
        container.viewContext.shouldDeleteInaccessibleFaults = false
        return container
    }()

    public var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    public var privateContext: NSManagedObjectContext {
        let context = persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        context.undoManager = nil
        return context
    }

    // MARK: - Save managed object context
    public func saveContext() {
        if mainContext.hasChanges {
            do {
                try mainContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved coredata error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
