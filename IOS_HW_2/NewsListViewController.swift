//
//  NewsListViewController.swift
//  IOS_HW_2
//
//  Created by Андрей Гусев on 08/12/2022.
//

import UIKit

final class NewsListViewController: UIViewController {
    private var tableView = UITableView(frame: .zero, style: .plain)
    private var isLoading = false
    private var newsViewModels = [NewsViewModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        configureTableView()
    }
    
    private func configureTableView() {
        setTableViewUI()
        setTableViewDelegate()
        setTableViewCell()
        fetchNews()
    }
    
    
    private func setTableViewDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setTableViewUI() {
        view.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.rowHeight = 120
        tableView.pinLeft(to: view)
        tableView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        tableView.pinRight(to: view)
        tableView.pinBottom(to: view)
    }
    
    private func setTableViewCell() {
        tableView.register(NewsCell.self, forCellReuseIdentifier: NewsCell.reuseIdentifier)
    }
    
    
    @objc
    private func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    func loadNews(){
        self.isLoading = true
        self.tableView.reloadData()
        self.fetchNews()
    }
    
    private func fetchNews() {
        self.isLoading = true
        URLSession.shared.getTopStories { [weak self] result in
            self?.newsViewModels = result.articles.compactMap{
                NewsViewModel(
                    title: $0.title,
                    description: $0.description ?? "No description",
                    imageURL: URL(string: $0.urlToImage ?? "")
                )
            }
            DispatchQueue.main.async {
                self?.isLoading = false
                self?.tableView.reloadData()
            }
        }
    }
}

extension NewsListViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading {
            return 1;
        } else {
            return newsViewModels.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoading{
            if let newsCell = tableView.dequeueReusableCell(
                withIdentifier: NewsCell.reuseIdentifier,
                for: indexPath
            ) as? NewsCell{
                newsCell.onLoadConfigure()
                return newsCell
            }
        }
        else{
            let viewModel = newsViewModels[indexPath.row]
            if let newsCell = tableView.dequeueReusableCell(
                withIdentifier: NewsCell.reuseIdentifier,
                for: indexPath
            ) as? NewsCell{
                newsCell.configure(with: viewModel)
                return newsCell
            }
            
        }
        return UITableViewCell()
    }
}

//extension NewsListViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    }
//}

extension NewsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isLoading {
            let newsVC = NewsViewController()
            newsVC.configure(with: newsViewModels[indexPath.row])
            navigationController?.pushViewController(newsVC, animated: true)
        }
    }
}

