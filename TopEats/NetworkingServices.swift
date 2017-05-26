//
//  NetworkingServices.swift
//  TopEats
//
//  Created by Mbusi Hlatshwayo on 5/19/17.
//  Copyright © 2017 RainbowApps. All rights reserved.
//

import Foundation
import Firebase

class NetworkingServices {
    static func createUser(email: String!, password: String!) {
        Auth.auth().createUser(withEmail: email, password: password, completion: {(user, error) in
            if error != nil {
                print("Error")
                return
            }else{
                print("Login Successful")
                return
            }
        })

    }
}
