//
//  QiitaApi.swift
//  QiitaMVVM
//
//  Created by 信田　虎太郎 on 2021/06/09.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

class QiitaApi {
    let baseURL = "https://qiita.com/api/v2/items"
    
    var currentArticles = Array<QiitaArticle>()
    
    func getArticles(_ page: Int) -> Observable<[QiitaArticle]> {
        let parameters = ["per_page": 30,"page": page]
        
        return Observable.create { observer in
            
            AF.request(self.baseURL, parameters: parameters).response { res in
                switch res.result {
                
                case .success(let jsonData): do {
                    guard let jsonData = jsonData else {return}
                    let articles = try JSONDecoder().decode([QiitaArticle].self, from: jsonData)
                    
                    self.currentArticles += articles
                    observer.onNext(self.currentArticles)
                    observer.onCompleted()
                    
                }catch{
                    print("デコードエラー")
                }
                
                case .failure(let error):
                    print("エラー: \(error)")
                }
                
            }
            return Disposables.create()
        }
        
    }
}
