//
//  PhotoDetailViewController.swift
//  customCalendar2
//
//  Created by Hanung Lee on 25/07/2018.
//  Copyright © 2018 Hanung Lee. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController {
    
    var photo: UIImage!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = photo
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: false)
    }
    
}
