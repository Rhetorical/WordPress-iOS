import Foundation


class NSManagedObjectID: NSObject {

    func uriRepresentation() -> URL {
        return URL(fileURLWithPath: "")
    }
}

class NSManagedObjectContext: NSObject {
    func object(with objectID: NSManagedObjectID) -> Any? {
        return nil
    }
}


class NSPersistentStoreCoordinator {

    func managedObjectID(forURIRepresentation: URL) -> NSManagedObjectID? {
        return NSManagedObjectID()
    }
}

class ContextManager {
    static func sharedInstance() -> ContextManager {
        return ContextManager()
    }

    let mainContext = NSManagedObjectContext()
    let persistentStoreCoordinator = NSPersistentStoreCoordinator()
}

