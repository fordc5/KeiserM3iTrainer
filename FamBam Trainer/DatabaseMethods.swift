//
//  DatabaseMethods.swift
//  FamBam Trainer
//
//  Created by Connor Ford on 8/20/18.
//  Copyright © 2018 tiagoProd. All rights reserved.
//


class DatabaseMethods {
    
    class func getUsers(completionHandler: @escaping (_ users: [String]) -> ()) {
        print("querying usernames from database")
        var userNames = [String]()
        db.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    if data["First"] != nil {
                        let first : String = data["First"] as! String
                        let last : String = data["Last"] as! String
                        userNames.append("\(first) \(last)")
                    }
                }
            }
            completionHandler(userNames)
        }
    }

    
    class func getUserData(key : String, completionHandler: @escaping (_ data : [String : Any]) -> ()){
        print("querying data from database")
        
        let docRef = db.collection("users").document(key)
        var userData = [String : Any]()
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                userData = document.data()!
            } else {
                print("Document does not exist")
            }
            completionHandler(userData)
        }
    }
    
}
