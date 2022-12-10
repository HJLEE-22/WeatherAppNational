//
//  CitiesView.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2022/12/07.
//

import UIKit

class CitiesView: UIView {
    
    // MARK: - Properties
    
    let bookmarkCitiesTableView = UITableView()
    let cityListForSearchTableView = UITableView()
    var cities: [LocationGridData]? {
        didSet {
            if let cities = cities {
                self.bookmarkCitiesTableView.reloadData()
                self.cityListForSearchTableView.reloadData()
            }
        }
    }
    
    lazy var searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 30))

    
/*
 // bookmark된 cities 프로퍼티...
 var citiesBookmarked: [LocationGridData]? {
     didSet {
         if let cities = cities {
         }
     }
 }
 
 //filter된 cities 프로퍼티...
 var citiesFiltered: [LocationGridData]? {
     didSet {
         if let cities = cities {
             //
         }
     }
 }
 
 */
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBookmarkCitiesTableView()
        setupBookmarkCitiesTableViewConstraints()
        //        tableView.dragDelegate = self
        //        tableView.dropDelegate = self
        //        self.navigationItem.leftBarButtonItem?.title = .none
//        cities = CoreDataManager.shared.getLocationGridListFromCoreData()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers for tableView
    
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
        self.addSubview(bookmarkCitiesTableView)
        bookmarkCitiesTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bookmarkCitiesTableView.topAnchor.constraint(equalTo: self.topAnchor),
            bookmarkCitiesTableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            bookmarkCitiesTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            bookmarkCitiesTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
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
        self.addSubview(cityListForSearchTableView)
        cityListForSearchTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cityListForSearchTableView.topAnchor.constraint(equalTo: self.topAnchor),
            cityListForSearchTableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            cityListForSearchTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            cityListForSearchTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    // MARK: - Helpers for searchBar
    
    func setupSearchbar() {
        searchBar.placeholder = "도시를 검색하세요."
        searchBar.searchTextField.font = UIFont.systemFont(ofSize: 15)
        searchBar.delegate = self
    }
    
    
    // MARK: - Helpers for data
//
//    func updateLocationGridsByBookmark() {
//        cities = getLocationGrid().filter({ $0.bookmark == true })
//    }
//
//    func getLocationGrid() -> [LocationGridData] {
//        CoreDataManager.shared.getLocationGridListFromCoreData()
//    }
//
}
// MARK: - tableView dataSource extension
extension CitiesView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let cities = cities else { return 0}
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableView {
        case bookmarkCitiesTableView :
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID.forCitiesCell) as! CitiesViewCell
//            cell.cellDelegate = self
            return cell
        case cityListForSearchTableView :
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID.forCitiesListCell) as! CitiesListViewCell
//            cell.cellDelegate = self
            return cell
        default :
            break
    }
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellID.forCitiesCell) as! CitiesViewCell
        // 임의의 전체반환 셀이 필요한데 이거를 방지혀려면 차라리 if문이 나을까?
        return UITableViewCell()
    }
}

// MARK: - UITableViewDelegate

extension CitiesView: UITableViewDelegate {
    
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
    
}

// MARK: - 서치바 익스텐션
extension CitiesView: UISearchBarDelegate {
    // 서치바에서 검색을 시작할 때 호출
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        getWeatherDataDependingText(searchBar: searchBar)
//        self.bookmarkCitiesTableView.reloadData()
        self.cityListForSearchTableView.reloadData()
//        🥵 서치바 검색 시작할때 네비게이션 아이템 수정해줘야 하는데 어떡하지?
//        navigationItem.rightBarButtonItem = .none
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
//        if searchBar.text!.isEmpty {
//            cities = getLocationGrid()
//        } else {
//            guard let searchBarText = searchBar.text else { return }
//            cities = getLocationGrid().filter({ $0.city!.contains(searchBarText) || $0.district!.contains(searchBarText) })
//        }
    }
}
