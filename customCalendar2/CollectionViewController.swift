//
//  CollectionViewController.swift
//  customCalendar2
//
//  Created by 예주 on 2018. 7. 24..
//  Copyright © 2018년 Hanung Lee. All rights reserved.
//

import UIKit
//import AnimatedCollectionViewLayout
import RealmSwift
import Darwin

private let reuseIdentifier = "MyCell"

class CollectionViewController: UICollectionViewController {
    
    var documentsUrl: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    var date:String?
    var days: [String] = []
    var carImages = [String]()
//    var animator: (LayoutAttributesAnimator, Bool, Int, Int)?
    var Test: Int = 0
    var textExamples = [String]()
    var daily: [UIImage] = []
    var detail: [UIImage] = []
    var titles: [String] = []
    var empty: UIImage?
    var empty2: UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0...6{
            var dailyfile: String = ""
            var detailfile: String = ""
            empty = UIImage(named: "icon1")!
            empty2 = UIImage(named: "background")!
            let realm = try! Realm()
            let predicate = NSPredicate(format: "date = %@",days[i])
            let day = realm.objects(cellinfo.self).filter(predicate).first
            let note = realm.objects(memo.self).filter(predicate).first
            
            if(day?.date != nil){
                if(day?.filepath != "" && day?.detail != ""){
                    dailyfile = (day!.filepath)
                    detailfile = (day!.detail)
                    daily.append(load(fileName: dailyfile)!)
                    detail.append(load(fileName: detailfile)!)
                }
                else if(day?.filepath != "" && day?.detail == ""){
                    dailyfile = (day!.filepath)
                    daily.append(load(fileName: dailyfile)!)
                    detail.append(empty2!)
                }
                else if(day?.filepath == "" && day?.detail != ""){
                    daily.append(empty!)
                    detailfile = day!.detail
                    detail.append(load(fileName: detailfile)!)
                }
            }
            else{
                daily.append(empty!)
                detail.append(empty2!)
            }
            if(note?.title != "" && note?.title != nil){
                titles.append((note?.title)!)
            }
            else{
                titles.append("")
            }
        }
//        print(daily)
//        print(detail)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        //      self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier) // 주석처리
        
        // Do any additional setup after loading the view.
        
        carImages = ["image1.jpg", "image2.jpg", "image3.jpg", "image1.jpg", "image2.jpg", "image3.jpg", "image1.jpg"]
        
        textExamples = ["Hello", "How are you", "Let's go home", "I want to be rich", "WOW", "AMAZING", "FANTASTIC"]
        
        self.collectionView?.isPagingEnabled = false
        self.collectionView?.isScrollEnabled = true
        
//            animator = (LinearCardAttributesAnimator(), false, 1, 1)
//
//            if let layout = self.collectionView?.collectionViewLayout as? AnimatedCollectionViewLayout {
//                layout.animator = animator?.0
//            }
        
        if let layout = self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    @IBAction func didSwipeDown(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return carImages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("did select date \(days[indexPath.row])")
        
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbPopUpID") as! PopUpViewController
        popOverVC.date = days[indexPath.row]
        
        popOverVC.onSave = { (img) in
            //            self.calendar.reloadData()
        }
        
        self.present(popOverVC, animated: true)
    }
    
    
    @objc func tappedMe()
    {
        print("Tapped on Image")
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbPopUpID") as! PopUpViewController
        popOverVC.date = date
        
        
        //        popOverVC.canvas = self.calendar.cell(for: date, at: monthPosition)?.imageView.image
        //popOverVC.canvas = self.calendar(self.calendar, cellFor: date, at monthPosition).imageView.image
        
        //error
        popOverVC.onSave = { (img) in
//            self.calendar.reloadData()
        }
        
        self.present(popOverVC, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
        //        let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
        // Configure the cell
        
        print(days[0])
        
        
        if(Test < 7){
//            date = days[Test]
//            let tap = UITapGestureRecognizer(target: self, action: #selector(CollectionViewController.tappedMe))
//            cell.imageView.addGestureRecognizer(tap)
//            cell.imageView.isUserInteractionEnabled = true
            
            for i in 0...5 {
                cell.stackView.arrangedSubviews[i].isHidden = true
            }
            
            for i in 0...2 {
                cell.brushStack.arrangedSubviews[i].isHidden = true
            }
            
            cell.saveStack.arrangedSubviews[0].isHidden = true
            cell.resetStack.arrangedSubviews[0].isHidden = true
            cell.todayDate.text = days[Test]
            cell.Diary.isEditable = false
            
//            let image = UIImage(named: "icon1")
//            let image2 = UIImage(named: "background")
//            cell.imageView.image = image
//            cell.mainImageView.image = image2
            cell.date = days[Test]
            cell.tempImageView.isUserInteractionEnabled = false
            cell.mainImageView.isUserInteractionEnabled = false
            cell.Diary.text = titles[Test]
            cell.imageView.image = daily[Test]
            cell.mainImageView.image = detail[Test]
            
        }
        
        Test += 1
        
        //        cell.today.text = (String)((Int)(date!)! + Test)
        
        cell.delegate = self
        
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MyHeader", for: indexPath)
        return headerView
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
    
    
    @IBAction func editPressed(_ sender: UIButton) {
        if(self.collectionView?.isScrollEnabled == true){
            self.collectionView?.isScrollEnabled = false
        }
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        if(self.collectionView?.isScrollEnabled == false) {
            self.collectionView?.isScrollEnabled = true
        }
    }

    @IBAction func closeDetail(_ sender: UIButton) {
        Test = 0
        dismiss(animated: true, completion: nil)
    }
    

    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
}

//make extension
extension CollectionViewController: CollectionViewDelegate{
    func pushDate(cell: CollectionViewCell) {
        let date = cell.date
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addDiaryVC = storyboard.instantiateViewController(withIdentifier: "addDiaryVC") as! AddDiaryViewController
        
        addDiaryVC.date = date
        self.present(addDiaryVC, animated: true)
        
    }
}

