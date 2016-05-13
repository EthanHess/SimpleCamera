//
//  ViewController.swift
//  SimpleCamera
//
//  Created by Ethan Hess on 5/13/16.
//  Copyright © 2016 Ethan Hess. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var flashButton = UIButton()
    var snapButton = UIButton()
    var camera = LLSimpleCamera()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
        self.camera.start()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.camera.view.frame = self.view.bounds
        self.snapButton.center = self.view.center
        self.snapButton.frame.origin.y = self.view.bounds.height - 90
        self.flashButton.center = self.view.center
        self.flashButton.frame.origin.y = 5.0

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setUpViews()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false);
        self.view.backgroundColor = UIColor.blackColor();
        
        let screenRect = UIScreen.mainScreen().bounds
        
        //set up the camera
        
        self.camera = LLSimpleCamera(quality: AVCaptureSessionPresetHigh, position: CameraPositionBack, videoEnabled: true)
        self.camera.attachToViewController(self, withFrame: CGRectMake(0, 0, screenRect.size.width, screenRect.size.height))
        self.camera.fixOrientationAfterCapture = true
        
        //determine whether flash is available
        
        self.camera.onDeviceChange = {(camera, device) -> Void in
            if camera.isFlashAvailable() {
                self.flashButton.hidden = false
                if camera.flash == CameraFlashOff {
                    self.flashButton.selected = false
                }
                else {
                    self.flashButton.selected = true
                }
            }
            else {
                self.flashButton.hidden = true
            }
        }
        
        
        setUpViews()
    }
    
    func setUpViews() {
        
        self.snapButton = UIButton(type: .Custom)
        self.snapButton.frame = CGRectMake(0, 0, 70.0, 70.0)
        self.snapButton.clipsToBounds = true
        self.snapButton.layer.cornerRadius = self.snapButton.frame.width / 2.0
        self.snapButton.layer.borderColor = UIColor.whiteColor().CGColor
        self.snapButton.layer.borderWidth = 3.0
        self.snapButton.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.6);
        self.snapButton.layer.rasterizationScale = UIScreen.mainScreen().scale
        self.snapButton.layer.shouldRasterize = true
        self.snapButton.addTarget(self, action: #selector(ViewController.snapButtonPressed), forControlEvents: .TouchUpInside)
        view.insertSubview(snapButton, atIndex: 0)
        self.view!.addSubview(self.snapButton)
        
        self.flashButton = UIButton(type: .System)
        self.flashButton.frame = CGRectMake(0, 0, 16.0 + 20.0, 24.0 + 20.0)
        self.flashButton.tintColor = UIColor.whiteColor()
        self.flashButton.setImage(UIImage(named: "camera-flash.png"), forState: .Normal)
        self.flashButton.imageEdgeInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)
        self.flashButton.addTarget(self, action: #selector(ViewController.flashButtonPressed), forControlEvents: .TouchUpInside)
        self.flashButton.hidden = true;
        self.view!.addSubview(self.flashButton)
        
        
    }
    
    func snapButtonPressed() {
        
        if(!camera.recording) {
            
            if(self.camera.position == CameraPositionBack && !self.flashButton.hidden) {
                self.flashButton.hidden = true
            }

            self.snapButton.layer.borderColor = UIColor.redColor().CGColor
            self.snapButton.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.5);
            // start recording
            let outputURL: NSURL = self.applicationDocumentsDirectory().URLByAppendingPathComponent("test1").URLByAppendingPathExtension("mov")
            self.camera.startRecordingWithOutputUrl(outputURL)
        }
        
        else {
            
            if(self.camera.position == CameraPositionBack && self.flashButton.hidden){
                self.flashButton.hidden = false;
            }

            self.snapButton.layer.borderColor = UIColor.whiteColor().CGColor
            self.snapButton.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5);
            
            self.camera.stopRecording({(camera, outputFileUrl, error) -> Void in
                
                let vc = PresentVideoViewController(videoUrl: outputFileUrl)
                
                self.navigationController!.pushViewController(vc, animated: true)
            })
        }
        
    }
    
    func flashButtonPressed(button: UIButton) {
        
        if self.camera.flash == CameraFlashOff {
            
            let done: Bool = self.camera.updateFlashMode(CameraFlashOn)
            if done {
                self.flashButton.selected = true
                self.flashButton.tintColor = UIColor.yellowColor();
            }
        }
        else {
            
            let done: Bool = self.camera.updateFlashMode(CameraFlashOff)
            if done {
                self.flashButton.selected = false
                self.flashButton.tintColor = UIColor.whiteColor();
            }
        }
    }
    
    func applicationDocumentsDirectory()-> NSURL {
        
        return NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).last!
    }
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return .Portrait
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

