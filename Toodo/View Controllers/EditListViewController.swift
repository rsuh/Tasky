//
//  EditListViewController.swift
//  Toodo
//
//  Created by Reginald Suh on 2015-07-17.
//  Copyright (c) 2015 ReginaldSuh. All rights reserved.
//

import UIKit
import RealmSwift
import Foundation

class EditListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate {
    
    //@IBOutlet weak var badgeImage: UIImageView!
    @IBOutlet weak var listTitle: UITextField!
    var badge = 0
    
    var addNewList: List? {
        didSet {
            displayList(addNewList)
            displayBadge(addNewList)
        }
    }
    
    func displayList(list: List?) {
        if let list = list, listTitle = listTitle {
            let realm = Realm()
            realm.write() {
                listTitle.text = self.addNewList!.listTitle
            }
        }
    }
    
    func displayBadge(list: List?) {
        if let list = list {
            let realm = Realm()
            realm.write() {
                list.badge = self.addNewList!.badge
            }
        }
    }
    
    // Saves the task
    func saveList() {
        if let addNewList = addNewList {
            let realm = Realm()
            realm.write() {
                if (addNewList.listTitle != self.listTitle.text) && (addNewList.badge != self.badge){
                    addNewList.listTitle = self.listTitle.text
                    addNewList.badge = self.badge
                } else {
                    println("nothing to save")
                }
            }
        }
    }
    
    // Passing image to ListViewController
    //    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    //        let realm = Realm()
    //        editedList = List()
    //        editedList?.badge = self.badge
    //        //println("\(listTitle.text)")
    //    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayConstants.cellImagesUnselected.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("badgeImage", forIndexPath: indexPath) as! ListCollectionViewCell
        cell.chooseBadgeImage.image = UIImage(named: arrayConstants.cellImagesUnselected[indexPath.row])
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        println("You have selected cell \(indexPath.row)")
        badge = indexPath.row
        println(badge)
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! ListCollectionViewCell
        cell.chooseBadgeImage.image = UIImage(named: "badgeFinance")
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! ListCollectionViewCell
        
        cell.backgroundColor = UIColor.clearColor()
        
        (collectionView.cellForItemAtIndexPath(indexPath) as! ListCollectionViewCell).chooseBadgeImage.image = UIImage(named: arrayConstants.cellImagesUnselected[indexPath.row])
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        displayList(addNewList)
        listTitle.delegate = self
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        saveList()
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
