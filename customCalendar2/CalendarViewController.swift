//
//  DIYViewController.swift
//  FSCalendarSwiftExample
//
//  Created by dingwenchao on 06/11/2016.
//  Copyright © 2016 wenchao. All rights reserved.
//

import Foundation
import RealmSwift

class CalendarViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    var documentsUrl: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }

    
    fileprivate let gregorian = Calendar(identifier: .gregorian)
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    fileprivate let formatter2: DateFormatter = {
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "yyyyMMdd"
        return formatter2
    }()
    var today: String?
    var days: [String] = []
    
    fileprivate weak var calendar: FSCalendar!
    //fileprivate weak var eventLabel: UILabel!
    
    // MARK:- Life cycle
    
    override func loadView() {
        print("calendar - loadview")

        //        데이터베이스 미는용도
//                        let realm = try! Realm()
//                        try! realm.write {
//                            realm.deleteAll()
//                        }

        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor.groupTableViewBackground
        self.view = view
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        let height: CGFloat = UIDevice.current.model.hasPrefix("iPad") ? 770 : 300
        let calendar = FSCalendar(frame: CGRect(x: 0, y: self.navigationController!.navigationBar.frame.maxY, width: view.frame.size.width, height: height))
        calendar.dataSource = self
        calendar.delegate = self
        calendar.allowsMultipleSelection = true
        view.addSubview(calendar)
        self.calendar = calendar
        
        calendar.calendarHeaderView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        calendar.calendarWeekdayView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        calendar.appearance.headerTitleColor = UIColor.white
        calendar.appearance.weekdayTextColor = UIColor.white
       // calendar.appearance.eventSelectionColor = UIColor.blue
        calendar.appearance.titleOffset = CGPoint(x:15,y:-20)
        calendar.appearance.subtitleOffset = CGPoint(x:15, y:-10)
        
        
        /*calendar.headerHeight = calendar.headerHeight - 0.1
         
         print(calendar.headerHeight)
         print(calendar.weekdayHeight)
         */
        
        //calendar.appearance.eventOffset = CGPoint(x: 0, y: -7)
        //calendar.today = nil // Hide the today circle
        calendar.register(CalendarCell.self, forCellReuseIdentifier: "cell")
        
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)));
        calendar.addGestureRecognizer(longPressGesture)
        
        
        //        calendar.clipsToBounds = true // Remove top/bottom line
        
        //calendar.swipeToChooseGesture.isEnabled = true // Swipe-To-Choose
        
        /*let scopeGesture = UIPanGestureRecognizer(target: calendar, action: #selector(calendar.handleScopeGesture(_:)));
         calendar.addGestureRecognizer(scopeGesture)
         */
        
        /*let label = UILabel(frame: CGRect(x: 0, y: calendar.frame.maxY + 10, width: self.view.frame.size.width, height: 50))
         label.textAlignment = .left //hey daily event
         label.font = UIFont.preferredFont(forTextStyle: .subheadline)
         self.view.addSubview(label)
         self.eventLabel = label
         
         let attributedText = NSMutableAttributedString(string: "")
         let attatchment = NSTextAttachment()
         attatchment.image = UIImage(named: "icon_cat")!
         attatchment.bounds = CGRect(x: 0, y: -3, width: attatchment.image!.size.width, height: attatchment.image!.size.height)
         attributedText.append(NSAttributedString(attachment: attatchment))
         attributedText.append(NSAttributedString(string: "  Hey Daily Event  "))
         attributedText.append(NSAttributedString(attachment: attatchment))
         self.eventLabel.attributedText = attributedText
         */
    }
    
     @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer){
        
        var date: String?
        
        if (gestureRecognizer.state != UIGestureRecognizerState.ended){
            return
        }
        
        let p = gestureRecognizer.location(in: self.calendar.collectionView)
        
        if let indexPath = (self.calendar.collectionView.indexPathForItem(at: p)){
            let cell = self.calendar.collectionView.cellForItem(at: indexPath) as! FSCalendarCell
 
            date = self.formatter2.string(from: self.calendar.date(for: cell)!)
            print("this point is for test : \(date)")
            
            let oneday = 86400.0
            var nextday = self.formatter2.string(from: (self.calendar.date(for: cell)?.addingTimeInterval(oneday))!)
            days.append(date!)
            days.append(nextday)
            nextday = self.formatter2.string(from: (self.calendar.date(for: cell)?.addingTimeInterval(oneday*2))!)
            days.append(nextday)
            nextday = self.formatter2.string(from: (self.calendar.date(for: cell)?.addingTimeInterval(oneday*3))!)
            days.append(nextday)
            nextday = self.formatter2.string(from: (self.calendar.date(for: cell)?.addingTimeInterval(oneday*4))!)
            days.append(nextday)
            nextday = self.formatter2.string(from: (self.calendar.date(for: cell)?.addingTimeInterval(oneday*5))!)
            days.append(nextday)
            nextday = self.formatter2.string(from: (self.calendar.date(for: cell)?.addingTimeInterval(oneday*6))!)
            days.append(nextday)
            
        }else{
            print("error handling long press")
            return
        }
        
        print("days : \(days)")
        let collectionVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbWeekBoard") as! CollectionViewController
        collectionVC.days = days
        days = []
        //        popOverVC.canvas = self.calendar.cell(for: date, at: monthPosition)?.imageView.image
        //popOverVC.canvas = self.calendar(self.calendar, cellFor: date, at
        
        self.present(collectionVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Woong's Diary"
        // Uncomment this to perform an 'initial-week-scope'
        // self.calendar.scope = FSCalendarScopeWeek;
        
        /*let dates = [
         self.gregorian.date(byAdding: .day, value: -1, to: Date()),
         Date(),
         self.gregorian.date(byAdding: .day, value: 1, to: Date())
         ]
         dates.forEach { (date) in
         self.calendar.select(date, scrollToDate: false)
         }
         // For UITest
         self.calendar.accessibilityIdentifier = "calendar"
         */
    }
    
    // MARK:- FSCalendarDataSource
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position)
        //cell image
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        //self.configure(cell: cell, for: date, at: position)
    }
    
    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
        if self.gregorian.isDateInToday(date) {
            today = self.formatter2.string(from: date)
            return "오늘"
        }
        return nil
    }
    
    //날짜에 맞는 이미지 넣는 것 같음
    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
