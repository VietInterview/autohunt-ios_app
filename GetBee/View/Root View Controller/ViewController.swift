//
//  ViewController.swift
//  LGSideMenuControllerDemo
//
import UIKit
import JJFloatingActionButton
import GoneVisible
import Alamofire
import AlamofireImage

class ViewController : UIViewController, UITableViewDelegate,UITableViewDataSource ,UIScrollViewDelegate, ChooseDelegate{
    @IBOutlet weak var btnactionSearch: UIBarButtonItem!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var conditionView: UIView!
    @IBOutlet weak var tableViewJob: UITableView!
    @IBOutlet weak var btnFilter: UIButton!
    @IBOutlet weak var textFieldSearch: UITextField!
    @IBOutlet weak var btnChooseCarrer: UIButton!
    @IBOutlet weak var btnChooseCity: UIButton!
    
    var isSearch = false
    var isFilter = false
    var viewModel = HomeViewModel()
    var jobList = [JobList]()
    var jobListServer = [JobList]()
    var page: Int = 0
    var isCarrer: Bool = false
    var isStatus: Bool = false
    var carrerId: Int = 0
    var cityId: Int = 0
    
    override func viewDidLoad() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 139, height: 39))
        imageView.contentMode = .scaleAspectFit
        let logo = UIImage(named: "Logo.png")
        imageView.image = logo
        self.navigationItem.titleView = imageView
        navigationController?.navigationBar.barTintColor = UIColor(red: 255.0/255.0, green: 210.0/255.0, blue: 21.0/255.0, alpha: 1.0)
        searchView.isHidden=true
        searchView.gone()
        conditionView.isHidden=true
        conditionView.gone()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:  #selector(sortArray), for: UIControlEvents.valueChanged)
        if #available(iOS 10.0, *) {
            self.tableViewJob.refreshControl = refreshControl
        }
        self.textFieldSearch.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.page = 0
        self.searchJob(carrerId: self.carrerId,cityId: self.cityId,jobtitle: textField.text!)
    }
    func searchJob(carrerId: Int, cityId: Int, jobtitle: String){
        self.viewModel.getSearchJob(carrerId: carrerId, cityId: cityId, jobTitle: jobtitle,  page: self.page, success:  { [unowned self] job in
            //            self.labelQuantityJOb.text = "\(job.total!) công việc được tìm thấy"
            if self.page == 0 {
                self.jobList = job.jobList!
            } else {
                self.jobList.append(contentsOf: job.jobList!)
            }
            self.jobListServer = job.jobList!
            if self.page == 0 {
                if #available(iOS 10.0, *) {
                    self.tableViewJob.refreshControl?.endRefreshing()
                }
                //                self.quantityView.isHidden = false
                //                self.quantityView.visible()
            }
            
            self.tableViewJob.reloadData()
            }, failure:  { error in
                print("User Profile Error: " + error)
        })
    }
    @objc func sortArray() {
        self.page = 0
        self.searchJob(carrerId: self.carrerId, cityId: self.cityId, jobtitle: self.textFieldSearch.text!)
    }
    override func viewDidAppear(_ animated: Bool) {
        self.searchJob(carrerId: self.carrerId,cityId: self.cityId,jobtitle: self.textFieldSearch.text!)
    }
    
    @IBAction func goToCarrerOrCity() {
        self.isCarrer = true
        self.isStatus = false
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CarrerOrCityController") as! CarrerOrCityController
        vc.title = "Ngành Nghề"
        vc.isCarrer = self.isCarrer
        vc.isStatus = self.isStatus
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func goToCity(_ sender: Any) {
        self.isCarrer = false
        self.isStatus = false
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CarrerOrCityController") as! CarrerOrCityController
        vc.isCarrer = self.isCarrer
        vc.isStatus = self.isStatus
        vc.title = "Thành Phố"
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    func didChoose(mychoose: MyChoose) {
        if self.isCarrer == true {
            self.btnChooseCarrer.setTitle(mychoose.name,for: .normal)
            self.carrerId = mychoose.id
        } else {
            self.btnChooseCity.setTitle(mychoose.name, for: .normal)
            self.cityId = mychoose.id
        }
    }
    @IBAction func actionSearch(_ sender: Any) {
        if isSearch == false {
            btnactionSearch.image = UIImage(named: "tick_black.png")
            searchView.isHidden=false
            searchView.visible()
            if isFilter == false {
                conditionView.isHidden=true
                conditionView.gone()
            } else {
                conditionView.isHidden=false
                conditionView.visible()
            }
            isSearch=true
        } else {
            btnactionSearch.image = UIImage(named: "search.png")
            searchView.isHidden=true
            searchView.gone()
            UIView.animate(withDuration: 0.3) { self.searchView.layoutIfNeeded() }
            conditionView.isHidden=true
            conditionView.gone()
            isFilter = false
            isSearch = false
        }
    }
    
    @IBAction func filterTouchUp(_ sender: Any) {
        if isFilter == false {
            btnFilter.setImage(UIImage(named: "filter_black.png"), for: .normal)
            isFilter = true
            conditionView.isHidden=false
            conditionView.visible()
        } else {
            btnFilter.setImage(UIImage(named: "filter_gray.png"), for: .normal)
            isFilter = false
            conditionView.isHidden=true
            conditionView.gone()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.jobList.count
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = self.jobList.count - 1
        if  indexPath.row == lastElement {
            if self.jobListServer.count >= 30 {
                page = page + 1
                self.searchJob(carrerId: self.carrerId,cityId: self.cityId,jobtitle: self.textFieldSearch.text!)
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailJobController") as! DetailJobController
        vc.jobId = self.jobList[indexPath.row].id!
        vc.title = "Chi tiết công việc"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "jobitemcell", for: indexPath) as! JobTableViewCell
        cell.labelJob.text = StringUtils.shared.checkEmpty(value: self.jobList[indexPath.row].jobTitle)
        cell.labelCompany.text = self.jobList[indexPath.row].companyName!
        cell.labelCarrer.text = StringUtils.shared.checkEmpty(value: self.jobList[indexPath.row].careerName)
        cell.labelCityList.text = StringUtils.shared.checkEmpty(value: self.jobList[indexPath.row].listcityName)
        cell.labelFee.text = "\(StringUtils.shared.currencyFormat(value: self.jobList[indexPath.row].fee!) ) \(StringUtils.shared.genString(value: self.jobList[indexPath.row].currency!))"
        cell.labelDeadlineDate.text = DateUtils.shared.UTCToLocal(date: self.jobList[indexPath.row].expireDate!)
        if self.jobList[indexPath.row].collStatus == 0 {
            let image: UIImage = UIImage(named: "save")!;   cell.imgSaveUnSaveJob.image = image
            cell.imgSaveUnSaveJob.isUserInteractionEnabled = true
        } else if self.jobList[indexPath.row].collStatus == 1 {
            let image: UIImage = UIImage(named: "saved")!
            cell.imgSaveUnSaveJob.image = image
            cell.imgSaveUnSaveJob.isUserInteractionEnabled = true
        } else {
            let image: UIImage = UIImage(named: "tickok")!;  cell.imgSaveUnSaveJob.image = image
            cell.imgSaveUnSaveJob.isUserInteractionEnabled = false
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tappedMe(sender: )))
        cell.imgSaveUnSaveJob.addGestureRecognizer(tap)
        cell.imgSaveUnSaveJob.tag = indexPath.row
        if indexPath.row == 0 {
            cell.quantityView.isHidden = false
            cell.quantityView.visible()
            cell.lblQuantity.text = "\(self.jobList.count) công việc được tìm thấy"
        } else {
            cell.quantityView.isHidden = true
            cell.quantityView.gone()
        }
        Alamofire.request("https://dev.getbee.vn/\(StringUtils.shared.checkEmpty(value: self.jobList[indexPath.row].companyImg))").responseImage { response in
            if let image = response.result.value {
                cell.imgCompany.image = image
            }
        }
        return cell
    }
    
    @objc func tappedMe(sender: UITapGestureRecognizer)
    {
        var status: Int
        if self.jobList[sender.view!.tag].collStatus == nil || self.jobList[sender.view!.tag].collStatus == 0 {
            status = 1
        } else {
            status = 0
        }
        
        viewModel.saveUnsaveJob(jobId: self.jobList[sender.view!.tag].id!,status: status, success: {[unowned self] addRemoveJob in
            print(addRemoveJob.status!)
            self.jobList[sender.view!.tag].collStatus = addRemoveJob.status!
            self.tableViewJob.reloadData()
            }, failure: {error in
                print("User Profile Error: " + error)})
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if indexPath.row == 0{
            return 290;
        } else {
            return 240
        }
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if targetContentOffset.pointee.y < scrollView.contentOffset.y {
            //            quantityView.isHidden = false
            //            quantityView.visible()
        } else {
            //            quantityView.gone()
            //            quantityView.isHidden = true
        }
    }
}
