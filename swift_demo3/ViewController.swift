 //
 //  ViewController.swift
 //  swift_demo3
 //
 //  Created by Tops on 5/23/15.
 //  Copyright (c) 2015 Tops. All rights reserved.
 //
 
 import UIKit
 import LocalAuthentication
 
 class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var tblview: UITableView!
    @IBOutlet var btnAdd: UIButton!
    
    
    var arrData:NSMutableArray!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.hidden=true
        var lpgr = UILongPressGestureRecognizer(target: self, action: "actionLongTap:")
        lpgr.minimumPressDuration = 1.0
        self.tblview.addGestureRecognizer(lpgr)
        
        /*
        UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
        initWithTarget:self action:@selector(handleLongPress:)];
        lpgr.minimumPressDuration = 2.0; //seconds
        lpgr.delegate = self;
        [self.myTableView addGestureRecognizer:lpgr];
        [lpgr release];*/
        
        /*   button code wokring but add the outlat button in xib
        let button   = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        button.frame = CGRectMake(259,8,40,30)
        button.backgroundColor = UIColor.greenColor()
        button.setTitle("Test Button", forState: UIControlState.Normal)
        button.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(button)
        */
        
        self.tblview.delegate=self
        arrData = NSMutableArray()
        arrData.addObject("Long tap to delete data")
        arrData.addObject("Your Defalt password is 123456")
        arrData.addObject("Enter you note and enjoy...")
        arrData.addObject("And give you feedback to developer")
    }
    func uthanticateUser()
    {
        let context : LAContext = LAContext()
        var error:NSError?
        var responceString = "Authentication is needed to add new notes."
        if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics,error:&error) {
            [context .evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics,localizedReason:responceString, reply: { (success: Bool, evalPolicyError: NSError?) -> Void in
                if success
                {
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        self.showAlert()
                    })
                }
                else{
                    println("Error code 1--->  \(evalPolicyError?.localizedDescription)")
                    
                    switch evalPolicyError!.code {
                        
                    case LAError.SystemCancel.rawValue:
                        println("Authentication was cancelled by the system")
                        
                    case LAError.UserCancel.rawValue:
                        println("Authentication was cancelled by the user")
                        
                    case LAError.UserFallback.rawValue:
                        println("User selected to enter custom password")
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            self.enterPassword()
                        })
                    default:
                        println("Authentication failed")
                        
                    }
                }
                
            })]
        }
        else{
            println("Error code 2--->  \(error?.localizedDescription)")
            
            switch error!.code {
                
            case LAError.SystemCancel.rawValue:
                println("Authentication was cancelled by the system")
            case LAError.UserCancel.rawValue:
                println("Authentication was cancelled by the user")
            case LAError.UserFallback.rawValue:
                println("User selected to enter custom password")
            default:
                println("Authentication failed")
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    self.enterPassword()
                })
            }
        }
        
    }
    //MARK: Button Actions
    @IBAction func btnAddClick(sender: AnyObject){
        uthanticateUser()
    }
    
    // Other button
    func buttonAction(sender:UIButton!)
    {
        println("hellow this is the button press")
        
    }
    
    //MARK: Tableiview Delegate and data source mathods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count;
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = self.tblview.dequeueReusableCellWithIdentifier("myCell") as! UITableViewCell
        cell.textLabel!.text=arrData.objectAtIndex(indexPath.row) as? String
        cell.contentView.backgroundColor=UIColor.whiteColor()
        cell.selectionStyle=UITableViewCellSelectionStyle.None
        return cell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println(" SELECT \(arrData.objectAtIndex(indexPath.row))")
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        println("DESELECT \(arrData.objectAtIndex(indexPath.row))")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: custom methods for showing error
    func showPasswordAlert()
    {
        SCLAlertView().showError("TouchID", subTitle: "Please type your password", closeButtonTitle: "Ok", duration: 0.0)
    }
    func showAlert()
    {
        let alert = SCLAlertView()
        let txt = alert.addTextField(title:"Please enter your list in the table.") as UITextField
        alert.addButton("Done", action: { () -> Void in
            println("heloo \(txt.text)")
            if (txt.text != ""){
                self.arrData.addObject(txt.text)
                self.tblview.reloadData() }
        })
        alert.showInfo("ADD", subTitle: "Please enter your text", closeButtonTitle: "Cancle", duration: 0.0);
    }
    func enterPassword()
    {
        let alert = SCLAlertView()
        let txt = alert.addTextField(title:"Enter your password") as UITextField
        txt.secureTextEntry=true
        alert.addButton("OK", action: { () -> Void in
            if (txt.text == "123456")
            { self.showAlert()}
            else{
                SCLAlertView().showError("Wrong", subTitle: "Please enter defalt password 123465", closeButtonTitle: "Ok", duration: 0.0);
            }
        })
        alert.showEdit("Password", subTitle:"Please enter your password-->(123456) ", closeButtonTitle:"Cancel", duration: 0.0)
    }
    func actionLongTap(gestureRecognizer:UIGestureRecognizer)
    {
        println("hellow this is the button press*****")
        if (gestureRecognizer.state == UIGestureRecognizerState.Began){
            var point = gestureRecognizer.locationInView(self.tblview) as CGPoint
            var indexpath = self.tblview.indexPathForRowAtPoint(point)
            if (indexpath != nil)
            {
                println("index path is --->\(indexpath?.row)")
                let alert = SCLAlertView()
                alert.addButton("Ok", action: { () -> Void in
                    if (self.arrData.count >= indexpath?.row)
                    {
                        self.arrData.removeObjectAtIndex(indexpath!.row)
                        self.tblview.reloadData()
                    }
                })
                alert.showError("DELETE", subTitle:"Are you sure you want to delete ?", closeButtonTitle: "No", duration: 0.0)
                
            }
        }
        
    }
    
 }
