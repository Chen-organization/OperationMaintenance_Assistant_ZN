//
//  InspectionDetailVCTableViewController.swift
//  OperationMaintenance_Assistant_ZN
//
//  Created by Apple on 2019/1/24.
//  Copyright © 2019 Chen. All rights reserved.
//

import UIKit

class InspectionDetailVCTableViewController: UITableViewController {

    
    
    class func getVC() ->  InspectionDetailVCTableViewController {
        
        let sb = UIStoryboard(name: "Inspection", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "InspectionDetailVCTableViewController") as! InspectionDetailVCTableViewController
        
        return vc
    }

    
    @IBOutlet weak var dateL: UILabel!
    @IBOutlet weak var addressL: UILabel!
    @IBOutlet weak var nameL: UILabel!
    @IBOutlet weak var contentL: UILabel!
    
    
    @IBOutlet weak var contentImg1: UIImageView!
    @IBOutlet weak var contentImg2: UIImageView!
    @IBOutlet weak var contentImg3: UIImageView!
    
    var ImgArr = [UIImageView]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "巡检详情"

        
        ImgArr = [contentImg1,contentImg2,contentImg3]


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (indexPath.row < 3) {
            
            return 48
            
        }else  if (indexPath.row == 3) {
            
            return UITableView.automaticDimension;
        }else{
            
            return 93
        }
        
    }

    
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
