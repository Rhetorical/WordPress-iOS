import Foundation


@objc protocol LoginFacadeDelegate {
    @objc func displayRemoteError(_ error: Error!)
    @objc func finishedLogin(withUsername username: String!, authToken: String!, requiredMultifactorCode: Bool)
}


class LoginFacade {
    var delegate: LoginFacadeDelegate?

    func signIn(with fields: LoginFields) {

    }

    func loginToWordPressDotCom(withUser user: Int, authType: String? = nil, twoStepCode: String? = nil, twoStepNonce: String? = nil) {

    }

    func loginToWordPressDotCom(withGoogleIDToken token: String) {

    }


    func requestSocial2FACode(with fields: LoginFields) {

    }

    func requestOneTimeCode(with fields: LoginFields) {

    }
}
