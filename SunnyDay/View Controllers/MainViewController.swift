//
//  ViewController.swift
//  SunnyDay
//
//  Created by Станислав Белоусов on 15/05/2020.
//  Copyright © 2020 Станислав Белоусов. All rights reserved.
//

import UIKit

class mainViewController: UIViewController {
    
    let cityList = cityTableView()
    var networkManager = NetworkManager()
    
    private let search = UISearchController(searchResultsController: nil)
    private var searchBarIsEmpty: Bool {
        guard let text = search.searchBar.text else { return false }
        return text.isEmpty
    }
    
    @IBOutlet weak var mainTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        setupNavigationBarStyle()
        setupSearchStyle()
        
        networkManager.delegate = self
        networkManager.fetchCurrentWeather(forCity: "Sochi")
        mainTableView.reloadData()
    }
    
    @IBAction func locationButton(_ sender: UIButton) {
    }
    
    func setupNavigationBarStyle() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Sunny Day"
        navigationController?.navigationBar.barTintColor = .black
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.largeTitleTextAttributes = attributes
    }
    func setupSearchStyle() { // Setup the Search Controller
        search.searchResultsUpdater = self as? UISearchResultsUpdating
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search"
        search.searchBar.tintColor = UIColor.white
        search.searchBar.barTintColor = UIColor.white
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        search.obscuresBackgroundDuringPresentation = false // ?
        navigationItem.searchController = search
        definesPresentationContext = false // ?
    }
}
extension mainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cityList.cityList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mainTableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath) as! mainTableViewCell
        let object = cityList.cityList[indexPath.row]
        
        cell.setCell(object: object)
        cell.backgroundColor = .black
        cell.cityName.textColor = .white
        cell.temperature.textColor = .white
        
        return cell
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            cityList.testCityList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = cityList.testCityList.remove(at: sourceIndexPath.row)
        cityList.testCityList.insert(movedObject, at: destinationIndexPath.row)
        tableView.reloadData()
    }
}

extension mainViewController: NetworkManagerDelegate {
    func updateInteface(_: NetworkManager, with currentWeather: CurrentWeather) {
        cityList.cityList.append(currentWeather)
        print("!!!!!!!!!!!!!!")
        print(cityList.cityList)
    }
}
