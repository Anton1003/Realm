//
//  ViewController.swift
//  Realm
//
//  Created by User on 24.12.2020.
//

import UIKit
import RealmSwift

class MainViewController: UITableViewController {
    
    var realm: Realm! // создаем переменную через которую будем получать доступ к работе с реалмом
    
    var toDoList: Results<ToDoListItem> {
        get {
            return realm.objects(ToDoListItem.self)
        }
    } // создаем массив в котором будут хранится все созданные записи и получаем доступ к их сохранению и получению через реалм

    override func viewDidLoad() {
        super.viewDidLoad()
        realm = try! Realm() // перед запуском экрана загружаем сохранненые записи
    }
    
    //MARK: - Работа с таблицей
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoList.count // устанавливаем количество ячеек
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item = toDoList[indexPath.row] // получаем доступ к ячейке
        cell.textLabel?.text = item.name // задаем текст в ячейке
        
        cell.accessoryType = item.done == true ? .checkmark : .none // устанавливаем чек-марку через тернарный оператор
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = toDoList[indexPath.row] // определяем на какую именно ячейку нажали
        
        try! self.realm.write({
            item.done = !item.done // сохраняем состояние строки нажималась или не нажималась
        })
        
        tableView.reloadRows(at: [indexPath], with: .automatic) // анимированно перезагружаем нажатую строку для внесения изменений
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true //включаем режим редактирования
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let item = toDoList[indexPath.row]
            
            try! self.realm.write({
                self.realm.delete(item)
            }) // отрабатываем нажатие на кнопку удалить и удаляем запись из реалма
            tableView.deleteRows(at: [indexPath], with: .automatic) //удаляем строку из таблицы
        }
    }

    @IBAction func addPressedButton(_ sender: UIBarButtonItem) {
        let alertVC = UIAlertController(title: "New ToDo", message: "What do you want to do?", preferredStyle: .alert)// создаем алерт контроллер (всплывающее окно для сохранения задач)
        alertVC.addTextField { (UITextField) in
            // создаем тексфиелд в который будет вводиться задача
        }
        
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .destructive, handler: nil) // создаем кнопку отмены
        alertVC.addAction(cancelAction) // добавляем в алерт контроллер
        
        let addAction = UIAlertAction(title: "Add", style: .cancel) { (UIAlertAction) -> Void in // создаем кнопку добавить
            let toDoItemTextField = (alertVC.textFields?.first)! as UITextField // получаем доступ к текстфилду в алерт контроллере
            
            let newToDoListItem = ToDoListItem() // получаем доступ к реалмовскому классу
            newToDoListItem.name = toDoItemTextField.text! // получаем введеную запись для сохранения
            newToDoListItem.done = false // ??? говорим о том что строка не пустая???
            
            try! self.realm.write({
                self.realm.add(newToDoListItem) // сохраняем введеную запись в реалм
            
            self.tableView.insertRows(at: [IndexPath.init(row: self.toDoList.count-1, section: 0)], with: .automatic)
            })// добавляем новую строку в таблицу в которой будет новая задача
        }
        alertVC.addAction(addAction) // добавляем кнопку "добавить" в алерт контроллер
        present(alertVC, animated: true, completion: nil) // отображаем алерт контроллер на экране
    }
}

