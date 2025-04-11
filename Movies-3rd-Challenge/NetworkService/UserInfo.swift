//
//  GetUser.swift
//  Movies-3rd-Challenge
//
//  Created by Евгений on 10.04.2025.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class UserInfo{
    static let shared = UserInfo()
    private init() {}
    
    //MARK: Получение Юзера
    func getUser(completion: @escaping (User?) -> Void) {
        guard let email = Auth.auth().currentUser?.email else {
                completion(nil)
                return
            }
        
        let dataBase = Firestore.firestore()
        dataBase.collection(UsersFireSore.collectionName.rawValue)
            .whereField(UsersFireSore.email.rawValue, isEqualTo: email)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Ошибка получения документов: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                
                guard let documents = snapshot?.documents, !documents.isEmpty else {
                    print("Пользователь с email '\(email)' не имеет сохраненных документов")
                    completion(nil)
                    return
                }
                
                let document = documents.first!
                let data = document.data()
                let id = document[UsersFireSore.id.rawValue] as? String ?? ""
                let name = data[UsersFireSore.firstName.rawValue] as? String ?? ""
                let lastName = data[UsersFireSore.lastName.rawValue] as? String ?? ""
                let email = data[UsersFireSore.email.rawValue] as? String ?? ""
                let male = data[UsersFireSore.male.rawValue] as? String ?? ""
                let dateOfBirth = data[UsersFireSore.dateOfBirth.rawValue] as? String ?? ""
                let location = data[UsersFireSore.location.rawValue] as? String ?? ""
                let didSeeOnboarding = data["didSeeOnboarding"] as? Bool ?? false

                let makeUser = User(id: id, firstName: name, lastName: lastName,
                                    email: email, male: male, dateOfBirth: dateOfBirth,
                                    location: location, didSeeOnboarding: didSeeOnboarding)
                completion(makeUser)
            }
    }
    //MARK:  Обновление данных
    func updateDataUser(user: User, completion: @escaping (Bool) -> Void) {
        guard !user.id.isEmpty else {
            print("Ошибка: ID пользователя пустой")
            return completion(false)
        }
        
        let dataBase = Firestore.firestore()
        dataBase.collection(UsersFireSore.collectionName.rawValue).document(user.id).updateData([
            UsersFireSore.id.rawValue: user.id,
            UsersFireSore.firstName.rawValue: user.firstName,
            UsersFireSore.lastName.rawValue: user.lastName,
            UsersFireSore.email.rawValue: user.email,
            UsersFireSore.dateOfBirth.rawValue: user.dateOfBirth,
            UsersFireSore.male.rawValue: user.male,
            UsersFireSore.location.rawValue: user.location
        ]) { error in
            if let error = error {
                print("Ошибка обновления данных: \(error.localizedDescription)")
                completion(false)
                return
            }
            print("Данные успешно обновлены")
            completion(true)
        }
    }
    // получаем айди
    func getCurrentUserID() -> String? {
        return Auth.auth().currentUser?.uid
    }
    
}


//MARK: Enum
enum UsersFireSore: String {
    case id = "id"
    case collectionName = "Users"
    case firstName = "Имя"
    case lastName = "Фамилия"
    case email = "Email"
    case male = "Пол"
    case dateOfBirth = "Дата рождения"
    case location = "Местоположение"
}
//MARK: USER
class User {
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    let male: String
    let dateOfBirth: String
    let location: String
    let didSeeOnboarding: Bool
    
    init(id: String, firstName: String, lastName: String, email: String, male: String, dateOfBirth: String, location: String, didSeeOnboarding: Bool) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.male = male
        self.dateOfBirth = dateOfBirth
        self.location = location
        self.didSeeOnboarding = didSeeOnboarding

    }
}
