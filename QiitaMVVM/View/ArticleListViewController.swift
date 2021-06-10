//
//  ArticleListViewController.swift
//  QiitaMVVM
//
//  Created by 信田　虎太郎 on 2021/06/09.
//

import UIKit
import RxSwift
import RxCocoa

class ArticleListViewController: UIViewController {
    
    @IBOutlet weak var articleListTableView: UITableView!
    
    private let disposeBag = DisposeBag()

    private var qiitaArticles = BehaviorRelay<[QiitaArticle]>(value: [])
    
    
    
    private var page = BehaviorRelay<Int>(value: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewModel = ArticleViewModel(disposeBag: disposeBag)
        
        articleListTableView.delegate = self
        articleListTableView.dataSource = self
        self.articleListTableView.register(UINib(nibName: "ArticleListTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        // 
        viewModel.outputs.qiitaArticles.bind(to: qiitaArticles).disposed(by: disposeBag)

        // ページ数が更新されるたび、トリガーを流す
        page.bind(to: viewModel.inputs.scrollTrigger).disposed(by: disposeBag)
        
        // 記事一覧が更新された時、テーブルビューを更新
        qiitaArticles.skip(1).bind { _ in
            self.articleListTableView.reloadData()
        }.disposed(by: disposeBag)
    }
    
}

extension ArticleListViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return qiitaArticles.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ArticleListTableViewCell
        cell.title.text = qiitaArticles.value[indexPath.row].title
        return cell
    }
    
    // 記事取得のトリガーを流す
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row >= qiitaArticles.value.count - 5 && qiitaArticles.value.count / 30 == page.value {
            page.accept(page.value + 1)
        }
    }
    
}
