import Foundation


class BlogSyncFacade {

    func syncBlog(withUsername: String, password: String, xmlrpc: String, options: [AnyHashable: Any], success: (Blog) -> Void) {
        
    }

    func syncBlogs(for: WPAccount, success: ()-> Void, failure: (Error) -> Void) {

    }
}
