import Foundation


class AccountService {

    init(managedObjectContext: NSManagedObjectContext) {

    }

    func isPasswordlessAccount(_ username: String, success: ((Bool) -> ()), failure: ((NSError) -> ())) {
        
    }

    func connectToSocialService(_ service: SocialServiceName, serviceIDToken: String, success: (() -> ()), failure: ((NSError) -> ())) {

    }

    func defaultWordPressComAccount() -> WPAccount? {
        return nil
    }

    func isDefaultWordPressComAccount(_ account: WPAccount) -> Bool {
        return false
    }

    func requestAuthenticationLink(_ email: String, success: (() -> ()), failure: ((NSError) -> ())) {

    }

    func requestSignupLink(_ email: String, success: (() -> ()), failure: ((NSError) -> ())) {

    }
}

