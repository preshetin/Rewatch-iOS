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
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var shakeMeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
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
                        print(movie.poster)
                        self.shakeMeLabel.isHidden = true
                        self.posterImage.isHidden = false
                        self.posterImage.downloadedFrom(link: movie.poster)
                        self.posterImage.contentMode = .scaleAspectFill
                    }
                }
            }
            task.resume()
        }
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

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}
