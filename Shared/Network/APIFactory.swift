//
//  APIFactory.swift
//  BCD
//
//  Created by Liuliet.Lee on 20/7/2018.
//  Copyright © 2018 Liuliet.Lee. All rights reserved.
//

import Foundation

enum Environment {
    case dev
    case prod
}

class APIFactory {
    
    static private func baseAPI(_ env: Environment = .prod) -> URLBuilder {
        let builder = URLBuilder().set(scheme: "http")
        switch env {
        case .prod:
            builder.set(host: "45.32.54.201")
        default: // .dev
            builder.set(host: "127.0.0.1").set(port: 8000)
        }
        return builder
    }
    
    static public func getAPI(
        withCommentPage page: Int,
        andCount limit: Int = 20,
        env: Environment = .prod
    ) -> URL? {
        return baseAPI(env)
            .set(path: "api/comment/all")
            .addQueryItem(name: "page", value: "\(page)")
            .addQueryItem(name: "limit", value: "\(limit)")
            .build()
    }
    
    static public func getAPI(
        byType type: CoverType,
        andNID nid: Int? = nil,
        andInfo newInfo: Info? = nil,
        env: Environment = .prod
    ) -> URL? {
        let builder = baseAPI(env)

        if type == .hotList {
            return builder.set(path: "api/hot_list").build()
        } else {
            if newInfo != nil {
                return builder.set(path: "api/db/update").build()
            } else {
                builder.set(path: "api/db/search")
            }
            
            switch type {
            case .video:   builder.addQueryItem(name: "type", value: "av")
            case .article: builder.addQueryItem(name: "type", value: "cv")
            case .live:    builder.addQueryItem(name: "type", value: "lv")
            default:       return nil
            }
            
            return builder.addQueryItem(name: "nid", value: "\(nid!)").build()
        }
        
    }
    
}
