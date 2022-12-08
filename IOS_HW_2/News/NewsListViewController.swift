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
    private var shimmerView = ShimmerView()
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
        
        setShimmerViewUI()
        
        setTableViewDelegate()
        setTableViewCell()
        fetchNews()
        setupNavBar()
    }
    
    private func setupNavBar() {
        navigationItem.title = "Articles"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(goBack)
        )
        navigationItem.leftBarButtonItem?.tintColor = .label
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "arrow.counterclockwise"),
            style: .plain,
            target: self,
            action: #selector(loadNews)
        )
        navigationItem.rightBarButtonItem?.tintColor = .label
    }
    
    private func setTableViewDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setShimmerViewUI() {
        view.addSubview(shimmerView)
        
        shimmerView.startAnimating()
        
        shimmerView.isHidden = true
        shimmerView.backgroundColor = .clear
        shimmerView.pinLeft(to: view)
        shimmerView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        shimmerView.pinRight(to: view)
        shimmerView.pinBottom(to: view)
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
        print("А это че, кнопка чтоли???")
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
            shimmerView.startAnimating()
            shimmerView.isHidden = false
            return 1;
        } else {
            shimmerView.startAnimating()
            shimmerView.isHidden = true
            return newsViewModels.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoading{
            print("а где анимация?")
            shimmerView.startAnimating()
            shimmerView.isHidden = false
            return UITableViewCell()
        }
        else{
            shimmerView.startAnimating()
            shimmerView.isHidden = true
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


extension NewsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isLoading {
            let newsVC = NewsViewController()
            newsVC.configure(with: newsViewModels[indexPath.row])
            navigationController?.pushViewController(newsVC, animated: true)
        }
    }
}

