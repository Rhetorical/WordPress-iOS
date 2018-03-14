import Foundation
import UIKit

class OnePasswordFacade {

    func findLogin(for url: String,
                   viewController: UIViewController,
                   sender: Any,
                   success: @escaping (_ username: String, _ password: String, _ otp: String?) -> Void,
                   failure: @escaping (OnePasswordError) -> Void) {

    }

    func createLogin(url: String = OnePasswordDefaults.dotcomURL,
                     username: String,
                     password: String,
                     title: String = OnePasswordDefaults.passwordTitle,
                     minimumLength: Int = OnePasswordDefaults.minimumLength,
                     maximumLength: Int = OnePasswordDefaults.maximumLength,
                     for viewController: UIViewController,
                     sender: Any,
                     success: @escaping (_ username: String, _ password: String) -> Void,
                     failure: @escaping (OnePasswordError) -> Void) {


    }

    static var isOnePasswordEnabled: Bool {
        return false
    }
}

enum OnePasswordDefaults {

    static let dotcomURL = "wordpress.com"
    static let minimumLength = 7
    static let maximumLength = 50
    static let passwordTitle = "WordPress"
}

enum OnePasswordError: Error {
    case cancelledByUser
    case failedToRetrieveCredentials
    case unknown

    init(error: NSError) {
        self = .unknown
    }
}

