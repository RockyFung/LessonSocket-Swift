//
//  ServerViewController.swift
//  LessonSocket-Swift
//
//  Created by rocky on 16/3/7.
//  Copyright © 2016年 RockyFung. All rights reserved.
//

import UIKit

class ServerViewController: UIViewController,GCDAsyncSocketDelegate {

    // textField
    var portTF:UITextField!
    var messageTF:UITextField!
    var textView:UITextView!
    // 服务器socket
    var serverSocket:GCDAsyncSocket!
    // 保存连接成功的客户端socket
    var clientSocket:GCDAsyncSocket!
    
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.translucent = false;
        // Do any additional setup after loading the view.
        
        
        let portLB = UILabel(frame: CGRectMake(20, 20, 80, 40))
        portLB.text = "端口号"
        portLB.textColor = UIColor.blackColor()
        self.view.addSubview(portLB)
        
        // 端口号
        portTF = UITextField(frame: CGRectMake(100, 20, 150, 40))
        portTF.text = "8000"
        portTF.backgroundColor = UIColor.grayColor()
        portTF.borderStyle = UITextBorderStyle.RoundedRect
        self.view.addSubview(portTF)
        
        // 监听
        let listen = UIButton(frame: CGRectMake(200, 20, 150, 40))
        listen.setTitle("监听", forState: UIControlState.Normal)
        listen.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        listen.addTarget(self, action: "listenAction:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(listen)
        
        // 发送消息
        messageTF = UITextField(frame: CGRectMake(20, 100, 200, 40))
        messageTF.borderStyle = UITextBorderStyle.RoundedRect
        messageTF.backgroundColor = UIColor.grayColor()
        self.view.addSubview(messageTF)
        
        let send = UIButton(frame: CGRectMake(220, 100, 100, 40))
        send.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        send.setTitle("发送消息", forState: UIControlState.Normal)
        send.addTarget(self, action: "sendAction:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(send)
        
        // 接收消息
        let textLB = UILabel(frame: CGRectMake(20, 200, 100, 40))
        textLB.text = "信息展示"
        textLB.textColor = UIColor.greenColor()
        self.view.addSubview(textLB)
        
        textView = UITextView(frame: CGRectMake(20, 250, 300, 400))
        textView.backgroundColor = UIColor.cyanColor()
        self.view.addSubview(textView)
        
        
    }

    // 监听
    func listenAction(btn: UIButton){
        // 1.创建服务器
        serverSocket = GCDAsyncSocket(delegate: self, delegateQueue: dispatch_get_main_queue())
        // 2.开始监听
//        var error:NSError! = nil
         let result = try? serverSocket.acceptOnPort(UInt16(portTF.text!)!)
        if result != nil {
            self.showTextViewWithText("开放监听成功")
        }else{
            self.showTextViewWithText("开放监听失败")
        }
    }
    
    
    // 注意：客户端socket是服务器socket代理方法中监听到客户端连接为客户端生产的
    // 发送消息
    func sendAction(btn: UIButton){
        let data:NSData = (messageTF.text?.dataUsingEncoding(NSUTF8StringEncoding))!
        clientSocket.writeData(data, withTimeout: -1, tag: 0)
    }
    
    
    // 展示消息
    func showTextViewWithText(text:NSString){
        textView.text = textView.text.stringByAppendingFormat("%@\n", text)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(false)
    }
    
    
////////////////////////////// socketDelegate
    
    // 监听到客户端socket链接
    // 当客户端链接成功后，生成一个新的客户端socket
    func socket(sock: GCDAsyncSocket!, didAcceptNewSocket newSocket: GCDAsyncSocket!) {
        showTextViewWithText("连接成功")
        // connectedHost:地址IP
        // connectedPort:端口
        showTextViewWithText(NSString(format: "连接地址:%@", newSocket.connectedHost))
        // 保存客户端socket
        clientSocket = newSocket
        clientSocket.readDataWithTimeout(-1, tag: 0)
    }
    
    
    // 成功读取客户端发过来的消息
    func socket(sock: GCDAsyncSocket!, didReadData data: NSData!, withTag tag: Int) {
        let message = NSString(data: data, encoding: NSUTF8StringEncoding)
        showTextViewWithText(message!)
        clientSocket.readDataWithTimeout(-1, tag: 0)
    }
    
    func socket(sock: GCDAsyncSocket!, didWriteDataWithTag tag: Int) {
        showTextViewWithText("消息发送成功")
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
