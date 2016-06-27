//
//  ViewController.h
//  LimitlessBackground
//
//  Created by Yifan Lu on 12/17/13.
//  Copyright (c) 2013 Yifan Lu. All rights reserved.
//
import UIKit
import AVFoundation
import CoreLocation
class ViewController: UIViewController, CLLocationManagerDelegate {
     let geocoder = CLGeocoder()
       var player: AVPlayer?
       var bool = true
    var time = ""
    let locationManager = CLLocationManager()
    var lattitude: NSDate?
    
    
    @IBAction func buttonClicked(sender: AnyObject) {
        // we enable backgrounding when the player plays
        // this can be done with a button (like here)
        // or when the view is loaded
        self.player!.play()
        NSThread(target: self, selector: #selector(ViewController.task(_:)), object: nil).start()

    }

    @IBOutlet weak var lblCounter: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.locationManager.delegate = self
        self.getLocation()
        
        var sessionError: NSError? = nil
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
            
        } catch {
            
        }
       // let path = NSBundle.mainBundle().pathForResource("Property List", ofType: "plist")
        
        let path: NSURL = NSURL(string: NSBundle.mainBundle().pathForResource("silence", ofType: "mp3")!)!
        
     // var item: AVPlayerItem = AVPlayerItem.playerItemWithURL(NSBundle.mainBundle()(URLForResource: "silence", withExtension: "mp3"))
        
      let item = AVPlayerItem(URL: path)
      self.player = AVPlayer(playerItem: item)
        
        self.player!.actionAtItemEnd = .None
        
           }
    

    func task(args: AnyObject) {
        var counter  = 0

        while bool {
            
            
            NSLog("We are still running...")
            dispatch_async(dispatch_get_main_queue(), {
                 self.locationManager.startUpdatingLocation()
                 self.lblCounter.text = self.time
                

            })
           
            counter += 1
          
            sleep(1)
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
            }
    
    func getLocation(){
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.startUpdatingLocation()
      
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
       
        self.lattitude = location!.timestamp
        self.time = self.timeFormatter(self.lattitude!)
        
        self.locationManager.stopUpdatingLocation()
        
        
    }
    

    func timeFormatter(dateTime: NSDate) -> String{
        
        let formatter = NSDateFormatter()
        
        formatter.calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierISO8601)
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        formatter.dateFormat = "HH:mm:ss a"
        //        formatter.timeStyle = NSDateFormatterStyle.MediumStyle
        //        formatter.dateStyle = NSDateFormatterStyle.MediumStyle
        
        return formatter.stringFromDate(dateTime)
        
    }

    func reduceDecimalValue(latORlong: Double) -> String {
        
        let fomartter = NSNumberFormatter()
        fomartter.maximumFractionDigits = 6
        fomartter.roundingMode = NSNumberFormatterRoundingMode.RoundDown
        let u = fomartter.stringFromNumber(latORlong)
        return u!
    }

  
}
