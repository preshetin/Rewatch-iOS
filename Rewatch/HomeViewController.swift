//
//  FirstViewController.swift
//  Rewatch
//
//  Created by Petr Reshetin on 11/11/2016.
//  Copyright © 2016 Petr Reshetin. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    let collection = MoviesCollection()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let movieId = collection.topMovieIds.randomItem()
        
        let url = URL(string: "https://www.omdbapi.com/?i=\(movieId)&plot=short&r=json")
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                print(error!)
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            
            let jsonMovie = try! JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
            
            if let movie = Movie(json: jsonMovie) {
                DispatchQueue.main.async {
                    print(movie.title)
                }
            }
            
        }
        task.resume()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension Array {
    func randomItem() -> Element {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}
