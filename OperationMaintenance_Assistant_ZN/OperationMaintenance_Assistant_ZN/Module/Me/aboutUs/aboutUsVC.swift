//
//  aboutUsVC.swift
//  OperationMaintenance_Assistant_ZN
//
//  Created by Chen on 2018/12/27.
//  Copyright © 2018年 Chen. All rights reserved.
//

import UIKit

class aboutUsVC: UITableViewController {
    
    
    
    @IBOutlet weak var versonL: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "关于我们"

        let infoDictionary = Bundle.main.infoDictionary
        let majorVersion :AnyObject? = infoDictionary? ["CFBundleShortVersionString"] as AnyObject
        
        self.versonL.text = majorVersion as! String
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
            let meterReading = UIStoryboard(name: "Me", bundle: nil)
                .instantiateViewController(withIdentifier: "introduceAppVC") as! introduceAppVC
            self.navigationController?.pushViewController(meterReading, animated: true)
            
            
        }else  if indexPath.row == 1 {
            
            self.navigationController?.pushViewController(agreenmentVC(), animated: true)
            
            
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
