//
//  CitiesViewController.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2022/10/17.
//


import UIKit

final class CitiesViewController: UIViewController  {
    
    // MARK: -  Properties
    private let cityListForSearchTableView = UITableView()

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

    private func setupSearchbar() {
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 30))
        navigationItem.titleView = searchBar
        searchBar.placeholder = "도시를 검색하세요."
        searchBar.searchTextField.font = UIFont.systemFont(ofSize: 15)
        searchBar.delegate = self
    }
    
    private func setupNavigationItem() {
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func setupCityListForSearchTableView() {
        cityListForSearchTableView.delegate = self
        cityListForSearchTableView.dataSource = self
        cityListForSearchTableView.register(CitiesListViewCell.self, forCellReuseIdentifier: CellID.forCitiesListCell)
        cityListForSearchTableView.allowsSelection = true
        cityListForSearchTableView.separatorStyle = .none
        cityListForSearchTableView.isUserInteractionEnabled = true
        cityListForSearchTableView.allowsSelectionDuringEditing = true
        cityListForSearchTableView.dragInteractionEnabled = true
    }
    
    private func setupCityListForSearchTableViewConstraints() {
        view.addSubview(cityListForSearchTableView)
        cityListForSearchTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cityListForSearchTableView.topAnchor.constraint(equalTo: view.topAnchor),
            cityListForSearchTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cityListForSearchTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cityListForSearchTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
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
        let selectedLocationGridX = Int(selectedLocation.gridX)
        let selectedLocationGridY = Int(selectedLocation.gridY)
        let selectedLocationLatitude = selectedLocation.latitude
        let selectedLocationLongitude = selectedLocation.longitude

        weatherVC.weatherKitViewModel = .init(name: selectedLocationName, latitude: selectedLocationLatitude, longitude: selectedLocationLongitude, gridX: selectedLocationGridX, gridY: selectedLocationGridY)

        show(weatherVC, sender: nil)
        weatherVC.navigationItem.title = weatherVC.weatherKitViewModel.name
        weatherVC.view.backgroundColor = .white
        
    }
    
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
