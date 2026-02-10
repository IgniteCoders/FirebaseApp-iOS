//
//  User.swift
//  FirebaseApp
//
//  Created by Tardes on 9/2/26.
//

struct User: Codable {
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    let gender: Int?
    let birthdate: Int64?
    let photoUrl: String?
}
