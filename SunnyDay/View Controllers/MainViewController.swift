//
//  ViewController.swift
//  SunnyDay
//
//  Created by Станислав Белоусов on 15/05/2020.
//  Copyright © 2020 Станислав Белоусов. All rights reserved.
//

import UIKit
import CoreLocation

class mainViewController: UIViewController {
    
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var languageLabel: UIImageView!
    
    var networkManager = NetworkManager()
    var currentWeatherData:[CurrentWeather] = []
    var language = "ru"
    
    
    private let search = UISearchController(searchResultsController: nil)
    private var searchBarIsEmpty: Bool {
        guard let text = search.searchBar.text else { return false }
        return text.isEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.allowsSelection = false
        
        setupNavigationBarStyle()
        setupSearchStyle()
        
        // Language menu
        languageLabel.isUserInteractionEnabled = true
        let interaction = UIContextMenuInteraction(delegate: self)
        languageLabel.addInteraction(interaction)
        
        networkManager.delegate = self
        networkManager.fetchCurrentWeather(forRequestType: .cityName(city:"Sochi"), language: language)
    }
    
    @IBAction func locationButton(_ sender: UIButton) {
    }
    
    
    @IBAction func unwindSegue (_ segue :UIStoryboardSegue) {
        
        print("unwindsegue")
        guard segue.source is cityDetailVC else { return }
        mainTableView.reloadData()
        print(networkManager.currentWeatherData)
    }
    
    func setupLanguageLabel() {
        languageLabel.translatesAutoresizingMaskIntoConstraints = false
        languageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        languageLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 100).isActive = true
        languageLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -100).isActive = true
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
        navigationItem.searchController = search
        definesPresentationContext = false
    }
}
extension mainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return networkManager.currentWeatherData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mainTableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath) as! mainTableViewCell
        
        let object = networkManager.currentWeatherData[indexPath.row]
        
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
            networkManager.currentWeatherData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension mainViewController: NetworkManagerDelegate {
    func updateInteface(_: NetworkManager, with currentWeather: CurrentWeather) {
        networkManager.currentWeatherData.append(currentWeather)
        print(networkManager.currentWeatherData)
        DispatchQueue.main.async {
            self.mainTableView.reloadData()
        }
    }
}

extension mainViewController: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            
            let russian = UIAction(title: "Русский") { _ in self.language = "ru"}
            let english = UIAction(title: "English") { _ in self.language = "en"}
            let french = UIAction(title: "Français") { _ in self.language = "fr"}
            let tagActions = UIMenu(title: "Change Language", children: [russian, english, french])
            return tagActions
        }
        return configuration
    }
    
    
}
