//
//  SearchViewController.swift
//  Rewatch
//
//  Created by Petr Reshetin on 15/11/2016.
//  Copyright © 2016 Petr Reshetin. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    var movies = [Movie]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self

    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count > 2 {
            print("searching for suggestions of  '\(searchText)'")
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let text = searchBar.text!.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!
        let url = URL(string: "https://www.omdbapi.com/?s=\(text)")

        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                print(error!)
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            
            let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
            let jsonMovies = json["Search"] as! [Any]
            for jsonMovie in jsonMovies {
                if let jm = jsonMovie as? [String:Any] {
                    if let m = Movie(json: jm) {
                        self.movies.append(m)
                    }
                }
            }
        }
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
