//
//  MovieViewController.swift
//  Flick
//
//  Created by Vu Nguyen on 7/5/16.
//  Copyright © 2016 VuNguyen. All rights reserved.
//

import UIKit
import AFNetworking
import ZProgressHUD

class MovieViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var movies = [NSDictionary]()
    var progressMessage = ZProgressHUD()
    let reachability = Reachability()
    let refreshControl = UIRefreshControl()
    
    let baseURL = "https://image.tmdb.org/t/p/w45"
    let oriURL = "https://image.tmdb.org/t/p/original"
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.alpha = 0
        
        // Do any additional setup after loading the view.
                
        ZProgressHUD.show()
        
        
        tableView.dataSource = self
        tableView.delegate = self
        
        errorLabel.text = "⚠️ Error Network!"
        
        if(reachability.connectedToNetwork()==false){
            errorLabel.alpha = 1
            ZProgressHUD.dismiss()
        }
        else
        {
             errorLabel.alpha = 0
        }
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request,completionHandler: { (dataOrNil, response, error) in
                                                                        if let data = dataOrNil {
                                                                            if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                                                                                data, options:[]) as? NSDictionary {
                                                                                //print("response: \(responseDictionary)")
                                                                                self.movies =  responseDictionary["results"] as![NSDictionary]
                                                                                
                                                                             self.tableView.reloadData()
                                                                             ZProgressHUD.dismiss()
                                                                            
                                                                            }
                                                                        }
            

        })
        task.resume()
        
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
    }

    func refreshControlAction(refreshControl: UIRefreshControl)
    {
        
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        if(reachability.connectedToNetwork()==false)
        {
            errorLabel.alpha = 1
        }
        else
        {
            errorLabel.alpha = 0
        }
        
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request,completionHandler: { (dataOrNil, response, error) in
            if let data = dataOrNil {
                if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                    data, options:[]) as? NSDictionary {
                    //print("response: \(responseDictionary)")
                    self.movies =  responseDictionary["results"] as![NSDictionary]
                    self.tableView.reloadData()
                    ZProgressHUD.dismiss()
                    refreshControl.endRefreshing()
                }
            }
           
        })
        task.resume()
        
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int

    {
        return movies.count
    }
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell") as! MovieCellTableViewCell
        
        cell.titleLabel.text = movies[indexPath.row]["title"] as! String
        cell.overviewLabel.text = movies[indexPath.row]["overview"] as! String
        let posterURLImage = baseURL + (movies[indexPath.row]["poster_path"] as! String)
        cell.posterImage.setImageWithURL(NSURL(string: posterURLImage)!)
        
        return cell
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        
        var nextVC = segue.destinationViewController as! DetailViewController
        let ip = tableView.indexPathForSelectedRow
        
        
        nextVC.overviewString = movies[ip!.row]["overview"] as! String
        nextVC.posterUrlString = oriURL + (movies[ip!.row]["poster_path"] as! String)
        nextVC.MovieTitle = movies[ip!.row]["title"] as! String
        
        
        nextVC.ratingvalue = movies[ip!.row]["vote_average"] as! Float
        nextVC.publishday = movies[ip!.row]["release_date"] as! String

        
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        navigationItem.backBarButtonItem = backButton

        // Pass the selected object to the new view controller.
    }
    

}
