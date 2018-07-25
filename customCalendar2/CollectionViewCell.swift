//
//  CollectionViewCell.swift
//  customCalendar2
//
//  Created by 예주 on 2018. 7. 24..
//  Copyright © 2018년 Hanung Lee. All rights reserved.
//

import UIKit
import RealmSwift


//set protocol
protocol CollectionViewDelegate : class{
    func pushDate(cell: CollectionViewCell)
}


class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var tempImageView: UIImageView!
    @IBOutlet weak var Diary: UITextView!
    @IBOutlet weak var Edit: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var editStack: UIStackView!
    @IBOutlet weak var saveStack: UIStackView!
    @IBOutlet weak var resetStack: UIStackView!
    @IBOutlet weak var brushStack: UIStackView!
    @IBOutlet weak var todayDate: UILabel!
    
    var documentsUrl: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    weak var delegate: CollectionViewDelegate?
    
    var lastPoint = CGPoint.zero // CGPoint.zeroPoint
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var black: CGFloat = 0.0
    var brushWidth: CGFloat = 6.0
    var opacity: CGFloat = 1.0
    var swiped = false
    var date:String?
    var brushPressed = false
    
    var widthForErase: CGFloat = 15.0
    
    let colors: [(CGFloat, CGFloat, CGFloat)] = [
        (1.0, 0, 0),
        (0, 1.0, 0),
        (0, 0, 1.0),
        (0, 0, 0),
        (1.0, 1.0, 1.0)
    ]
    
    let width: [CGFloat] = [3.0, 6.0, 9.0]
    
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
    //MARK: Actions
    
    
    @IBAction func addDiary(_ sender: Any) {
        self.delegate?.pushDate(cell: self)
    }
    
    
    @IBAction func editPressed(_ sender: UIButton) {
        print(tempImageView.isUserInteractionEnabled)
        print(mainImageView.isUserInteractionEnabled)
        if(tempImageView.isUserInteractionEnabled == true){
            tempImageView.isUserInteractionEnabled = false
        }
        else{
            tempImageView.isUserInteractionEnabled = true
        }
        for i in 0...5 {
            stackView.arrangedSubviews[i].isHidden = false
        }
        editStack.arrangedSubviews[0].isHidden = true
        saveStack.arrangedSubviews[0].isHidden = false
        resetStack.arrangedSubviews[0].isHidden = false
    }
    
    @IBAction func reset(_ sender: UIButton) {
        mainImageView.image = UIImage(named: "background")
    }
    
    @IBAction func pencilPressed(_ sender: UIButton) {
        var index = sender.tag
        if index < 0 || index >= colors.count {
            index = 0
        }
        
        (red, green, blue) = colors[index]
        
        if index == colors.count - 1 {
            opacity = 1.0
            brushWidth = widthForErase
        }
    }
    
    @IBAction func brushPressed(_ sender: UIButton) {
        if brushPressed {
            for i in 0...2 {
                brushStack.arrangedSubviews[i].isHidden = true
            }
            brushPressed = false
        }
        else {
            for i in 0...2 {
                brushStack.arrangedSubviews[i].isHidden = false
            }
            brushPressed = true
        }
    }
    
    @IBAction func brushWidth(_ sender: UIButton) {
        var index = sender.tag
        if index < 0 || index >= width.count {
            index = 0
        }
        
        brushWidth = width[index]
        
        for i in 0...2 {
            brushStack.arrangedSubviews[i].isHidden = true
        }
        brushPressed = false
        
    }
    
    
    
    @IBAction func saveDetail(_ sender: UIButton){
        
        if let img = mainImageView.image {
            //            let img2 = resizeImage(image: img, targetSize: CGSize(width: 158.5,height: 104.0))
            let realm = try! Realm()
            let predicate = NSPredicate(format: "date = %@",date!)
            var test = realm.objects(cellinfo.self).filter(predicate).first
            if(test == nil){
                test = cellinfo()
            }
            //            test.filepath = save(image: img)!
            if(test?.date == nil){
                test?.date = date!
                test?.detail = save(image: img)!
                try! realm.write{
                    realm.add(test!)
                    print("testpoint2")
                }
            }
            else if(test?.detail != "" || (test?.filepath != "" && test?.detail == "")){
                try! realm.write{
                    test?.detail = save(image: img)!
                    print("testpoint1")
                }
            }
        }
        
        for i in 0...5 {
            stackView.arrangedSubviews[i].isHidden = true
        }
        editStack.arrangedSubviews[0].isHidden = false
        saveStack.arrangedSubviews[0].isHidden = true
        resetStack.arrangedSubviews[0].isHidden = true
    }
    
    private func save(image: UIImage) -> String? {
        let fileName = date!+"detail"
        let fileURL = documentsUrl.appendingPathComponent(fileName)
        if let imageData = UIImageJPEGRepresentation(image, 1.0) {
            try? imageData.write(to: fileURL, options: .atomic)
            return fileName // ----> Save fileName
        }
        
        print("Error saving image")
        return nil
    }
    
    //call delegate and perform protocol
    
    
}


