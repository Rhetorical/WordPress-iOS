import Foundation


// MARK: - WordPressAuthenticationManager
//
class WordPressAuthenticationManager {

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    /// Helpshift is only available to the WordPress iOS App. Our Authentication Framework doesn't have direct access.
    /// We'll setup a mechanism to relay the `helpshiftUnreadCountWasUpdated` event back to the Authenticator.
    ///
    func startRelayingHelpshiftNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(helpshiftUnreadCountWasUpdated), name: .HelpshiftUnreadCountUpdated, object: nil)
    }
}


// MARK: - Notification Handlers
//
extension WordPressAuthenticationManager {

    @objc
    func helpshiftUnreadCountWasUpdated(_ notification: Foundation.Notification) {
        WordPressAuthenticator.shared.supportBadgeCountWasUpdated()
    }
}


// MARK: - WordPressAuthenticator Delegate
//
extension WordPressAuthenticationManager: WordPressAuthenticatorDelegate {

    /// Indicates if the active Authenticator can be dismissed, or not. Authentication is Dismissable when there is a
    /// default wpcom account, or at least one self-hosted blog.
    ///
    var dismissActionEnabled: Bool {
        let context = ContextManager.sharedInstance().mainContext
        let blogService = BlogService(managedObjectContext: context)

        return AccountHelper.isDotcomAvailable() || blogService.blogCountForAllAccounts() > 0
    }

    /// Indicates whether if the Support Action should be enabled, or not.
    ///
    var supportActionEnabled: Bool {
        return true
    }

    /// Indicates if Helpshift is Enabled.
    ///
    var livechatActionEnabled: Bool {
        return HelpshiftUtils.isHelpshiftEnabled()
    }

    /// Returns Helpshift's Unread Messages Count.
    ///
    var supportBadgeCount: Int {
        return HelpshiftUtils.unreadNotificationCount()
    }

    /// Refreshes Helpshift's Unread Count.
    ///
    func refreshSupportBadgeCount() {
        HelpshiftUtils.refreshUnreadNotificationCount()
    }

    /// Returns an instance of SupportViewController, configured to be displayed from a specified Support Source.
    ///
    func presentSupport(from sourceViewController: UIViewController, sourceTag: WordPressSupportSourceTag, options: [String: Any] = [:]) {
        let supportViewController = SupportViewController()
        supportViewController.sourceTag = sourceTag.toSupportSourceTag()
        supportViewController.helpshiftOptions = options

        let navController = UINavigationController(rootViewController: supportViewController)
        navController.navigationBar.isTranslucent = false
        navController.modalPresentationStyle = .formSheet

        sourceViewController.present(navController, animated: true, completion: nil)
    }

    /// Presents Helpshift, with the specified ViewController as a source. Additional metadata is supplied, such as the sourceTag and Login details.
    ///
    func presentLivechat(from sourceViewController: UIViewController, sourceTag: WordPressSupportSourceTag, options: [String: Any]) {
        let presenter = HelpshiftPresenter()
        presenter.sourceTag = sourceTag.toSupportSourceTag()
        presenter.optionsDictionary = options
        presenter.presentHelpshiftConversationWindowFromViewController(sourceViewController,
                                                                       refreshUserDetails: true,
                                                                       completion: nil)
    }

    /// Presents the Login Epilogue, in the specified NavigationController.
    ///
    func presentLoginEpilogue(in navigationController: UINavigationController, for endpoint: WordPressEndpoint, onDismiss: @escaping () -> Void) {
        let storyboard = UIStoryboard(name: "LoginEpilogue", bundle: .main)
        guard let epilogueViewController = storyboard.instantiateInitialViewController() as? LoginEpilogueViewController else {
            fatalError()
        }

        epilogueViewController.endpoint = endpoint
        epilogueViewController.onDismiss = onDismiss

        navigationController.pushViewController(epilogueViewController, animated: true)
    }

    /// Synchronizes the specified WordPress Account.
    ///
    func sync(endpoint: WordPressEndpoint, onCompletion: @escaping (Error?) -> ()) {
        switch endpoint {
        case .wpcom(let username, let authToken, let isJetpackLogin, _):
            syncWPCom(username: username, authToken: authToken, isJetpackLogin: isJetpackLogin, onCompletion: onCompletion)
        case .wporg(let username, let password, let xmlrpc, let options):
            syncWPOrg(username: username, password: password, xmlrpc: xmlrpc, options: options, onCompletion: onCompletion)
        }
    }
}


// MARK: - WordPressAuthenticatorManager
//
private extension WordPressAuthenticationManager {

    /// Synchronizes a WordPress.com account with the specified credentials.
    ///
    private func syncWPCom(username: String, authToken: String, isJetpackLogin: Bool, onCompletion: @escaping (Error?) -> ()) {
        let service = WordPressComSyncService()

        service.syncWPCom(username: username, authToken: authToken, isJetpackLogin: isJetpackLogin, onSuccess: { account in

            /// HACK: An alternative notification to LoginFinished. Observe this instead of `WPSigninDidFinishNotification` for Jetpack logins.
            /// When WPTabViewController no longer destroy's and rebuilds the view hierarchy this alternate notification can be removed.
            ///
            let notification = isJetpackLogin == true ? .wordpressLoginFinishedJetpackLogin : Foundation.Notification.Name(rawValue: WordPressAuthenticator.WPSigninDidFinishNotification)
            NotificationCenter.default.post(name: notification, object: account)

            onCompletion(nil)

        }, onFailure: { error in
            onCompletion(error)
        })
    }

    /// Synchronizes a WordPress.org account with the specified credentials.
    ///
    private func syncWPOrg(username: String, password: String, xmlrpc: String, options: [AnyHashable: Any], onCompletion: @escaping (Error?) -> ()) {
        let service = BlogSyncFacade()

        service.syncBlog(withUsername: username, password: password, xmlrpc: xmlrpc, options: options) { blog in
            RecentSitesService().touch(blog: blog)
            onCompletion(nil)
        }
    }
}
