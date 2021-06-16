//
//  ArticleListDataSource.swift
//  QiitaMVVM
//
//  Created by 信田　虎太郎 on 2021/06/11.
//

import Foundation

import RxDataSources

struct ArticleListTableViewSection {
    var items: [QiitaArticle]
}

extension ArticleListTableViewSection: SectionModelType{
    init(original: ArticleListTableViewSection, items: [QiitaArticle]) {
        self = original
        self.items = items
    }
}
