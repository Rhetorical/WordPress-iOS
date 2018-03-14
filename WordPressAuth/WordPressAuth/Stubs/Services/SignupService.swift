import Foundation
import CocoaLumberjack
import WordPressShared


/// Individual cases represent each step in the signup process.
///
enum SignupStatus: Int {
    case validating
    case creatingUser
    case authenticating
    case creatingBlog
    case syncing
}

typealias SignupStatusBlock = (_ status: SignupStatus) -> Void
typealias SignupSuccessBlock = () -> Void
typealias SignupFailureBlock = (_ error: Error?) -> Void


/// SignupService is responsible for creating a new WPCom user and blog.
/// The entry point is `createBlogAndSigninToWPCom` and the service takes care of the rest.
///
open class SignupService: NSObject {

    init(managedObjectContext: NSManagedObjectContext) {

    }


    func createBlogAndSigninToWPCom(blogURL url: String,
                                            blogTitle: String,
                                            emailAddress: String,
                                            username: String,
                                            password: String,
                                            status: @escaping SignupStatusBlock,
                                            success: @escaping SignupSuccessBlock,
                                            failure: @escaping SignupFailureBlock) {

    }


    typealias SignupSocialSuccessBlock = (_ newAccount: Bool) -> Void
    typealias SignupFailureBlock = (_ error: Error?) -> Void
    
    func createWPComUserWithGoogle(token: String,
                                   success: @escaping SignupSocialSuccessBlock,
                                   failure: @escaping SignupFailureBlock) {

    }


    /// An internal struct for conveniently sharing params between the different
    /// sign up steps.
    ///
    struct SignupParams {

        // Email address for wpcom account.
        var email: String

        // wpcom username
        var username: String

        // wpcom password
        var password: String
    }


    /// A convenience enum for creating meaningful NSError objects.
    ///
    enum SignupError: Error {
        case invalidResponse
        case missingRESTAPI
        case missingDefaultWPComAccount
    }

    /// A convenience struct for response keys
    private struct ResponseKeys {
        static let bearerToken = "bearer_token"
        static let username = "username"
    }
}
