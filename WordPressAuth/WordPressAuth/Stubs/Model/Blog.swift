import Foundation

class Jetpack {
    var connectedEmail: String?
}


class Blog: NSObject {

    var objectID: NSManagedObjectID?
    var email = ""
    var jetpack: Jetpack?
    var account: WPAccount?
    var url: String?
}
