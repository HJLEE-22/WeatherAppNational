//
//  CitiesViewController.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2022/10/17.
//


import UIKit

class CitiesViewController: UIViewController  {
    
    // MARK: -  Properties
    let cityListForSearchTableView = UITableView()

        
    private var viewModel: CitiesViewModel = CitiesViewModel() {
        didSet {
            viewModel.subscribe(observer: self)
        }
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        setupNavigationItem()
        setupCityListForSearchTableView()
        setupCityListForSearchTableViewConstraints()
        setupSearchbar()
        //        tableView.dragDelegate = self
        //        tableView.dropDelegate = self
        self.navigationItem.leftBarButtonItem?.title = .none
    }
    
    deinit {
        viewModel.unSubscribe(observer: self)
    }
    
    // MARK: - Helpers

    func setupSearchbar() {
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 30))
        navigationItem.titleView = searchBar
        searchBar.placeholder = "도시를 검색하세요."
        searchBar.searchTextField.font = UIFont.systemFont(ofSize: 15)
        searchBar.delegate = self
    }
    
    func setupNavigationItem() {
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func setupCityListForSearchTableView() {
        cityListForSearchTableView.delegate = self
        cityListForSearchTableView.dataSource = self
        cityListForSearchTableView.register(CitiesListViewCell.self, forCellReuseIdentifier: CellID.forCitiesListCell)
        cityListForSearchTableView.allowsSelection = true
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
            cityListForSearchTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cityListForSearchTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cityListForSearchTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    
    // MARK: - Helpers for data
    // MVVM에선 VC에 data와 관련된 코드가 있으면 안됨!

}

// MARK: - tableView dataSource extension
extension CitiesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getLocationGrid().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellID.forCitiesListCell) as! CitiesListViewCell
        let model = viewModel.getLocationGrid()[indexPath.row]
        DispatchQueue.main.async {
            cell.configureUIByData(model)
        }
        cell.bookmarkButton.setOpaqueTapGestureRecognizer { [weak self] in
            self?.viewModel.updateLocationGridsBookmark(model)
            tableView.reloadData()
        }
        return cell
        
//        switch tableView {
//        case bookmarkCitiesTableView :
//            let cell = tableView.dequeueReusableCell(withIdentifier: CellID.forCitiesCell) as! CitiesViewCell
//            cell.cellDelegate = self
//            return cell
//        case cityListForSearchTableView :
//            let cell = tableView.dequeueReusableCell(withIdentifier: CellID.forCitiesListCell) as! CitiesListViewCell
//            cell.city = self.cities[indexPath.row]
//            cell.cellDelegate = self
//            return cell
//        default :
//            break
//    }
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellID.forCitiesCell) as! CitiesViewCell
        // 임의의 전체반환 셀이 필요한데 이거를 방지혀려면 차라리 if문이 나을까?
//        return UITableViewCell()
    }
}

// MARK: - UITableViewDelegate

extension CitiesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let weatherVC = WeatherViewController()

        let selectedLocation = viewModel.getLocationGrid()[indexPath.row]
        guard let city = selectedLocation.city,
              let district = selectedLocation.district else { return }
        let selectedLocationName = "\(city) \(district)"
//        let selectedLocationGridX = Int(selectedLocation.gridX)
//        let selectedLocationGridY = Int(selectedLocation.gridY)
        let selectedLocationLatitude = selectedLocation.latitude
        let selectedLocationLongitude = selectedLocation.longitude
//        weatherVC.weatherViewModel = .init(name: selectedLocationName, nx: selectedLocationGridX, ny: selectedLocationGridY)
        weatherVC.weatherKitViewModel = .init(name: selectedLocationName, latitude: selectedLocationLatitude, longitude: selectedLocationLongitude)

        show(weatherVC, sender: nil)
//        weatherVC.navigationItem.title = weatherVC.weatherViewModel.name
        weatherVC.navigationItem.title = weatherVC.weatherKitViewModel.name
        weatherVC.view.backgroundColor = .white
        
    }
    
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
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        if text == "" {
            self.viewModel.getLocationGridForViewMdodel()
            cityListForSearchTableView.reloadData()
        } else {
            viewModel.getFilteredLocationGrid(by: text)
            self.cityListForSearchTableView.reloadData()
            navigationItem.rightBarButtonItem = .none
            searchBar.showsCancelButton = true
            cityListForSearchTableView.dragInteractionEnabled = false
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text else { return }
        viewModel.getFilteredLocationGrid(by: text)
        self.cityListForSearchTableView.reloadData()
        cityListForSearchTableView.dragInteractionEnabled = false
    }

    // 서치바에서 검색버튼을 눌렀을 때 호출
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        viewModel.getFilteredLocationGrid(by: text)
        self.cityListForSearchTableView.reloadData()
        searchBar.resignFirstResponder()
        cityListForSearchTableView.dragInteractionEnabled = false
    }
    
    // 서치바에서 취소 버튼을 눌렀을 때 호출
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        viewModel.bindLocationGridData()
        self.cityListForSearchTableView.reloadData()
    }
    
    // 서치바 검색이 끝났을 때 호출
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    }
}

extension CitiesViewController: Observer {
    func update<T>(updateValue: T) {
        guard let value = updateValue as? [LocationGridData] else { return }
        DispatchQueue.main.async { [weak self] in
            self?.cityListForSearchTableView.reloadData()
        }
    }
}
