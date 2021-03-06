//
//  AchievementViewController.swift
//  GameChallenge
//
//  Created by Sihan Fang on 2018/12/18.
//  Copyright © 2018 Sihan Fang. All rights reserved.
//

import UIKit

class AchievementViewController: UIViewController {
    

    var result = ""
    var point = 0
    var commomAccomplishment = ""
    var email = ""
    
    var littleManFound: Bool = false
    var luckyYou: Bool = false
    
    var array = [String]()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(UserDefaults.standard.string(forKey: "token"))
        
        
        showAchievement(UserDefaults.standard.string(forKey: "token")!)
    }
    
    func showAchievement(_ token: String) {
        
        
        print("=====here in the achievement======")
        print(token)
        
        let myToken: [String: String] = [
            "token" : token,
            "game": "loveLetterGenerator"
        ]
        
        let data = try? JSONSerialization.data(withJSONObject: myToken, options: [])
        
        if let url = URL(string: "\(api)/api/profile") {
            
            var request = URLRequest(url: url)
            request.httpBody = data
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                print(error?.localizedDescription)
                
                print((response as? HTTPURLResponse)?.statusCode)
                
                if let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any] {
                    print(json)
                    if let responseData = json?["response"] as? [String: Any]  {
                        if let accomplishment = responseData["Accomplishment"] as? [String: Any] {
                            self.array.removeAll()
                            if accomplishment["FindLittleMan"] as? String == "true" {
                                self.array.append("20 times little Man Found")
                            }
                            
                            if accomplishment["LuckyYou"] as? String == "true" {
                                self.array.append("Lucky You")
                            }
                            
                            if accomplishment["YouAreFilthyRich"] as? String == "true" {
                                self.array.append("You Are Filthy Rich")
                            }
                            
                            }
                        
                        if let remainingPoint = responseData["RemainingPoint"] as? Int {
                            self.point = remainingPoint
                            print(remainingPoint)
                            
            
                        
                        }
                        if let email = responseData["email"] as? String {
                        self.email = email
                        print("=====\(email)========")
                        }
                    }
                    print(json?["result"] as? String)
                    if let resultData = json?["result"] as? Bool {
                        print("++++++++++\(resultData)+++++++")
                    }
                }
                
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
                }.resume()
            
            
        }
    }
    
    /*{
     "result": "true",
     "point": "yourTotalPoints"
     "commonAccomplishment": ['commonAccomplishment1', 'commonAccomplishment2' ... 'commonAccomplishment?']
     
     {
     "token": "yourToken","game":"loveLetterGenerator", "accomplishment":"LuckyYou"
     }

     }*/
}

extension AchievementViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = array[indexPath.row]
        
        return cell!

    }


}
