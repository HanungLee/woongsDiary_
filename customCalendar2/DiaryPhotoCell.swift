//
//  DiaryPhotoCell.swift
//  customCalendar2
//
//  Created by Hanung Lee on 25/07/2018.
//  Copyright © 2018 Hanung Lee. All rights reserved.
//

import UIKit

protocol PhotoCellDelegate: class{
    func delete(cell: DiaryPhotoCell)
}

class DiaryPhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var deleteButtonView: UIVisualEffectView!
    
    weak var delegate: PhotoCellDelegate?
    
    var imageName: String! {
        //imageName이 설정되었을 때 호출되는 함수
        didSet{
            //   photoImageView.image = UIImage(named:)
        }
    }
    
    var isEditing: Bool = false{
        didSet{
            deleteButtonView.isHidden = !isEditing
        }
    }
    
    @IBAction func deleteButtonDidTap(_ sender: Any) {
    
        delegate?.delete(cell: self)
    
    }
    
}
