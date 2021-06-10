//
//  QiitaArticle.swift
//  QiitaMVVM
//
//  Created by 信田　虎太郎 on 2021/06/09.
//

import Foundation

struct QiitaArticle: Codable {
    var title: String
    var body: String
    var url: String
    var created_at: String
    var updated_at: String
    var user: User
    struct User: Codable {
        var name: String
    }
}
