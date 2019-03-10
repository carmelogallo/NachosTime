//
//  AppDelegate.swift
//  PopcornTime
//
//  Created by Carmelo Gallo on 28/09/2018.
//  Copyright © 2018 Carmelo Gallo. All rights reserved.
//

import UIKit
import Kingfisher
import Mockingjay

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        #if DEBUG
        // Kingfisher remove cache.
        let cache = ImageCache.default
        cache.clearMemoryCache()
        cache.clearDiskCache { print("Kingfisher cache removed") }

        // Checks if is running a ui test using launch arguments
        let processInfoArguments: [String] = ProcessInfo.processInfo.arguments
        if processInfoArguments.contains(LaunchArguments.StubNetworkResponses.rawValue) {
            // stubbing network layer
            configureNetworkStubbing()
        }

        // Checks if is running a unit test setting in our test scheme of main target to pass
        // a boolean value as launch argument in "Test" tab."-isRunningUnitTests YES"
        if isRunningUnitTests() {
            // stubbing network layer
            configureNetworkStubbing()
            // If we're running tests, don't launch the main storyboard as
            // it's confusing if that is running fetching content whilst the
            // tests are also doing so.
            let viewController = UIViewController()
            let label = UILabel()
            label.text = "Running tests..."
            label.frame = viewController.view.frame
            label.textAlignment = .center
            label.textColor = .white
            viewController.view.addSubview(label)
            self.window?.rootViewController = viewController
            return true
        }
        #endif
        
        let vc = SplashScreenViewController()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = vc
        window?.makeKeyAndVisible()

        return true
    }
}

// MARK: - Stubbing

private extension AppDelegate {
    
    func isRunningUnitTests() -> Bool {
        return UserDefaults.standard.bool(forKey: "isRunningUnitTests")
    }
    
    func configureNetworkStubbing() {
        stubConfiguration()
        stubGenres()
        stubMovies()
        stubCredits()
        stubSimilar()
        stubSearch()
    }
    
    func stubConfiguration() {
        let uri = "/3/configuration"
        let fixture = Bundle(for: type(of: self)).url(forResource: "configuration_successful", withExtension: "json")!
        let data = try! Data(contentsOf: fixture)
        MockingjayProtocol.addStub(matcher: matcher(uri: uri, method: .get), builder: jsonData(data))
    }
    
    func stubGenres() {
        let uri = "/3/genre/movie/list"
        let fixture = Bundle(for: type(of: self)).url(forResource: "genres_successful", withExtension: "json")!
        let data = try! Data(contentsOf: fixture)
        MockingjayProtocol.addStub(matcher: matcher(uri: uri, method: .get), builder: jsonData(data))
    }

    func stubMovies() {
        let uri = "/3/movie/now_playing"
        let fixture = Bundle(for: type(of: self)).url(forResource: "movies_successful", withExtension: "json")!
        let data = try! Data(contentsOf: fixture)
        MockingjayProtocol.addStub(matcher: matcher(uri: uri, method: .get), builder: jsonData(data))
    }

    func stubCredits() {
        let uri = "/3/movie/439079/credits"
        let fixture = Bundle(for: type(of: self)).url(forResource: "credits_successful", withExtension: "json")!
        let data = try! Data(contentsOf: fixture)
        MockingjayProtocol.addStub(matcher: matcher(uri: uri, method: .get), builder: jsonData(data))
    }

    func stubSimilar() {
        let uri = "/3/movie/439079/similar"
        let fixture = Bundle(for: type(of: self)).url(forResource: "similar_successful", withExtension: "json")!
        let data = try! Data(contentsOf: fixture)
        MockingjayProtocol.addStub(matcher: matcher(uri: uri, method: .get), builder: jsonData(data))
    }

    func stubSearch() {
        let uri = "/3/search/movie"
        let fixture = Bundle(for: type(of: self)).url(forResource: "movies_successful", withExtension: "json")!
        let data = try! Data(contentsOf: fixture)
        MockingjayProtocol.addStub(matcher: matcher(uri: uri, method: .get), builder: jsonData(data))
    }
    
    func matcher(uri: String, method: HTTPMethod) -> (_ request: URLRequest) -> Bool {
        return { request in
            let containUri = request.url?.path.contains(uri) ?? false
            var sameMethod = false
            if let httpMethod = request.httpMethod, httpMethod == method.description {
                sameMethod = true
            }
            return containUri && sameMethod
        }
    }

}
