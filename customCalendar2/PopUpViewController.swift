//
//  PopUpViewController.swift
//  FSCalendarSwiftExample
//
//  Created by Hanung Lee on 22/07/2018.
//  Copyright © 2018 wenchao. All rights reserved.
//

import UIKit
import RealmSwift

class PopUpViewController: UIViewController {
    //MARK: Properties
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var tempImageView: UIImageView!
    
    var documentsUrl: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    var onSave: ((UIImage)->())?
    var canvas: UIImage?
    var cancel: (()->())?
    
    var lastPoint = CGPoint.zero // CGPoint.zeroPoint
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var black: CGFloat = 0.0
    var brushWidth: CGFloat = 3.0
    var opacity: CGFloat = 1.0
    var swiped = false
    var date:String?
    
    var widthForErase: CGFloat = 15.0
    var widthForBrush: CGFloat = 3.0
    
    
    let colors: [(CGFloat, CGFloat, CGFloat)] = [
        (1.0, 0, 0),
        (0, 1.0, 0),
        (0, 0, 1.0),
        (0, 0, 0),
        (1.0, 1.0, 1.0)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        데이터베이스 미는용도
//                let realm = try! Realm()
//                try! realm.write {
//                    realm.deleteAll()
//                }
        
        
        //mainImageView.image = UIImage(named: "icon1")
        
        let realm = try! Realm()
        let predicate = NSPredicate(format: "date = %@",date!)
        let day = realm.objects(cellinfo.self).filter(predicate).first
        if(day?.filepath != nil && day?.filepath != ""){
            mainImageView.image = load(fileName: (day!.filepath))
        }else{
            mainImageView.image = UIImage(named:"icon1")
        }
        
//        mainImageView.image = canvas
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = false
        if let touch = touches.first {
            lastPoint = touch.location(in: tempImageView)
        }
    }
    
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        //1
        UIGraphicsBeginImageContext(mainImageView.frame.size)
        let context = UIGraphicsGetCurrentContext()
        tempImageView.image?.draw(in: CGRect(x: 0, y: 0, width: mainImageView.frame.size.width, height: mainImageView.frame.size.height))
        
        
        //2
        context?.move(to: fromPoint)
        context?.addLine(to: toPoint)
        
        //3
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(brushWidth)
        context?.setStrokeColor(red: red, green: green, blue: blue, alpha: 1.0)
        context?.setBlendMode(CGBlendMode.normal)
        
        
        //4
        context?.strokePath()
        
