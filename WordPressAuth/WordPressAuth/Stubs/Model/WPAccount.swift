import Foundation


@objc
class WPAccount: NSObject {
    var username: String! = ""
    var displayName = ""
    var email = ""
    var blogs = [Blog]()
}
