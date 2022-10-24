//
//  CitiesViewController.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2022/10/17.
//


import UIKit

class CitiesViewController: UIViewController  {

    
    // MARK: -  Properties
    let tableView = UITableView()
    var cities = ["now", "Gangnam-gu"]

    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        setupNavigationItem()
        setupTableView()
        setupTableViewConstraints()
        setupSearchbar()
        tableView.isUserInteractionEnabled = true
        tableView.allowsSelectionDuringEditing = true
        tableView.dragInteractionEnabled = true
//        tableView.dragDelegate = self
//        tableView.dropDelegate = self
//        self.navigationItem.leftBarButtonItem?.title = .none

        
    }
    
    
    // MARK: - Helpers
    
    

    
    func setupSearchbar() {
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 30))
        navigationItem.titleView = searchBar
        searchBar.placeholder = "도시를 검색하세요."
        searchBar.delegate = self
    }
        
    func setupNavigationItem() {
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CitiesViewCell.self, forCellReuseIdentifier: cellID.forCitiesCell)
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
    }

    func setupTableViewConstraints() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
        
        
    
}

// MARK: - tableView dataSource extension
extension CitiesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID.forCitiesCell) as! CitiesViewCell
        
       

        cell.cellDelegate = self
        
        return cell
    }


    
}

// MARK: - UITableViewDelegate

extension CitiesViewController: UITableViewDelegate {
    
    
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//
//            let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { action, view, completionHandler in
//
//                let city = cities[indexPath.row]
////                ramen.bookmark = false
//
//
//                completionHandler(true)
//
//            }
//            deleteAction.backgroundColor = .red
//            let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
//            swipeActions.performsFirstActionWithFullSwipe = false
//            return swipeActions
//
//
//    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
//     delete 모드로 수정
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    


    
// MARK: - tableview move / drag / drop delegate
    /*
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        
        guard let ramens = ramens else { return }
        
        if sourceIndexPath.row > destinationIndexPath.row {
            for i in destinationIndexPath.row..<sourceIndexPath.row {
                ramens[i].setValue(i+1, forKey: "order")
            }
            
            ramens[sourceIndexPath.row].setValue(destinationIndexPath.row, forKey: "order")
        }
        
        if sourceIndexPath.row < destinationIndexPath.row {
            for i in sourceIndexPath.row + 1...destinationIndexPath.row {
                ramens[i].setValue(i-1, forKey: "order")
            }
            
            ramens[sourceIndexPath.row].setValue(destinationIndexPath.row, forKey: "order")
        }

        print(ramens)

    }

    
}

extension CitiesViewController: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return [UIDragItem(itemProvider: NSItemProvider())]
    }
}

extension CitiesViewController: UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        if session.localDragSession != nil {
            return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UITableViewDropProposal(operation: .cancel, intent: .unspecified)
    }
    
*/
}


// MARK: - 서치바 익스텐션
extension CitiesViewController: UISearchBarDelegate {
    // 서치바에서 검색을 시작할 때 호출
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        getWeatherDataDependingText(searchBar: searchBar)
        self.tableView.reloadData()
        navigationItem.rightBarButtonItem = .none
        searchBar.showsCancelButton = true
        tableView.dragInteractionEnabled = false
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        getWeatherDataDependingText(searchBar: searchBar)
        self.tableView.reloadData()
        tableView.dragInteractionEnabled = false

    }
    
    // 서치바에서 검색버튼을 눌렀을 때 호출
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        getWeatherDataDependingText(searchBar: searchBar)
        self.tableView.reloadData()
        searchBar.resignFirstResponder()
        tableView.dragInteractionEnabled = false

    }
    
    // 서치바에서 취소 버튼을 눌렀을 때 호출
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {

        searchBar.text = ""
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        self.tableView.reloadData()
        tableView.dragInteractionEnabled = true

    }
    
    // 서치바 검색이 끝났을 때 호출
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.tableView.reloadData()
    }
    
    func getWeatherDataDependingText(searchBar: UISearchBar) {
        if searchBar.text!.isEmpty {
            
        } else {
            
        }
    }
}

extension CitiesViewController: CellButtonActionDelegate {
    func bookmarkButtonTapped(_ id: String) {
        
    }

}



