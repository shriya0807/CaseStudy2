//
//  HomeViewController.swift
//  CaseStudy2
//
//  Created by Capgemini-DA233 on 04/07/1944 Saka.
//

import UIKit
import Alamofire
import SwiftyJSON
//import AlamofireImage

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cells = tableViewHome.dequeueReusableCell(withIdentifier: "tvcell")
        cells?.textLabel?.text = arrays[indexPath.row]
        return cells!
    }
   
    var arrays = [String]()  // a list to store data
    @IBOutlet weak var tableViewHome: UITableView!  // table view
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewHome.delegate = self
        self.tableViewHome.dataSource = self
        // Do any additional setup after loading the view.
        let link = "https://dummyjson.com/products"  // web API URL
        Alamofire.request(link, method: .get).responseJSON { (myresponse) in
            switch myresponse.result{
            case .success:
                print(myresponse.result)
                let myresult = try? JSON(data: myresponse.data!)
                print(myresult!["products"])
                let resArray = myresult!["products"]
                self.arrays.removeAll()
                for i in resArray.arrayValue{
                  //  let cat = i["category"].stringValue
                    let brand = i["title"].stringValue
                    let desc = i["description"].stringValue
                   // let img = i["thumbnail"]
                   // if(cat){
                    self.arrays.append(brand)
                    self.arrays.append(desc)
                   // self.arrays.append(img)
                    }
                
                self.tableViewHome.reloadData()
                break
            
            case .failure:
                print(myresponse.error!)
                break
            }
        }
    }
}

