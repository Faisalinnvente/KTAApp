//
//  TableViewCell.swift
//  KTA
//
//  Created by qadeem on 21/02/2021.
//

import UIKit
import SDWebImage

class TableViewCell: UITableViewCell {
    @IBOutlet weak var recepieImageView: UIImageView!
    @IBOutlet weak var recepieName: UILabel!
    @IBOutlet weak var nutritionsLabel: UILabel!
    @IBOutlet weak var viewBookMark: UIView!
    @IBOutlet weak var viewTime: UIView!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelRecepieType: UILabel!
    
    var isBookmarked = false
    var recepie: RecepieElement = RecepieElement()
    
    var bookmarkItem = Bookmark(bookmarkID: 0, recipieID: "")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        viewBookMark.layer.cornerRadius = viewBookMark.frame.height/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
     func configureCell(Recepie: RecepieElement) {
        self.recepie = Recepie
        recepieName?.text = Recepie.name
        labelTime.text = "\(Recepie.preparationTime)m"
        nutritionsLabel.text = "Calories • \(Recepie.nutrition[0].calories) kcal Fats • \(Recepie.nutrition[0].fat)g Proteins • \(Recepie.nutrition[0].protein)g Carbs • \(Recepie.nutrition[0].netCarbs)g"
        
        recepieImageView.sd_setImage(with: URL(string: "http://104.248.108.131:3000/assets/\(Recepie.recipieType.rawValue.lowercased())/\(Recepie.recipieID).jpg")!, placeholderImage: UIImage(named: "recepieplaceholder"))
        
        //recepieImageView?.imageFrom(url: URL(string: "http://127.0.0.1:5001/assets/\(Recepie.recipieType)/\(Recepie.recipieID).jpg")!)
        
        viewTime.layer.cornerRadius = 15
        isRecepieBookmarked()
        addTapGestures()
    }
    
    func addTapGestures() {
        let bookmarkGesture = UITapGestureRecognizer(target: self, action: #selector(addToBookmark(_:)))
        bookmarkGesture.numberOfTapsRequired = 1
        bookmarkGesture.numberOfTouchesRequired = 1
        
        viewBookMark.addGestureRecognizer(bookmarkGesture);
        viewBookMark.isUserInteractionEnabled = true
    }
    
    func isRecepieBookmarked() {
        isBookmarked =  DatabaseManager.getInstance().isBookmarked(recepie.recipieID)
        configureBookmarkView()
    }
    
    // Keto Details Button Events
    @objc func addToBookmark(_ gesture: UITapGestureRecognizer) {
        isBookmarked = !isBookmarked
        self.bookmarkItem = Bookmark(bookmarkID: 0, recipieID: self.recepie.recipieID)
        
        if isBookmarked {
            var isSave = DatabaseManager.getInstance().addBookmark(self.bookmarkItem)
        } else {
            var isDelete = DatabaseManager.getInstance().deleteBookMark(self.bookmarkItem)
        }
        
        configureBookmarkView()
    }
    
    func configureBookmarkView() {
        if isBookmarked {
            viewBookMark.backgroundColor = UIColor.lightGray
        } else {
            viewBookMark.backgroundColor = UIColor.white
        }
    }
}

