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
    var scrollTrigger: AnyObserver<Int> {get}
}

protocol ArticleViewModelOutputs {
    var qiitaArticles: Observable<[QiitaArticle]> {get}
}

protocol ArticleViewModelType {
    var inputs: ArticleViewModelInputs {get}
    var outputs: ArticleViewModelOutputs {get}
}

final class ArticleViewModel: ArticleViewModelType, ArticleViewModelInputs, ArticleViewModelOutputs {
    
    // MARK: - Inputs
    internal let scrollTrigger: AnyObserver<Int>
    
    // MARK: - Outputs
    internal var qiitaArticles: Observable<[QiitaArticle]>
    
    // MARK: - Props
    private var qiitaApi: QiitaApi
    
    // MARK: - bind to View
    var inputs: ArticleViewModelInputs {return self}
    var outputs: ArticleViewModelOutputs {return self}
    
    // MARK: - initializer
    init(disposeBag: DisposeBag, qiitaApi: QiitaApi){
        
        // DI
        self.qiitaApi = qiitaApi
        
        // InputsをAnyObserverでラップ
        let _scrollTrigger = PublishRelay<Int>()
        self.scrollTrigger = AnyObserver<Int>() { event in
            guard let page = event.element else {return}
            _scrollTrigger.accept(page)
        }
        
        // OutputsをObservableでラップ
        let _qiitaArticles = BehaviorRelay<[QiitaArticle]>(value: [])
        self.qiitaArticles = _qiitaArticles.asObservable()
        
        // Inputsからきた値をModelでデータに変換してOutputsに出力
        _scrollTrigger.flatMap {
            self.qiitaApi.getArticles($0)
        }.bind {
            _qiitaArticles.accept($0)
        }.disposed(by: disposeBag)
        
    }
    
    // MARK: - functions
    
}
