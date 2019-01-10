///**
/**
 Created by: Hiep Nguyen Nghia on 12/24/18
 Copyright (c) 2018 Vietinterview. All rights reserved.
 */

import UIKit
import ExpandableLabel
import YouTubePlayer

class CustomerProfileController: BaseViewController,UITableViewDelegate, UITableViewDataSource ,ExpandableLabelDelegate{
    
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableviewImage: UITableView!
    
    var profileCustomer:ProfileCustomer?
    var arrTitle = ["","","Quy mô công ty","Lĩnh vực ngành nghề","Địa chỉ công ty","Thời gian làm việc","Thông tin công ty","",""]
    let numberOfCells : NSInteger = 9
    var mCount:Int?
    var states : Array<Bool>!
    let viewModel = HomeViewModel()
    var arrContent = [String]()
    var storedOffsets = [Int: CGFloat]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Thông tin nhà tuyển dụng"
        self.viewModel.loadCustomerProfile(success: { getCustomerProfile in
            self.profileCustomer = getCustomerProfile
            self.imgLogo.showImage(imgUrl: self.profileCustomer!.logoImg, imageNullName: "job_null")
            self.lblCompanyName.text = self.profileCustomer!.companyName!
            for i in 0...self.numberOfCells-1 {
                if i == 6 {
                    self.arrContent.append("\(StringUtils.shared.checkEmpty(value: self.profileCustomer!.descripstion))")
                } else if i == 2 {
                    if let humanresource = self.profileCustomer!.humanResources {
                        if humanresource.count > 0 {
                            for i in 0...humanresource.count-1 {
                                self.arrContent.append(StringUtils.shared.checkEmpty(value: self.profileCustomer!.humanResources![i].name))
                            }
                        } else {
                            self.arrContent.append("")

                        }
                    } else{
                        self.arrContent.append("")

                    }
                }else if i == 3{
                    if let carrerSelectedItems = self.profileCustomer!.careerSelectedItems {
                        var carrer:String = ""
                        if carrerSelectedItems.count > 0 {
                            for i in 0...carrerSelectedItems.count-1 {
                                if i == carrerSelectedItems.count-1{
                                    carrer.append("\(StringUtils.shared.checkEmpty(value: carrerSelectedItems[i].name))")
                                }else {
                                    carrer.append("\(StringUtils.shared.checkEmpty(value: carrerSelectedItems[i].name)), ")
                                }
                            }
                            self.arrContent.append(carrer)
                        } else {
                            self.arrContent.append("")
                        }
                    } else {
                        self.arrContent.append("")
                    }
                }else if i == 4{
                    var address:String = ""
                    address.append("\(StringUtils.shared.checkEmpty(value: self.profileCustomer!.address)) ")
                    if let country = self.profileCustomer!.country {
                        if country.count > 0 {
                            for i in 0...country.count-1 {
                                if let city = self.profileCustomer!.city {
                                    if city.count > 0 {
                                        for j in 0...city.count-1{
                                            if city[j].countryID! == country[i].id! {
                                                address.append(j == city.count-1 ? "\(city[j].name!), \(country[i].name!)" : "\(city[j].name!), \(country[i].name!), " )
                                            }
                                        }
                                    }
                                } else {
                                    address.append(i == country.count-1 ? "\(country[i].name!)" : "\(country[i].name!), ")
                                }
                            }
                        }
                    }
                    self.arrContent.append(address)
                }else if i == 5{
                    if let time = self.profileCustomer!.timeservingSelectedItems {
                        var mTime:String = ""
                        if time.count > 0 {
                            for i in 0...time.count-1 {
                                mTime.append(i == time.count-1 ? time[i].name! : "\(time[i].name!), ")
                            }
                            self.arrContent.append(mTime)
                        } else {
                            self.arrContent.append(mTime)
                        }
                    } else {
                        self.arrContent.append("")
                    }
                } else {
                     self.arrContent.append("")
                }
            }
            self.states = [Bool](repeating: true, count: self.numberOfCells)
            self.tableviewImage.estimatedRowHeight = 100
            self.mCount = self.numberOfCells
            self.tableviewImage.rowHeight = UITableViewAutomaticDimension
            self.tableviewImage.reloadData()
        }, failure: { error in
            self.showMessageErrorApi()
        })
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = self.mCount {
        return count
        }else{
            return 0
        }
    }
    func preparedSources() -> [(text: String, textReplacementType: ExpandableLabel.TextReplacementType, numberOfLines: Int, textAlignment: NSTextAlignment)] {
        return [(self.arrContent[6], .word, 3, .left)]
    }
    var mCell:ExpandableDetailJobCell?
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 6 {
            let currentSource = preparedSources()[0]
            let cell = tableView.dequeueReusableCell(withIdentifier: "expanedCell", for: indexPath)as? ExpandableDetailJobCell
            cell?.expandableLabel.delegate = self
            let greenColor = StringUtils.shared.hexStringToUIColor(hex: "#3C84F7") 
            let attributedStringColor = [NSAttributedStringKey.foregroundColor : StringUtils.shared.hexStringToUIColor(hex: "#3C84F7")];
            let attributedString = NSAttributedString(string: "Xem thêm", attributes: attributedStringColor)
            cell?.expandableLabel.collapsedAttributedLink = attributedString
            cell?.expandableLabel.setLessLinkWith(lessLink: "Rút gọn", attributes: [.foregroundColor: greenColor], position: currentSource.textAlignment)
            cell?.layoutIfNeeded()
            cell?.lblTitle.text = arrTitle[indexPath.row]
            cell?.expandableLabel.shouldCollapse = true
            cell?.expandableLabel.textReplacementType = currentSource.textReplacementType
            cell?.expandableLabel.numberOfLines = currentSource.numberOfLines
            cell?.expandableLabel.lineBreakMode = .byWordWrapping
            cell?.expandableLabel.sizeToFit()
            cell?.expandableLabel.collapsed = states[indexPath.row]
            cell?.expandableLabel.text = "\(currentSource.text)"
            if cell!.expandableLabel.numberOfLines < 2 {
                self.showHideView(view: cell!.lblPre, isHidden: false)
            }else {
                 self.showHideView(view: cell!.lblPre, isHidden: true)
            }
            if currentSource.text.count > 0{
                cell!.lblPre.text = currentSource.text.substring(with: 0..<currentSource.text.count/2)
            }
            cell!.isUserInteractionEnabled = true
            self.mCell = cell
            return cell!
        }else if indexPath.row >= 2 && indexPath.row <= 5{
            let cell = tableView.dequeueReusableCell(withIdentifier: "normalCell", for: indexPath) as? NormalTableCell
            cell?.lblTitle.text = self.arrTitle[indexPath.row]
            cell?.lblContent.text = self.arrContent[indexPath.row]
            cell!.isUserInteractionEnabled = false
            return cell!
        } else if indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "videocell", for: indexPath) as? VideoViewCell
            if let myVideoURL = NSURL(string: StringUtils.shared.checkEmpty(value: self.profileCustomer!.videoLink)) {
                if self.verifyUrl(urlString: self.profileCustomer!.videoLink) {
                    cell!.imgReject.isHidden = true
                    cell!.videoPlayer.isHidden = false
                    cell!.videoPlayer.loadVideoURL(myVideoURL as URL)
                }else {
                    cell!.imgReject.isHidden = false
                    cell!.videoPlayer.isHidden = true
                    cell!.imgReject.addRadius()
                }
            } else {
                cell!.imgReject.isHidden = false
                cell!.videoPlayer.isHidden = true
                cell!.imgReject.addRadius()
            }
            cell!.isUserInteractionEnabled = false
            return cell!
        }else if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? TableViewCell
            cell!.addRadius()
            cell!.isUserInteractionEnabled = false
            return cell!
            
        }else if indexPath.row == 7 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "welfaretablecell", for: indexPath) as? WelfareTableCell
            var mDataArr = [String]()
            if let customerWelfare = self.profileCustomer!.customerWelfare {
                if customerWelfare.count > 0 {
                    for i in 0...customerWelfare.count-1 {
                        mDataArr.append("\(StringUtils.shared.checkEmpty(value: customerWelfare[i].name)) - \(StringUtils.shared.checkEmpty(value: customerWelfare[i].note))")
                    }
                }
            }
            cell!.isUserInteractionEnabled = false
            cell?.registerTableView(dataArr: mDataArr)
            return cell!
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "emailcell", for: indexPath) as? EmailCell
            cell!.lblEmail.font = UIFont.italicSystemFont(ofSize: 16)
            cell!.lblEmail.text = StringUtils.shared.checkEmpty(value: self.profileCustomer!.contactEmail)
            cell!.isUserInteractionEnabled = false
            return cell!
        }
    }
    func verifyUrl (urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            guard let tableViewCell = cell as? TableViewCell else { return }
            if let profileCus = self.profileCustomer {
                if let imgCus = profileCus.customerImg {
                    if imgCus.count > 0 {
                        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
                        tableViewCell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            guard let tableViewCell = cell as? TableViewCell else { return }
            if let profileCus = self.profileCustomer {
                if let imgCus = profileCus.customerImg {
                    if imgCus.count > 0 {
                        storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
                    }
                }
            }
        }
    }
    func willExpandLabel(_ label: ExpandableLabel) {
         let point = label.convert(CGPoint.zero, to: tableviewImage)
        if let indexPath = tableviewImage.indexPathForRow(at: point) as IndexPath? {
            if indexPath.row == 6 {
        tableviewImage.beginUpdates()
            }}
    }
    
    func didExpandLabel(_ label: ExpandableLabel) {
        let point = label.convert(CGPoint.zero, to: tableviewImage)
        if let indexPath = tableviewImage.indexPathForRow(at: point) as IndexPath? {
            if indexPath.row == 6 {
                self.showHideView(view: self.mCell!.lblPre, isHidden: true)
                states[indexPath.row] = false
                DispatchQueue.main.async { [weak self] in
                    self?.tableviewImage.scrollToRow(at: indexPath, at: .top, animated: true)
                }
            }
        }
        tableviewImage.endUpdates()
    }
    
    func willCollapseLabel(_ label: ExpandableLabel) {
         let point = label.convert(CGPoint.zero, to: tableviewImage)
        if let indexPath = tableviewImage.indexPathForRow(at: point) as IndexPath? {
            
            if indexPath.row == 6 {
                if self.mCell!.expandableLabel.numberOfLines < 2 {
                    self.showHideView(view: self.mCell!.lblPre, isHidden: false)
                }else {
                    self.showHideView(view: self.mCell!.lblPre, isHidden: true)
                }
        tableviewImage.beginUpdates()
            }}
    }
    
    func didCollapseLabel(_ label: ExpandableLabel) {
        let point = label.convert(CGPoint.zero, to: tableviewImage)
        if let indexPath = tableviewImage.indexPathForRow(at: point) as IndexPath? {
            if indexPath.row == 6 {
                if self.mCell!.expandableLabel.numberOfLines < 2 {
                    self.showHideView(view: self.mCell!.lblPre, isHidden: false)
                }else {
                    self.showHideView(view: self.mCell!.lblPre, isHidden: true)
                }
                states[indexPath.row] = true
                DispatchQueue.main.async { [weak self] in
                    self?.tableviewImage.scrollToRow(at: indexPath, at: .top, animated: true)
                }
            }
        }
        tableviewImage.endUpdates()
    }
    var lastContentOffset: CGFloat = 0
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (self.lastContentOffset < scrollView.contentOffset.y) {
            self.showHideView(view: self.headerView, isHidden: true)
        } else if (self.lastContentOffset > scrollView.contentOffset.y) {
            self.showHideView(view: self.headerView, isHidden: false)
        } else {
        }
    }
}
extension CustomerProfileController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.profileCustomer!.customerImg!.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         if indexPath.row == 0{
            return 150
        } else if indexPath.row >= 2 && indexPath.row <= 5{
                return UITableViewAutomaticDimension
         } else if indexPath.row == 6{
            return UITableViewAutomaticDimension
         } else if indexPath.row == 1{
             return 219
         } else if indexPath.row == 7{
            return CGFloat(self.profileCustomer!.customerWelfare!.count * 60 + 40)
         } else {
            return 76
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? ImageCollectionViewCell
        cell!.imageCompany.showImage(imgUrl: self.profileCustomer!.customerImg![indexPath.row].imageURL, imageNullName: "job_null")
        cell!.imageCompany.addRadius()
        return cell!
    }
}
