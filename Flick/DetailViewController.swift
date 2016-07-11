//
//  DetailViewController.swift
//  Flick
//
//  Created by Vu Nguyen on 7/7/16.
//  Copyright © 2016 VuNguyen. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var publishdayLabel: UILabel!
    
    var posterUrlString: String!
    var MovieTitle: String!
    var overviewString: String!
    var ratingvalue: Float!
    var publishday: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = MovieTitle
        
        photoView.setImageWithURL(NSURL(string: posterUrlString)!)
        overviewLabel.text = overviewString
        overviewLabel.sizeToFit()
        ratingLabel.text = "Rating: \(ratingvalue)"
        publishdayLabel.text = "Publish: \n" + publishday
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
