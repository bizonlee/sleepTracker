//
//  TabBarController.swift
//  sleepTracker
//
//  Created by Zhdanov Konstantin on 11.10.2024.
//

import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabs()
    }

    private func setupTabs() {
//        guard let recentVC = FileListAssembly.createModule(fileListType: .recent) as? UIViewController,
//              let allFilesVC = FileListAssembly.createModule(fileListType: .all) as? UIViewController,
//              let profileVC = ProfileAssembly.createModule() as? UIViewController else {
//            print("Ошибка")
//            return
//        }
        
        let dreamsVC = DreamsViewController()
        let staticticsVC = DreamsViewController()
        let settingsVC = DreamsViewController()

        let nav1 = UINavigationController(rootViewController: dreamsVC) // тут profileVC протокольного типа
        let nav2 = UINavigationController(rootViewController: staticticsVC)
        let nav3 = UINavigationController(rootViewController: settingsVC)

        nav1.tabBarItem = UITabBarItem(title: "СОН",
                                       image: UIImage(systemName: "person"),
                                       tag: 1)

        nav2.tabBarItem = UITabBarItem(title: "СТАТИСТИКА",
                                       image: UIImage(systemName: "doc.on.doc"),
                                       tag: 2)

        nav3.tabBarItem = UITabBarItem(title: "НАСТРОЙКИ",
                                       image: UIImage(systemName: "folder"),
                                       tag: 3)

        setViewControllers([nav1, nav2, nav3], animated: true)
    }
}
