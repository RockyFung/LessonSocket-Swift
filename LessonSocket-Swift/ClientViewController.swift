//
//  ClientViewController.swift
//  LessonSocket-Swift
//
//  Created by rocky on 16/3/7.
//  Copyright © 2016年 RockyFung. All rights reserved.
//

import UIKit

class ClientViewController: UIViewController,GCDAsyncSocketDelegate {
    var ipTF:UITextField!
    var portTF:UITextField!
    var messageTF:UITextField!
    var textView:UITextView!
    // 客户端socket
    var clientSocket:GCDAsyncSocket!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.translucent = false;
        // Do any additional setup after loading the view.
        
        // IP
        let ipLB = UILabel(frame: CGRectMake(20, 20, 80, 40))
        ipLB.text = "IP";
        self.view.addSubview(ipLB)
        
        ipTF = UITextField(frame: CGRectMake(100, 20, 150, 40))
        ipTF.text = "127.0.0.1"
        ipTF.borderStyle = UITextBorderStyle.RoundedRect
        ipTF.backgroundColor = UIColor.grayColor()
        self.view.addSubview(ipTF)
        
        // 端口号
        let portLB = UILabel(frame: CGRectMake(20, 100, 80, 40))
        portLB.text = "端口号"
        portLB.textColor = UIColor.blackColor()
        self.view.addSubview(portLB)
        
       
        portTF = UITextField(frame: CGRectMake(100, 100, 150, 40))
        portTF.text = "8000"
        portTF.backgroundColor = UIColor.grayColor()
        portTF.borderStyle = UITextBorderStyle.RoundedRect
        self.view.addSubview(portTF)
        
        // 连接
        let connect = UIButton(frame: CGRectMake(210, 50, 150, 40))
        connect.setTitle("连接", forState: UIControlState.Normal)
        connect.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        connect.addTarget(self, action: "connectAction:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(connect)
        
        // 发送消息
        messageTF = UITextField(frame: CGRectMake(20, 180, 200, 40))
        messageTF.borderStyle = UITextBorderStyle.RoundedRect
        messageTF.backgroundColor = UIColor.grayColor()
        self.view.addSubview(messageTF)
        
        let send = UIButton(frame: CGRectMake(220, 180, 100, 40))
        send.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        send.setTitle("发送消息", forState: UIControlState.Normal)
        send.addTarget(self, action: "sendAction:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(send)
        
        // 接收消息
        let textLB = UILabel(frame: CGRectMake(20, 250, 100, 40))
        textLB.text = "信息展示"
        textLB.textColor = UIColor.greenColor()
        self.view.addSubview(textLB)
        
        textView = UITextView(frame: CGRectMake(20, 300, 300, 400))
        textView.backgroundColor = UIColor.cyanColor()
        self.view.addSubview(textView)

        
    }
    
    // 点击客户端连接方法后创建客户端socket代码：创建客户端socket连接的时候必须指定服务器地址和服务的端口号，才能连接成功服务器端监听的socket。
    // 连接
    func connectAction(btn:UIButton){
        clientSocket = GCDAsyncSocket(delegate: self, delegateQueue: dispatch_get_main_queue())
        let result = try? clientSocket.connectToHost(ipTF.text, onPort: UInt16(portTF.text!)!)
        if result != nil{
            showTextViewWithText("开放监听成功")
        }else{
            showTextViewWithText("开放监听失败")
        }
    }

    // 发送消息
    func sendAction(btn: UIButton){
        let data:NSData = (messageTF.text?.dataUsingEncoding(NSUTF8StringEncoding))!
        clientSocket.writeData(data, withTimeout: -1, tag: 0)
    }
    
    
    // 展示消息
    func showTextViewWithText(text:NSString){
        textView.text = textView.text.stringByAppendingFormat("%@\n", text)
    }
    
    // socketDelegate
    // 客户端连接服务器成功
    func socket(sock: GCDAsyncSocket!, didConnectToHost host: String!, port: UInt16) {
        showTextViewWithText(NSString(format: "连接服务器成功:%@", host))
        clientSocket.readDataWithTimeout(-1, tag: 0)
    }
    
    func socket(sock: GCDAsyncSocket!, didWriteDataWithTag tag: Int) {
        showTextViewWithText("消息发送成功")
    }
    
    // 成功读取客户端发过来的消息
    func socket(sock: GCDAsyncSocket!, didReadData data: NSData!, withTag tag: Int) {
        let message = NSString(data: data, encoding: NSUTF8StringEncoding)
        showTextViewWithText(message!)
        clientSocket.readDataWithTimeout(-1, tag: 0)
    }
    
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(false)
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
