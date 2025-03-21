//
//  MainViewController.swift
//  News
//
//  Created by Алёна Максимова on 21.03.2025.
//

import UIKit

class MainViewController: UIViewController {
    
    var searchActive : Bool = false
    var news: [News] = []
    var filteredNews: [News] = []
    

    private var newsView: MainView {
        guard let view = view as? MainView else {
            fatalError()
        }
        return view
    }
    
    override func loadView() {
        self.view = MainView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newsView.backgroundColor = .white
        
        newsView.newsTableView.delegate = self
        newsView.newsTableView.dataSource = self
        newsView.searchBar.delegate = self
        
        fetchData()
    }

    func fetchData() {
        newsView.loading.startAnimating()
        let url = URL(string: "https://newsapi.org/v2/everything?q=title&apiKey=384f917ac6504480ae05923a6de4c22c")!
        let request = URLRequest(url: url)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in

            if let error = error {
                // Handle HTTP request error
                print(error)
            } else if let data = data {
                let wrapper = try? JSONDecoder().decode(Wrapper.self, from: data)
                self.news = wrapper?.articles ?? []
                DispatchQueue.main.async {
                    self.newsView.newsTableView.reloadData()
                    self.newsView.loading.stopAnimating()
                }
                                
            } else {
                // Handle unexpected error
            }
            
        }
        
        task.resume()
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searchActive) {
            return filteredNews.count
        }
        
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MainCell.reusableIdentifier,
            for: indexPath
        ) as? MainCell else {
            fatalError("Failed to dequeue EmployeeCell")
        }
        
        if (searchActive) {
            cell.newsTitleLabel.text = filteredNews[indexPath.row].title
            cell.newsDescriptionLabel.text = filteredNews[indexPath.row].description
            cell.newsImageView.downloaded(from: filteredNews[indexPath.row].urlToImage ?? "")
            
        } else {
            cell.newsTitleLabel.text = news[indexPath.row].title
            cell.newsDescriptionLabel.text = news[indexPath.row].description
            cell.newsImageView.downloaded(from: news[indexPath.row].urlToImage ?? "")
        }
        return cell
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredNews = news.filter({ (new) -> Bool in
            let tmp: NSString = new.title as? NSString ?? ""
            let range = tmp.range(of: searchText, options:.caseInsensitive)
            return range.location != NSNotFound
        })
        
        if (filteredNews.count == 0) {
            searchActive = false;
        } else {
            searchActive = true;
        }
        
        newsView.newsTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
