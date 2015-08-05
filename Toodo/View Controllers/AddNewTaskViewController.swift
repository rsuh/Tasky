//
//  AddNewTaskViewController.swift
//  Toodo
//
//  Created by Reginald Suh on 2015-07-17.
//  Copyright (c) 2015 ReginaldSuh. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class AddNewTaskViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var taskTitle: UITextField!
    @IBOutlet weak var badgeImage: UICollectionView!
    
    // Initialize Realm
    let realm = Realm()
    
    // Var to control the image
    var badge = 0
    
    var addButtonColor = ""
    
    var category: Category?
    
    var selectedRow: Int = 0
    
    var dateLabel: String = "Due: Never"
    
    // A bool which determines whether or not the keyboard should automatically popup
    var keyboardPopUp: Bool = true
    
    var newTask: Task? {
        didSet {
            displayNewTask(newTask)
            displayNewBadge(newTask)
            displayDate(newTask)
        }
    }
    
    // Displays the contents of the new task
    func displayNewTask(task: Task?) {
        if let task = task, taskTitle = taskTitle {
            realm.write() {
                task.taskTitle = self.newTask!.taskTitle
            }
        }
    }
    
    // Displays the badge of the new task
    func displayNewBadge(task: Task?) {
        if let task = task, badgeImage = badgeImage {
            realm.write() {
                task.badge = self.newTask!.badge
            }
        }
    }
    
    // Displays the due date of the task
    func displayDate(task: Task?) {
        if let task = task {
            realm.write() {
                task.modificationDate = self.dateLabel
            }
        }
    }
    
    // Saves the new task
    func saveNewTask() {
        if let newTask = newTask {
            realm.write() {
                if ((newTask.taskTitle != self.taskTitle.text) ||
                    (newTask.badge != self.badge) ||
                    (newTask.modificationDate != self.dateLabel)) {
                        newTask.taskTitle = self.taskTitle.text
                        newTask.badge = self.badge
                        self.category!.tasksWithinCategory.append(newTask)
                        self.category!.taskCount = self.category!.tasksWithinCategory.count
                        //self.category!.tasksWithinCategory.count = self.category!.numberOfTasksWithinCategory
                        newTask.modificationDate = self.dateLabel
                        println("\(newTask.taskTitle)")
                } else {
                    println("nothing has changed")
                }
                
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayConstants.cellImagesUnselected.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("badgeImage", forIndexPath: indexPath) as! CategoryCollectionViewCell
        if (indexPath.row == self.selectedRow) {
            cell.checkmarkImage.hidden = false
        } else {
            cell.checkmarkImage.hidden = true
        }
        cell.chooseBadgeImage.image = UIImage(named: arrayConstants.cellImagesUnselected[indexPath.row])
        
        if (addButtonColor == "addPurple") {
            cell.checkmarkImage.image = UIImage(named: "checkmarkPurple")
        } else if (addButtonColor == "addRed") {
            cell.checkmarkImage.image = UIImage(named: "checkmarkRed")
        } else if (addButtonColor == "addTurquoise") {
            cell.checkmarkImage.image = UIImage(named: "checkmarkTurquoise")
        } else if (addButtonColor == "addBlue") {
            cell.checkmarkImage.image = UIImage(named: "checkmarkBlue")
        } else {
            cell.checkmarkImage.image = UIImage(named: "checkmarkDark")
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        println("You have selected cell \(indexPath.row)")
        badge = indexPath.row
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! CategoryCollectionViewCell
        
        self.selectedRow = indexPath.row
        
        collectionView.reloadData()        
    }

    @IBAction func backToAddFromCalendar(segue: UIStoryboardSegue) {
        if let identifier = segue.identifier {
            switch identifier {
            case "backToAddFromCalendar":
                println("Back to add from calendar")
                keyboardPopUp = false
                
            case "saveFromAddCalendar":
                println("Save from add calendar")
                keyboardPopUp = false
                
            default:
                println("failed")
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "exitFromAdd" {
            println("exitFromAdd")
        } else if segue.identifier == "saveFromAdd" {
            newTask = Task()
            saveNewTask()
        } else if segue.identifier == "setDate" {
            let targetVC = segue.destinationViewController as! CalendarViewController
            targetVC.addButtonColor = self.addButtonColor

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskTitle.placeholder = "Task Title here..."
        taskTitle.delegate = self
        taskTitle.returnKeyType = UIReturnKeyType.Done
        
        // Initializes the navigation buttons
        let leftNavigation = self.navigationItem.leftBarButtonItem
        let rightNavigation = self.navigationItem.rightBarButtonItem
        
        if (addButtonColor == "") {
            leftNavigation?.tintColor = UIColor.whiteColor()
            rightNavigation?.tintColor = UIColor.whiteColor()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        println(keyboardPopUp)
        if (keyboardPopUp == true) {
            taskTitle.becomeFirstResponder()
        } else {
            println("Keyboard not showing!")
        }
    }
    
    //Called when 'return' key pressed. return NO to ignore.
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Hides keyboard whenever you tap outside the keyboard
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
    }
}