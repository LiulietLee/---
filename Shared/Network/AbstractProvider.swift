//
//  AbstractProvider.swift
//  BCD
//
//  Created by Liuliet.Lee on 27/9/2018.
//  Copyright © 2018 Liuliet.Lee. All rights reserved.
//

import Foundation

class AbstractProvider {
    
    internal let session = URLSession.shared
    internal let env = Environment.prod

}

import Alamofire

extension Session {
    static let noRedirect = Session(redirectHandler: Redirector(behavior: .doNotFollow))
}
