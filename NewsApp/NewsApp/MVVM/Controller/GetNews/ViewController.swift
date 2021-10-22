//
//  ViewController.swift
//  NewsApp
//
//  Created by Lyvennitha on 22/10/21.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {
    
    @IBOutlet weak var newsTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getNewsList()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    

}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NewsListViewModel.shared.newsData?.articles?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? NewsTableCell
        let data = NewsListViewModel.shared.newsData?.articles?[indexPath.row]
        cell?.authorLbl.text = data?.author
        cell?.titleLBl.text = data?.title
        cell?.content.text = data?.content
        cell?.imgView.sd_setImage(with: URL(string: data?.urlToImage ?? ""), placeholderImage: UIImage(systemName: ""), options: .continueInBackground)
        cell?.viewNews.tag = indexPath.row
        cell?.viewNews.addTarget(self, action: #selector(viewMoreAction(_:)), for: .touchUpInside)
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Header") as? NewsHeaderCell
        cell?.titleLbl.text = "What's the Buzz"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    @objc func viewMoreAction(_ sender: UIButton){
        let data = NewsListViewModel.shared.newsData?.articles?[sender.tag]
        let vc = storyboard?.instantiateViewController(identifier: "ViewMoreNewsController") as? ViewMoreNewsController
        vc?.titleStr = data?.title ?? ""
        vc?.urlStriing = data?.url ?? ""
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

extension ViewController{
    
    func getNewsList(){
        NewsListViewModel.shared.news_list(success: {
            DispatchQueue.main.async {
                self.newsTable.reloadData()
            }
        }) { (errorMessage) in
            print(errorMessage)
            DispatchQueue.main.async {
                self.newsTable.reloadData()
            }
        }
    }
}
