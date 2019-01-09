//
//  ViewController.swift
//  LGSideMenuControllerDemo
//
import UIKit
import GoneVisible
import Alamofire
import AlamofireImage

class ViewController : BaseViewController, UITableViewDelegate,UITableViewDataSource ,UIScrollViewDelegate, ChooseDelegate{
    @IBOutlet weak var btnactionSearch: UIBarButtonItem!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var conditionView: UIView!
    @IBOutlet weak var tableViewJob: UITableView!
    @IBOutlet weak var btnFilter: UIButton!
    @IBOutlet weak var textFieldSearch: UITextField!
    @IBOutlet weak var btnChooseCarrer: UIButton!
    @IBOutlet weak var btnChooseCity: UIButton!
    
    var job = Job()
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
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 139, height: 39))
        imageView.contentMode = .scaleAspectFit
        let logo = UIImage(named: "Logo_yellow.png")
        imageView.image = logo
        self.navigationItem.titleView = imageView
        self.showHideView(view: searchView, isHidden: true)
        self.showHideView(view: conditionView, isHidden: true)
        refreshControl.addTarget(self, action:  #selector(sortArray), for: UIControlEvents.valueChanged)
        if #available(iOS 10.0, *) {
            self.tableViewJob.refreshControl = refreshControl
        }
        self.textFieldSearch.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        tableViewJob.rowHeight = UITableViewAutomaticDimension
        tableViewJob.estimatedRowHeight = UITableViewAutomaticDimension
        
        debugLog(object: UIDevice.current.identifierForVendor!.uuidString)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.page = 0
        self.searchJob(carrerId: self.carrerId,cityId: self.cityId,jobtitle: "\(textField.text!)")
    }
    func searchJob(carrerId: Int, cityId: Int, jobtitle: String){
        self.viewModel.getSearchJob(carrerId: carrerId, cityId: cityId, jobTitle: jobtitle,  page: self.page, success:  { [unowned self] job in
            self.job = job
            if self.page == 0 {
                self.jobList = job.jobList!
            } else {
                self.jobList.append(contentsOf: job.jobList!)
            }
            self.jobListServer = job.jobList!
            if self.page == 0 {
                if #available(iOS 10.0, *) {
                    self.tableViewJob.refreshControl?.endRefreshing()
                }else {
                    self.tableViewJob.willRemoveSubview(self.refreshControl)
                }
            }
            
            self.tableViewJob.reloadData()
            }, failure:  { error in
                if #available(iOS 10.0, *) {
                    self.tableViewJob.refreshControl?.endRefreshing()
                }else {
                    self.tableViewJob.willRemoveSubview(self.refreshControl)
                }
                self.showMessage(title: NSLocalizedString("noti_title", comment: ""), message: NSLocalizedString("error_please_try", comment: ""))
        })
    }
    @objc func sortArray() {
        self.page = 0
        self.searchJob(carrerId: self.carrerId, cityId: self.cityId, jobtitle: self.textFieldSearch.text!)
    }
    override func viewDidAppear(_ animated: Bool) {
        self.page = 0
        self.searchJob(carrerId: self.carrerId,cityId: self.cityId,jobtitle: self.textFieldSearch.text!)
        
    }
    override func viewDidLayoutSubviews() {
        if let cell = self.mCell {
            cell.labelJob.sizeToFit()
        }
    }
    @IBAction func goToCarrerOrCity() {
        self.isCarrer = true
        self.isStatus = false
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CarrerOrCityController") as! CarrerOrCityController
        vc.title = NSLocalizedString("carrer", comment: "")
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
        vc.title = NSLocalizedString("city", comment: "")
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
            btnFilter.setImage(UIImage(named: "filter_gray.png"), for: .normal)
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
    enum VersionError: Error {
        case invalidResponse, invalidBundleInfo
    }
    func isUpdateAvailable(completion: @escaping (Bool?, Error?) -> Void) throws -> URLSessionDataTask {
        guard let info = Bundle.main.infoDictionary,
            let currentVersion = info["CFBundleShortVersionString"] as? String,
            let identifier = info["CFBundleIdentifier"] as? String,
            let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(identifier)") else {
                throw VersionError.invalidBundleInfo
        }
        debugLog(object: currentVersion)
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                if let error = error { throw error }
                guard let data = data else { throw VersionError.invalidResponse }
                let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any]
                guard let result = (json?["results"] as? [Any])?.first as? [String: Any], let version = result["version"] as? String else {
                    throw VersionError.invalidResponse
                }
                completion(version != currentVersion, nil)
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
        return task
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
        self.pushViewController(controller: DetailJobController.init().setArgument(jobId: self.jobList[indexPath.row].id!, title: NSLocalizedString("detail_job", comment: "")))
    }
    var mCell:JobTableViewCell?
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "jobitemcell", for: indexPath) as! JobTableViewCell
        cell.labelJob.text = StringUtils.shared.checkEmpty(value: self.jobList[indexPath.row].jobTitle)
        cell.labelCompany.text = self.jobList[indexPath.row].companyName!
        cell.labelCarrer.text = StringUtils.shared.checkEmpty(value: self.jobList[indexPath.row].careerName)
        cell.labelCityList.text = StringUtils.shared.checkEmpty(value: self.jobList[indexPath.row].listcityName)
        cell.labelFee.text = "\(StringUtils.shared.currencyFormat(value: self.jobList[indexPath.row].fee!) ) VND"
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
            cell.lblQuantity.text = "\(self.job.total!) \(NSLocalizedString("SuffixesJob", comment: ""))"
        } else {
            cell.quantityView.isHidden = true
            cell.quantityView.gone()
        }
        cell.imgCompany.showImage(imgUrl: self.jobList[indexPath.row].companyImg, imageNullName:"job_null")
        cell.viewContentCell.shadowView(opacity:0.05)
        cell.imgCompany.addRadius()
        cell.imgCompany.addBorder(color:  StringUtils.shared.hexStringToUIColor(hex: "#979797"), weight: 0.5)
        cell.imgCompany.shadowView()
        self.mCell = cell
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
//        return UITableViewAutomaticDimension
                if indexPath.row == 0{
                    return 270;
                } else {
                    return 230
                }
    }
}
extension UIView {
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
