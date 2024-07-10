//
//  PreferencesViewController.swift
//  InstantFood
//
//  Created by Macbook Pro on 04/07/2024.

import UIKit
import FlagKit

class PreferencesViewController: UIViewController {
    
    @IBOutlet var countryTableView: UITableView!
    @IBOutlet var countrySearch: UISearchBar!
    @IBOutlet var countryStackViews: [UIStackView]!
    
    var countries : [Country] = []
    var filteredCountries : [Country] = []
    var selectedCountries : [Country] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countries = loadCountries()
        filteredCountries = countries
        
        navigationItem.hidesBackButton = true
        
        countryTableView.register(UINib(nibName: K.countryCellNibName, bundle: nil), forCellReuseIdentifier: K.CountryCellIdentifier)
        
    }
    
    func loadCountries() -> [Country] {
        guard let path = Bundle.main.path(forResource: "countries", ofType: "json"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            print("Unable to load JSON file")
            return []
        }
        
        let decoder = JSONDecoder()
        if let countries = try? decoder.decode([Country].self, from: data) {
            return countries
        } else {
            print("Unable to decode JSON file")
            return []
        }
    }
    
    @IBAction func searchPressed(_ sender: Any) {
        let searchString = countrySearch.text ?? ""
        filterCountries(searchString)
        countryTableView.reloadData()
    }
    
    @IBAction func savePressed(_ sender: Any) {
    }
    
    @IBAction func backpressed(_ sender: UIButton) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: K.signupVCIdentifier) as? SignupViewController else { return }
         navigationController?.pushViewController(vc, animated: true)
    }
    
    func showCountryLabel (_ country : Country) {
        for stackView in countryStackViews {
            if let emptyView = stackView.arrangedSubviews.first(where: {$0.subviews.isEmpty}) {
                
                let label = LabelWithDelButton()
                label.delegate = self
                label.configure(with: country.name)
                label.layer.cornerRadius = 12
                label.layer.borderColor = K.primaryColor?.cgColor
                label.layer.borderWidth = 3
                emptyView.addSubview(label)

                label.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    label.topAnchor.constraint(equalTo: emptyView.topAnchor),
                    label.bottomAnchor.constraint(equalTo: emptyView.bottomAnchor),
                    label.leadingAnchor.constraint(equalTo: emptyView.leadingAnchor),
                    label.trailingAnchor.constraint(equalTo: emptyView.trailingAnchor)
                ])
                return
            }
        }
    }
}



// MARK: - LabelWithDelButtonDelegate
extension PreferencesViewController : LabelWithDelButtonDelegate {
    func didDeleteLabel(with text: String) {
        if let index = selectedCountries.firstIndex(where: { $0.name == text }) {
            selectedCountries.remove(at: index)
        }
        removeAllLabels()
        showSelectedCountries()
    }
    
    func removeAllLabels() {
        for stackView in countryStackViews {
            for view in stackView.arrangedSubviews {
                view.subviews.forEach { $0.removeFromSuperview() }
            }
        }
    }
    
    func showSelectedCountries() {
        for country in selectedCountries {
            showCountryLabel(country)
        }
    }
}



// MARK: - TableViewDelegate
extension PreferencesViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCountry = filteredCountries[indexPath.row]
        
        if selectedCountries.firstIndex(of: selectedCountry) == nil {
                selectedCountries.append(selectedCountry)
                showCountryLabel(selectedCountry)
        } else { return }

        tableView.deselectRow(at: indexPath, animated: true)
    }
}



// MARK: - TableViewDataSource
extension PreferencesViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCountries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.CountryCellIdentifier, for: indexPath) as! CountryTableViewCell
        
        let row = filteredCountries[indexPath.row]
        cell.CountryName.text = row.name
        if let flagImage = Flag(countryCode: row.code)?.image(style: .circle) {
            cell.flagImage.image = flagImage
        }
        return cell
    }
}



// MARK: - SearchBarDelegate
extension PreferencesViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchText = countrySearch.text ?? ""
        
        if searchText.isEmpty {
            filteredCountries = countries
        } else {
            let searchString = searchText.lowercased()
            filterCountries(searchString)
        }
        countryTableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        countryTableView.isHidden = false
    }
    
    //filtering countries to show in tableview
    func filterCountries (_ text : String) {
        filteredCountries = countries.filter { Country in
            let name = Country.name.lowercased()
            return name.hasPrefix(text) ||
            (name.rangeOfCharacter(from: .letters) != nil && name.contains(text))
        }
    }
}
