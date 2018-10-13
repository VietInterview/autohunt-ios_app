//
//  ViewController.swift
//  LGSideMenuControllerDemo
//
import UIKit

class ViewController : UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    override func viewDidLoad() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 139, height: 39))
        imageView.contentMode = .scaleAspectFit
        let logo = UIImage(named: "Logo.png")
        imageView.image = logo
        self.navigationItem.titleView = imageView
        navigationController?.navigationBar.barTintColor = UIColor(red: 255.0/255.0, green: 210.0/255.0, blue: 21.0/255.0, alpha: 1.0)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "jobitemcell", for: indexPath)
        //test git
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 240.0;
    }
}
