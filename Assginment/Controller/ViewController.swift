//
//  ViewController.swift
//  Assginment
//
//  Created by ndot on 03/04/19.
//  Copyright © 2019 ndot. All rights reserved.
//

import UIKit
import SDWebImage

struct AnchoredConstraints {
    var top, leading, bottom, trailing, width, height: NSLayoutConstraint?
}

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    let ViewModelObj: AssignmentViewModel = AssignmentViewModel()
    
    var apiResponse : [Rows]?
    
    // Tableview objects
    var myTableview = UITableView()
    var cellID = "TableViewCell"
    
    // Refresh control objects
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.designSetup()
        
        homeAPICall()
        
        refreshControlSetUp()
    }
    
    func homeAPICall()  {
        
        ViewModelObj.apiCalling { (response) in
            
            self.apiResponse = response
            
            DispatchQueue.main.async {
                
                self.myTableview.reloadData()
            }
        }
         self.refreshControl.endRefreshing()
    }
    
    // MARK: UIRefreshControl Setup
    
    func refreshControlSetUp()  {
        
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            
            myTableview.refreshControl = refreshControl
            
        } else {
            
            myTableview.addSubview(refreshControl)
        }
        
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing Page ...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])
        //
        
        refreshControl.tintColor = UIColor.gray
        
        refreshControl.addTarget(self, action: #selector(refreshHomeData(_:)), for: .valueChanged)
        
        // Background Color
        let backgroundColor = UIColor.darkGray
        
        // Creating refresh control
        refreshControl.backgroundColor = UIColor.white
        
        // Creating view for extending background color
        var frame = myTableview.bounds
        
        frame.origin.y = -frame.size.height
        
        let backgroundView = UIView(frame: frame)
        
        backgroundView.autoresizingMask = .flexibleWidth
        
        backgroundView.backgroundColor = backgroundColor
        
        // Adding the view below the refresh control
        myTableview.insertSubview(backgroundView, at: 0)
        
    }
    
    // MARK: PullToRefresh Function
    
    @objc private func refreshHomeData(_ sender: Any) {
        // Fetch Weather Data
        
        self.homeAPICall()
        
    }
    
    func designSetup() -> Void {
        
        self.navigationItem.title = "Test"
        self.view.addSubview(myTableview)
        myTableview.delegate = self
        myTableview.dataSource = self
        myTableview.backgroundColor = UIColor.white
        myTableview.separatorStyle = .none
        myTableview.register(CustomTableViewCell.self, forCellReuseIdentifier: cellID)
        myTableview.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: self.view.leadingAnchor, bottom: self.view.bottomAnchor, trailing: self.view.trailingAnchor, padding: .zero, size: .zero)
        
    }
    
    //MARK:- For changing Navigation title
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if(scrollView.convert(myTableview.frame.origin, to: self.view).y <= 60) {
            
            let Cell:CustomTableViewCell? = self.myTableview.dequeueReusableCell(withIdentifier: cellID) as? CustomTableViewCell
            if Cell != nil
            {
                let position: CGPoint = Cell!.convert(.zero, to: self.myTableview)
                if let indexPath = self.myTableview.indexPathForRow(at: position)
                {
                    navigationController!.navigationBar.topItem!.title = apiResponse?[indexPath.row].title
                }
            }
        } else{
            navigationController!.navigationBar.topItem!.title = "Assignment"
        }
        
    }
}



extension ViewController {
    
    //MARK:- TableView delegates and datasources
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apiResponse?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell:CustomTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellID) as? CustomTableViewCell
        Cell?.titleImageView.backgroundColor = UIColor.clear
        
        if apiResponse?[indexPath.row].title != nil {
            
            Cell?.titleLabel.text = apiResponse?[indexPath.row].title
            
        } else {
            
            Cell?.titleLabel.text = "Title not available"
        }
        
        if apiResponse?[indexPath.row].description != nil {
            
            Cell?.titleDescription.text = apiResponse?[indexPath.row].description
            
        } else {
            
            Cell?.titleDescription.text = "Description not available"
        }
        
        
        Cell?.backgroundColor = UIColor.white
        
        if (apiResponse?[indexPath.row].imageHref) != nil {
            
            Extensions.getSDImages(imageBaseUrl: (apiResponse?[indexPath.row].imageHref)!, imageView: (Cell?.titleImageView)!, reSize: CGSize(width: UIScreen.main.bounds.size.width - 16 , height: 100))
        }
        else {
            Cell?.titleImageView.image = UIImage(named: "NoImage")
        }
        
        return Cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}

//MARK:- ANCHOR Extend
extension UIView {
    
    @discardableResult
    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) -> AnchoredConstraints {
        
        translatesAutoresizingMaskIntoConstraints = false
        var anchoredConstraints = AnchoredConstraints()
        
        if let top = top {
            anchoredConstraints.top = topAnchor.constraint(equalTo: top, constant: padding.top)
        }
        
        if let leading = leading {
            anchoredConstraints.leading = leadingAnchor.constraint(equalTo: leading, constant: padding.left)
        }
        
        if let bottom = bottom {
            anchoredConstraints.bottom = bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom)
        }
        
        if let trailing = trailing {
            anchoredConstraints.trailing = trailingAnchor.constraint(equalTo: trailing, constant: -padding.right)
        }
        
        if size.width != 0 {
            anchoredConstraints.width = widthAnchor.constraint(equalToConstant: size.width)
        }
        
        if size.height != 0 {
            anchoredConstraints.height = heightAnchor.constraint(equalToConstant: size.height)
        }
        
        [anchoredConstraints.top, anchoredConstraints.leading, anchoredConstraints.bottom, anchoredConstraints.trailing, anchoredConstraints.width, anchoredConstraints.height].forEach{ $0?.isActive = true }
        
        return anchoredConstraints
    }
    
    func centerInSuperview(size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        if let superviewCenterXAnchor = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: superviewCenterXAnchor).isActive = true
        }
        
        if let superviewCenterYAnchor = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: superviewCenterYAnchor).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
    
    func fillSuperview(padding: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        if let superviewTopAnchor = superview?.topAnchor {
            topAnchor.constraint(equalTo: superviewTopAnchor, constant: padding.top).isActive = true
        }
        
        if let superviewBottomAnchor = superview?.bottomAnchor {
            bottomAnchor.constraint(equalTo: superviewBottomAnchor, constant: -padding.bottom).isActive = true
        }
        
        if let superviewLeadingAnchor = superview?.leadingAnchor {
            leadingAnchor.constraint(equalTo: superviewLeadingAnchor, constant: padding.left).isActive = true
        }
        
        if let superviewTrailingAnchor = superview?.trailingAnchor {
            trailingAnchor.constraint(equalTo: superviewTrailingAnchor, constant: -padding.right).isActive = true
        }
    }
    
}
