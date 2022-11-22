//
//  NotesViewController.swift
//  IOS_HW_2
//
//  Created by Андрей Гусев on 22/11/2022.
//

import UIKit

final class NotesViewController : UIViewController{
    
    var num = 0
    
    private func handleDelete(indexPath: IndexPath) {
        dataSource.remove(at: indexPath.row)
        tableView.reloadData()
        saveData()
    }
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private var dataSource = [ShortNote]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupView()
    }
    
    private func setupTableView() {
        tableView.register(NoteCell.self, forCellReuseIdentifier: NoteCell.reuseIdentifier)
        tableView.register(AddNoteCell.self, forCellReuseIdentifier: AddNoteCell.reuseIdentifier)
        view.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.keyboardDismissMode = .onDrag
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.pin(to: self.view, [.left: 0, .top: 0, .right: 0, .bottom: 0])
    }
    
    private func setupView() {
        setupTableView()
        setupNavBar()
        decodeFile()
    }
    
    private func  setupNavBar(){
        self.title = "Notes"
        let closeButton = UIButton(type: .close)
        closeButton.addTarget(self, action: #selector(dismissViewController(_:)),
        for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView:
        closeButton)
    }
    
    @objc
    private func dismissViewController(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func saveData() {
        print("--------------------------------------------------------------------------------------")
        var tmp = [String]()
        for el in dataSource{
            tmp.append(el.text)
        }
        guard let data = try? JSONSerialization.data(withJSONObject: tmp, options: []) else {
            return
        }
        //var str : String
        let str = String(data: data, encoding: String.Encoding.utf8)
        //print(str)
        print("--------------------------------------------------------------------------------------")
        //        let path = FileManager.default.urls(
        //            for: .documentDirectory,
        //            in: .userDomainMask
        //        ) [0].appendingPathComponent("myFile")
        //        if let stringData = str.data(using: .utf8) {
        //            try? stringData.write(to: path)
        //        }
        //let file = "file.txt" //this is the file. we will write to and read from it
        
        guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileURL = path.appendingPathComponent("Output.json")
        do {
            try str?.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
            print(error.localizedDescription)
        }

    }
    
    func decodeFile() {
//        let path = FileManager.default.urls(
//            for: .documentDirectory,
//            in: .userDomainMask
//        ) [0].appendingPathComponent("myFile")
        guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        var str : String
        str = ""
        let fileURL = path.appendingPathComponent("Output.json")
        do {
            str = try String(contentsOf: fileURL, encoding: .utf8)
        } catch {
            print(error.localizedDescription)
        }
        print("ИЗ ФАЙЛА",str)
        do {

            let jsonDecoder = JSONDecoder()
            let file = try Data(contentsOf: fileURL)
            let data = try! jsonDecoder.decode([String].self, from: file)
            for el in data {
                var tmp = ShortNote(text: el)
                dataSource.append(tmp)
            }
            } catch {
                print(error.localizedDescription)
            }
        
    }
    
}

extension NotesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        switch section {
        case 0:
            return 1
        default:
            return dataSource.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
    UITableViewCell {
    switch indexPath.section {
    case 0:
        if let addNewCell = tableView.dequeueReusableCell(
            withIdentifier: AddNoteCell.reuseIdentifier,
            for: indexPath
        ) as? AddNoteCell {
            addNewCell.delegate = self
            return addNewCell
        }
    default:
        let note = dataSource[indexPath.row]
        if let noteCell = tableView.dequeueReusableCell(
            withIdentifier: NoteCell.reuseIdentifier,
            for: indexPath
        ) as? NoteCell {
            noteCell.configure(note)
            return noteCell
        }
    }
    return UITableViewCell()
    }
}

extension NotesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt
                   indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if (indexPath.section == 0) {
            return UISwipeActionsConfiguration()
        }
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: .none
        ) { [weak self] (action, view, completion) in
            self?.handleDelete(indexPath: indexPath)
            completion(true)
        }
        deleteAction.image = UIImage(
            systemName: "trash.fill",
            withConfiguration: UIImage.SymbolConfiguration(weight: .bold)
        )?.withTintColor(.white)
        deleteAction.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

extension NotesViewController: AddNoteDelegate {
    func newNoteAdded(note: ShortNote) {
        dataSource.insert(note, at: 0)
        tableView.reloadData()
        saveData()
    }
}



