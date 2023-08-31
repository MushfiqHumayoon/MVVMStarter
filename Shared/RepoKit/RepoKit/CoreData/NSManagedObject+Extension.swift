//
//  Extention+NSManagedObject.swift
//  RepoKit
//
//  Created by Mushfiq Humayoon on 04/07/23.
//

import CoreData

extension NSManagedObject {

    // MARK: - Generic FetchRequest
    public class func fetch<T: NSManagedObject>(predicate: [NSPredicate], sortBy: [NSSortDescriptor], context: NSManagedObjectContext) -> [T] {
        let request = NSFetchRequest<T>(entityName: entity().name!)
        request.returnsObjectsAsFaults = false
        if !predicate.isEmpty {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicate)
        }
        if !sortBy.isEmpty {
            request.sortDescriptors = sortBy
        }
        guard let result = try? context.fetch(request) else { return [] }
        return result
    }
}
