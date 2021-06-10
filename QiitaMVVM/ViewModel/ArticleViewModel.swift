//
//  ArticleViewModel.swift
//  QiitaMVVM
//
//  Created by 信田　虎太郎 on 2021/06/09.
//

import Foundation
import RxSwift
import RxCocoa

protocol ArticleViewModelInputs {
    var scrollTrigger: PublishRelay<Int> {get}
}

protocol ArticleViewModelOutputs {
    var qiitaArticles: BehaviorRelay<[QiitaArticle]> {get}
}

protocol ArticleViewModelType {
    var inputs: ArticleViewModelInputs {get}
    var outputs: ArticleViewModelOutputs {get}
}

final class ArticleViewModel: ArticleViewModelType, ArticleViewModelInputs, ArticleViewModelOutputs {
    
    // MARK: - Inputs
    internal let scrollTrigger = PublishRelay<Int>()
    
    // MARK: - Outputs
    internal var qiitaArticles = BehaviorRelay<[QiitaArticle]>(value: [])
    
    // MARK: - Props
//    private let disposeBag = DisposeBag()
    private var qiitaApi = QiitaApi()
    
    // MARK: -
    var inputs: ArticleViewModelInputs {return self}
    var outputs: ArticleViewModelOutputs {return self}
    
    // MARK: - initializer
    init(disposeBag: DisposeBag){
        
        scrollTrigger.bind { page in
            print("トリガーきたよ")
            self.qiitaApi.getArticles(page).bind(onNext: {articles in
                self.qiitaArticles.accept(articles)
            }).disposed(by: disposeBag)
        }.disposed(by: disposeBag)
    
    }
    
    // MARK: - functions
    
}
