//
//  CitiesViewController.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2022/10/17.
//


import UIKit

class CitiesViewController: UIViewController  {
    
    // MARK: -  Properties
//    let bookmarkCitiesTableView = UITableView()
//    let cityListForSearchTableView = UITableView()
//    var cities: [LocationGridData] = []
    
    private lazy var citiesView = CitiesView()
    
    var viewModel : CitiesViewModel! {
        didSet {
            viewModel.subscribe(observer: self)
        }
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        setupNavigationItem()
//        setupBookmarkCitiesTableView()
//        setupBookmarkCitiesTableViewConstraints()
//        setupSearchbar()

        //        tableView.dragDelegate = self
        //        tableView.dropDelegate = self
        //        self.navigationItem.leftBarButtonItem?.title = .none
//        cities = CoreDataManager.shared.getLocationGridListFromCoreData()
//        updateLocationGridsByBookmark()
    }
    
    deinit {
        viewModel.unSubscribe(observer: self)
    }
    
    // MARK: - Helpers
    
    func setupUI() {
        self.view.addSubview(citiesView)
        citiesView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            citiesView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            citiesView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            citiesView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            citiesView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
    }
    
    
    // 고민지점
    // 특정 파라미터에 따라 ViewModel을 초기화하고 만들어줘야 하는 건 여기 VC.
    // 여기서 만든 viewModel을 update를 통해 View로 전달한다.
    // 그런데, 나는 원하는 viewModel값을 위해 필터링이 필요하고, 해당 필터링 값은 searchBar의 텍스트 값이나 데이터내의 bool값.
    // searchBar를 tableView와 같이 View로 옮겼는데, 이러면 VC에 있어야겠지...?
    // 서치바 텍스트를 받는 변수를 전역으로 만들어서 그걸로 주고받아야 될 것 같은데 깔끔한 코드는 아닌것 같은데...
    func setupViewModel() {
//        self.viewModel = .init(parameterForFiltering: <#T##String?#>, bookmarkBool: <#T##Bool?#>)
        
    }
    
    
//    func setupSearchbar() {
//        navigationItem.titleView = citiesView.searchBar
//        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 30))
//        navigationItem.titleView = searchBar
//        searchBar.placeholder = "도시를 검색하세요."
//        searchBar.searchTextField.font = UIFont.systemFont(ofSize: 15)
//        searchBar.delegate = self
//    }
    
    func setupNavigationItem() {
        navigationItem.largeTitleDisplayMode = .never
    }
    /*
    func setupBookmarkCitiesTableView() {
        bookmarkCitiesTableView.delegate = self
        bookmarkCitiesTableView.dataSource = self
        bookmarkCitiesTableView.register(CitiesViewCell.self, forCellReuseIdentifier: cellID.forCitiesCell)
        bookmarkCitiesTableView.allowsSelection = false
        bookmarkCitiesTableView.separatorStyle = .none
        bookmarkCitiesTableView.isUserInteractionEnabled = true
        bookmarkCitiesTableView.allowsSelectionDuringEditing = true
        bookmarkCitiesTableView.dragInteractionEnabled = true
    }
    
    func setupBookmarkCitiesTableViewConstraints() {
        view.addSubview(bookmarkCitiesTableView)
        bookmarkCitiesTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bookmarkCitiesTableView.topAnchor.constraint(equalTo: view.topAnchor),
            bookmarkCitiesTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bookmarkCitiesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bookmarkCitiesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func setupCityListForSearchTableView() {
        cityListForSearchTableView.delegate = self
        cityListForSearchTableView.dataSource = self
        cityListForSearchTableView.register(CitiesListViewCell.self, forCellReuseIdentifier: cellID.forCitiesListCell)
        cityListForSearchTableView.allowsSelection = false
        cityListForSearchTableView.separatorStyle = .none
        cityListForSearchTableView.isUserInteractionEnabled = true
        cityListForSearchTableView.allowsSelectionDuringEditing = true
        cityListForSearchTableView.dragInteractionEnabled = true
    }
    
    func setupCityListForSearchTableViewConstraints() {
        view.addSubview(cityListForSearchTableView)
        cityListForSearchTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cityListForSearchTableView.topAnchor.constraint(equalTo: view.topAnchor),
            cityListForSearchTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            cityListForSearchTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cityListForSearchTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    
    // MARK: - Helpers for data
    
    func updateLocationGridsByBookmark() {
        cities = getLocationGrid().filter({ $0.bookmark == true })
    }
    
    func getLocationGrid() -> [LocationGridData] {
        CoreDataManager.shared.getLocationGridListFromCoreData()
    }
    */
}
/*
// MARK: - tableView dataSource extension
extension CitiesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableView {
        case bookmarkCitiesTableView :
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID.forCitiesCell) as! CitiesViewCell
            cell.cellDelegate = self
            return cell
        case cityListForSearchTableView :
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID.forCitiesListCell) as! CitiesListViewCell
            cell.cellDelegate = self
            return cell
        default :
            break
    }
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellID.forCitiesCell) as! CitiesViewCell
        // 임의의 전체반환 셀이 필요한데 이거를 방지혀려면 차라리 if문이 나을까?
        return UITableViewCell()
    }
}
 */
