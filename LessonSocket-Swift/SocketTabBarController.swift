//
//  SocketTabBarController.swift
//  LessonSocket-Swift
//
//  Created by rocky on 16/3/7.
//  Copyright © 2016年 RockyFung. All rights reserved.
//

import UIKit

class SocketTabBarController: UITabBarController {
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let serverNav = UINavigationController(rootViewController: ServerViewController())
        serverNav.tabBarItem.title = "服务器"
        self.addChildViewController(serverNav)
        
        let clientNav = UINavigationController(rootViewController: ClientViewController())
        clientNav.tabBarItem.title = "客户端"
        self.addChildViewController(clientNav)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
