//
//  PresentVideoViewController.swift
//  SimpleCamera
//
//  Created by Ethan Hess on 5/13/16.
//  Copyright © 2016 Ethan Hess. All rights reserved.
//

import UIKit
import AVFoundation

class PresentVideoViewController: UIViewController {
    
    var videoUrl = NSURL()
    var avPlayer = AVPlayer()
    var avPlayerLayer = AVPlayerLayer()
    var backButton = UIButton()
    
    convenience init(videoUrl url: NSURL) {
        self.init()
        
        self.videoUrl = url
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
        self.avPlayer.play()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        // the video player
        let item = AVPlayerItem(URL: self.videoUrl);
        self.avPlayer = AVPlayer(playerItem: item);
        self.avPlayer.actionAtItemEnd = .None
        self.avPlayerLayer = AVPlayerLayer(player: self.avPlayer);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PresentVideoViewController.playerItemDidReachEnd(_:)), name: AVPlayerItemDidPlayToEndTimeNotification, object: self.avPlayer.currentItem!)
        
        let screenRect: CGRect = UIScreen.mainScreen().bounds
        
        self.avPlayerLayer.frame = CGRectMake(0, 0, screenRect.size.width, screenRect.size.height)
        self.view.layer.addSublayer(self.avPlayerLayer)
        
        self.backButton.addTarget(self, action: #selector(PresentVideoViewController.backButtonPressed(_:)), forControlEvents: .TouchUpInside)
        self.backButton.frame = CGRectMake(7, 13, 65, 30)
        self.backButton.layer.borderColor = UIColor.whiteColor().CGColor;
        self.backButton.layer.borderWidth = 2;
        self.backButton.layer.cornerRadius = 5;
        self.backButton.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 13);
        self.backButton.setTitle("Back", forState: .Normal)
        self.backButton.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        self.backButton.layer.shadowColor = UIColor.blackColor().CGColor
        self.backButton.layer.shadowOffset = CGSizeMake(0.0, 0.0)
        self.backButton.layer.shadowOpacity = 0.4
        self.backButton.layer.shadowRadius = 1.0
        self.backButton.clipsToBounds = false
        
        self.view!.addSubview(self.backButton)
    }
    
    func playerItemDidReachEnd(notification: NSNotification) {
        
        self.avPlayer.seekToTime(kCMTimeZero);
    }
    
    func backButtonPressed(button: UIButton) {
        
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        
        return true;
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