/*
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
    
*/

    
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
//}


/*
// MARK: - 서치바 익스텐션
extension CitiesViewController: UISearchBarDelegate {
    // 서치바에서 검색을 시작할 때 호출
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        getWeatherDataDependingText(searchBar: searchBar)
//        self.bookmarkCitiesTableView.reloadData()
        self.cityListForSearchTableView.reloadData()
        navigationItem.rightBarButtonItem = .none
        searchBar.showsCancelButton = true
//        bookmarkCitiesTableView.dragInteractionEnabled = false
        cityListForSearchTableView.dragInteractionEnabled = false
        setupCityListForSearchTableView()
        setupCityListForSearchTableViewConstraints()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        getWeatherDataDependingText(searchBar: searchBar)
//        self.bookmarkCitiesTableView.reloadData()
        self.cityListForSearchTableView.reloadData()
        cityListForSearchTableView.dragInteractionEnabled = false
//        bookmarkCitiesTableView.dragInteractionEnabled = false
    }
    
    // 서치바에서 검색버튼을 눌렀을 때 호출
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        getWeatherDataDependingText(searchBar: searchBar)
//        self.bookmarkCitiesTableView.reloadData()
        searchBar.resignFirstResponder()
//        bookmarkCitiesTableView.dragInteractionEnabled = false
        self.cityListForSearchTableView.reloadData()
        cityListForSearchTableView.dragInteractionEnabled = false
    }
    
    // 서치바에서 취소 버튼을 눌렀을 때 호출
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        self.cityListForSearchTableView.removeFromSuperview()
        self.bookmarkCitiesTableView.reloadData()
        bookmarkCitiesTableView.dragInteractionEnabled = true
    }
    
    // 서치바 검색이 끝났을 때 호출
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.bookmarkCitiesTableView.reloadData()
        self.cityListForSearchTableView.removeFromSuperview()
    }
    
    func getWeatherDataDependingText(searchBar: UISearchBar) {
        if searchBar.text!.isEmpty {
            cities = getLocationGrid()
        } else {
            guard let searchBarText = searchBar.text else { return }
            cities = getLocationGrid().filter({ $0.city!.contains(searchBarText) || $0.district!.contains(searchBarText) })
        }
    }
}

 */

extension CitiesViewController: CellButtonActionDelegate {
    func bookmarkButtonTapped(_ id: String) {
        
    }
}


extension CitiesViewController: Observer {
    func update<T>(updateValue: T) {
        guard let value = updateValue as? [LocationGridData] else { return }
        DispatchQueue.main.async { [weak self] in
            self?.citiesView.cities = value
        }
    }
}