        //5
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        tempImageView.alpha = opacity
        UIGraphicsEndImageContext()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //6
        swiped = true
        if let touch = touches.first {
            let currentPoint = touch.location(in: tempImageView)
            drawLineFrom(fromPoint: lastPoint, toPoint: currentPoint)
            
            //7
            lastPoint = currentPoint
        }
    }
    /*
     override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
     guard let touch = touches.first else { return }
     
     
     UIGraphicsBeginImageContextWithOptions(mainImageView.frame.size, false, 0.0)
     let context = UIGraphicsGetCurrentContext()
     
     // Draw previous image into context
     tempImageView.image?.draw(in: CGRect(x: 0, y: 0, width: mainImageView.frame.size.width, height: mainImageView.frame.size.height))
     
     // 1
     var touches = [UITouch]()
     
     // Coalesce Touches
     // 2
     if let coalescedTouches = event?.coalescedTouches(for: touch) {
     touches = coalescedTouches
     } else {
     touches.append(touch)
     }
     
     // 4
     for touch in touches {
     self.drawStroke(context: context, touch: touch)
     }
     
     // 1
     tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
     // 2
     /*if let predictedTouches = event?.predictedTouches(for: touch) {
     for touch in predictedTouches {
     self.drawStroke(context: context, touch: touch)
     }
     }
     
     // Update image
     tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
     */UIGraphicsEndImageContext()
     }
     
     private func drawStroke(context: CGContext!, touch: UITouch) {
     let previousLocation = touch.previousLocation(in: tempImageView)
     let location = touch.location(in: tempImageView)
     
     //var lineWidth: CGFloat
     /*  if touch.type == .stylus {
     // Calculate line width for drawing stroke
     if touch.altitudeAngle < self.tiltThreshold {
     lineWidth = self.lineWidthForShading(context: context, touch: touch)
     } else {
     lineWidth = self.lineWidthForDrawing(context: context, touch: touch)
     }
     // Set color
     self.drawColor.setStroke()
     //self.pencilTexture.setStroke()
     } else {
     // Erase with finger
     lineWidth = touch.majorRadius / 2
     self.eraserColor.setStroke()
     }*/
     
     context.setLineCap(CGLineCap.round)
     context.setLineWidth(brushWidth)
     context.setStrokeColor(red: red, green: green, blue: blue, alpha: 1.0)
     context.setBlendMode(CGBlendMode.normal)
     
     // Set up the points
     context.move(to: CGPoint(x: previousLocation.x, y: previousLocation.y))
     context.addLine(to: CGPoint(x: location.x, y: location.y))
     
     // Draw the stroke
     context.strokePath()
     }
     
     
     */
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !swiped {
            // draw a single point
            drawLineFrom(fromPoint: lastPoint, toPoint: lastPoint)
        }
        
        // Merge tempImageView into mainImageView
        UIGraphicsBeginImageContext(mainImageView.frame.size)
        mainImageView.image?.draw(in: CGRect(x: 0, y: 0, width: mainImageView.frame.size.width, height: mainImageView.frame.size.height), blendMode: CGBlendMode.normal, alpha: 1.0)
        tempImageView.image?.draw(in: CGRect(x: 0, y: 0, width: mainImageView.frame.size.width, height: mainImageView.frame.size.height), blendMode: CGBlendMode.normal, alpha: opacity)
        mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        tempImageView.image = nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let settingsViewController = segue.destination as! SettingsViewController
        settingsViewController.delegate = self
        settingsViewController.brush = brushWidth
        settingsViewController.opacity = opacity
        
        settingsViewController.red = red
        settingsViewController.green = green
        settingsViewController.blue = blue
    }
    
    //MARK: Actions
    
    @IBAction func reset(_ sender: Any) {
        mainImageView.image = UIImage(named: "icon1")
    }
    
    @IBAction func pencilPressed(_ sender: UIButton) {
        //1
        var index = sender.tag
        if index < 0 || index >= colors.count {
            index = 0
        }
        
        //2
        (red, green, blue) = colors[index]
        
        //3
        if index == colors.count - 1 {
            opacity = 1.0
            brushWidth = widthForErase
        }else {
            brushWidth = widthForBrush
        }
    }
    
    
    @IBAction func closePopUp(_ sender: Any) {
        print("clicked")
        
        if let img = mainImageView.image {
            //            let img2 = resizeImage(image: img, targetSize: CGSize(width: 158.5,height: 104.0))
            let realm = try! Realm()
            let predicate = NSPredicate(format: "date = %@",date!)
            var test = realm.objects(cellinfo.self).filter(predicate).first
            if(test == nil){
                test = cellinfo()
            }
            //            test.filepath = save(image: img)!
            if(test?.filepath != ""){
                try! realm.write{
                    test?.filepath = save(image: img)!
                    print("testpoint1")
                }
            }
            if(test?.filepath == ""){
                test?.date = date!
                test?.filepath = save(image: img)!
                try! realm.write{
                    realm.add(test!)
                    print("testpoint2")
                }
            }
            
            onSave?(img)
        }
        
        dismiss(animated: true)
    
    }
    
    @IBAction func cancelPopUp(_ sender: Any) {
        cancel?()
        dismiss(animated: true)
    }
    
    private func save(image: UIImage) -> String? {
        let fileName = date!
        let fileURL = documentsUrl.appendingPathComponent(fileName)
        if let imageData = UIImageJPEGRepresentation(image, 1.0) {
            try? imageData.write(to: fileURL, options: .atomic)
            return fileName // ----> Save fileName
        }
        
        print("Error saving image")
        return nil
    }
    
    private func load(fileName: String) -> UIImage? {
        let fileURL = documentsUrl.appendingPathComponent(fileName)
        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
        } catch {
            print("Error loading image : \(error)")
        }
        return nil
    }
    

    
}

extension PopUpViewController: SettingsViewControllerDelegate {
    func settingsViewControllerFinished(settingsViewController: SettingsViewController) {
        print("extentsion popup view")
        self.brushWidth = settingsViewController.brush
        //self.widthForBrush = self.brushWidth
        
        self.opacity = settingsViewController.opacity
        
        self.red = settingsViewController.red
        self.green = settingsViewController.green
        self.blue = settingsViewController.blue
    }
    
}
