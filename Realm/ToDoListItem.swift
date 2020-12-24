//
//  ToDoListItem.swift
//  Realm
//
//  Created by User on 24.12.2020.
//

import Foundation
import RealmSwift

//MARK: - Создаем класс для работы с реалмом

class ToDoListItem: Object {
    @objc dynamic var name = ""
    @objc dynamic var done = false
}