//        print("calendar - imagefor")
        let realm = try! Realm()
        let test: String?
        test = self.formatter2.string(from: date)
        var img: UIImage
        img = UIImage(named: "icon1")!
        let predicate = NSPredicate(format: "date = %@",test!)
        let day = realm.objects(cellinfo.self).filter(predicate).first
//        print(test)
        if(day?.filepath != nil){
            if(day?.filepath != ""){
                img = loads(fileName: (day!.filepath))!
            }
        }
        let img2 = resizeImage(image: img, targetSize: CGSize(width: 159.0,height: 104.0))
        return img2
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    private func loads(fileName: String) -> UIImage? {
        let fileURL = documentsUrl.appendingPathComponent(fileName)
        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
        } catch {
            print("Error loading image : \(error)")
        }
        return nil
    }
    /*func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
     
     }*/
    
    //calendar
    
    //subtitle 설정(공휴일)
    func calendar(_ calendar:FSCalendar, subtitleFor date: Date)-> String?{
//        print("calendar - subtitlefor")
        return ""
        //공휴일
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return 0
    }
    
    // MARK:- FSCalendarDelegate
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        //self.calendar.frame.size.height = bounds.height
        //self.eventLabel.frame.origin.y = calendar.frame.maxY + 10
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition)   -> Bool {
        return monthPosition == .current
    }
    
    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return monthPosition == .current
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did select date \(self.formatter.string(from: date))")
        print(self.formatter2.string(from: date))
        today = (self.formatter2.string(from: date))
        let thisday = cellinfo()
        thisday.date = self.formatter2.string(from: date)
        //self.configureVisibleCells()
        
        
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbPopUpID") as! PopUpViewController
        popOverVC.date = formatter2.string(from: date)
        
        
//        popOverVC.canvas = self.calendar.cell(for: date, at: monthPosition)?.imageView.image
        //popOverVC.canvas = self.calendar(self.calendar, cellFor: date, at monthPosition).imageView.image
        
        //error
        popOverVC.onSave = { (img) in
            self.calendar.reloadData()
            self.calendar.deselect(date)
        }
        
        popOverVC.cancel = { () in
            self.calendar.deselect(date)
        }
        self.present(popOverVC, animated: true)
        
        
        
        //popOverVC.view.frame = self.view.frame
        //self.view.addSubview(popOverVC.view)
        //popOverVC.didMove(toParentViewController: self)
        
    }
    
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date) {
        print("did deselect date \(self.formatter.string(from: date))")
        
        //self.configureVisibleCells()
    }
    

    
    
    
    /*func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
     if self.gregorian.isDateInToday(date) {
     return [UIColor.orange]
     }
     return [appearance.eventDefaultColor]
     }*/
    
    // MARK: - Private functions
    
    /*
     private func configureVisibleCells() {
     calendar.visibleCells().forEach { (cell) in
     let date = calendar.date(for: cell)
     let position = calendar.monthPosition(for: cell)
     self.configure(cell: cell, for: date!, at: position)
     }
     }*/
    
    /*private func configure(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {*/
    
    //let diyCell = (cell as! CalendarCell)
    // Custom today circle
    //diyCell.circleImageView.isHidden = !self.gregorian.isDateInToday(date)
    // Configure selection layer
    /*
     if position == .current {
     
     //var selectionType = SelectionType.none
     
     if calendar.selectedDates.contains(date) {
     let previousDate = self.gregorian.date(byAdding: .day, value: -1, to: date)!
     let nextDate = self.gregorian.date(byAdding: .day, value: 1, to: date)!
     if calendar.selectedDates.contains(date) {
     if calendar.selectedDates.contains(previousDate) && calendar.selectedDates.contains(nextDate) {
     selectionType = .middle
     }
     else if calendar.selectedDates.contains(previousDate) && calendar.selectedDates.contains(date) {
     selectionType = .rightBorder
     }
     else if calendar.selectedDates.contains(nextDate) {
     selectionType = .leftBorder
     }
     else {
     selectionType = .single
     }
     }
     }
     else {
     selectionType = .none
     }
     if selectionType == .none {
     //diyCell.selectionLayer.isHidden = true
     return
     }
     //diyCell.selectionLayer.isHidden = false
     diyCell.selectionType = selectionType
     
     } else {
     // diyCell.circleImageView.isHidden = true
     // diyCell.selectionLayer.isHidden = true
     }*/
    //}
    
}


