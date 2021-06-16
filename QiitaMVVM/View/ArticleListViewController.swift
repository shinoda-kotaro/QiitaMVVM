//
//  ArticleListViewController.swift
//  QiitaMVVM
//
//  Created by 信田　虎太郎 on 2021/06/09.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class ArticleListViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var articleListTableView: UITableView!
    
    private let qiitaApi = QiitaApi()
    
    private let disposeBag = DisposeBag()
    
    private var page = BehaviorRelay<Int>(value: 1)
    
    private var dataSource: RxTableViewSectionedReloadDataSource<ArticleListTableViewSection>!
    
    private lazy var viewModel = ArticleViewModel(disposeBag: disposeBag, qiitaApi: qiitaApi)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // テーブルビューセルの設定
        self.articleListTableView.register(UINib(nibName: "ArticleListTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        // テーブルビューのdelegateを設定
        self.articleListTableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        // データソースの設定
        self.dataSource = RxTableViewSectionedReloadDataSource<ArticleListTableViewSection>(configureCell: { dataSource, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: IndexPath(row: indexPath.row, section: 0)) as! ArticleListTableViewCell
            cell.title.text = item.title
            return cell
        })
        
        // データソースをバインドさせて差分更新
        self.viewModel.outputs.qiitaArticles
            .bind(to: articleListTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        // ページ数が更新されるたび、トリガーを流す
        page.bind(to: viewModel.inputs.scrollTrigger).disposed(by: disposeBag)
        
        // ページの更新（無限スクロール）
        articleListTableView.rx.willDisplayCell.filter { event in
            event.indexPath.row >= self.articleListTableView.numberOfRows(inSection: 0) - 5 && self.articleListTableView.numberOfRows(inSection: 0) / 30 == self.page.value
        }.bind { _ in
            self.page.accept(self.page.value + 1)
        }.disposed(by: disposeBag)
    }
}
