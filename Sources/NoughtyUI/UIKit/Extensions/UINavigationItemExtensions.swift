import UIKit

public extension UINavigationItem {
    /**
     Sets title for back button.

     - Parameters:
        - title: Back button title, pass `nil` to get the default behaviour.

     Creates `backBarButtonItem` if it does not exist, then sets its title
     If you want to remove back button title do it for previous screen.
     It is expected behavior of how UINavigationBar works with UINavigationItem.

     - Important: Call it after you set `title`, `navigationTitle`, `tabBarTitle` as those will override backButtonItem title property.
    */
    func setBackButtonTitle(title: String?) {
        if backBarButtonItem == nil {
            backBarButtonItem = UIBarButtonItem(title: nil,
                                                style: .plain,
                                                target: nil,
                                                action: nil)
        }
        backBarButtonItem?.title = title
    }

    /**
     Sets default back button title

     Sets `backBarButtonItem.title` to `navigationItem.title`
    */
    func setDefaultBackButtonTitle() {
        setBackButtonTitle(title: title)
    }

    /// Sets back button title to an empty string
    func removeBackButtonTitle() {
        setBackButtonTitle(title: "")
    }
}
