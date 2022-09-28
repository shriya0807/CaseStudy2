//
//  CategoryScreenViewController.swift
//  CaseStudy2
//
//  Created by Capgemini-DA233 on 31/06/1944 Saka.
//

import UIKit
import Alamofire
import SwiftyJSON


var myIndex = 0
class CategoryScreenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 25
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cells = myTableView.dequeueReusableCell(withIdentifier: "cell")
        cells?.textLabel?.text = arr[indexPath.row]
        return cells!
    }
    func tableView(_ tableView: UITableView,didSelectRowAt indexPath: IndexPath){
        myIndex = indexPath.row
        myTableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "home", sender: self)
    }
    
    var arr = [String]()
   
    @IBOutlet weak var myTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myTableView.delegate = self
        self.myTableView.dataSource = self
        let link = "https://dummyjson.com/products"
        Alamofire.request(link, method: .get).responseJSON { (myresponse) in
            switch myresponse.result{
            case .success:
                print(myresponse.result)
                let myresult = try? JSON(data: myresponse.data!)
                print(myresult!["products"])
                let resArray = myresult!["products"]
                self.arr.removeAll()
                for i in resArray.arrayValue{
                    let cat = i["category"].stringValue
                    if(!self.arr.contains(cat)){
                    self.arr.append(cat)
                    }
                }
                self.myTableView.reloadData()
                break
            case .failure:
                print(myresponse.error!)
                break
            }
        }
        
    }
   
    
}


