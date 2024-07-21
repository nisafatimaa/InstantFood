//
//  DetailsViewController.swift
//  InstantFood
//
//  Created by Macbook Pro on 30/04/2024.
//

import UIKit
import WebKit

class DetailsViewController: UIViewController {

    @IBOutlet var recipeImage : UIImageView!
    @IBOutlet var scrollView : UIView!
    @IBOutlet var detailsTable : UITableView!
    @IBOutlet var cookingLabel : UILabel!
    @IBOutlet var titleLabel : UILabel!
    
    var titleOfRecipe : String?
    var imageURL : String? {
        didSet {
            if let urlString = imageURL , let url = URL(string: urlString) {
                DispatchQueue.global().async {
                    let imageData = try? Data(contentsOf: url)
                    DispatchQueue.main.async {
                        if let safeData = imageData {
                            self.recipeImage.image = UIImage(data: safeData)
                        }
                    }
                }
            }
        }
    }
    var ingredientsArray : [String] = []
    var cookingTime : Int?
    var instructionsURL : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = titleOfRecipe
        cookingLabel.text = "Cooking Time: \(String(describing: cookingTime)) min"

        Border.addBorder(scrollView)
        Border.addBorder(detailsTable)
        
    }
    
    @IBAction func heartClicked(_ sender: UIButton) {
        
    }
    
    @IBAction func instructionsClicked(_ sender: UIButton) {
        guard let url = URL(string: instructionsURL ?? "") else { return }
        
        let webView = WKWebView(frame: self.view.frame)
        self.view.addSubview(webView)
        webView.navigationDelegate = self
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
}



// MARK: - table view datasource
extension DetailsViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return ingredientsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.detailsVCCIdentifier, for: indexPath)
        
        cell.textLabel?.text = ingredientsArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        detailsTable.deselectRow(at: indexPath, animated: true)
    }
}



// MARK: - WK Navigation Delegate
extension DetailsViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let darkModeCSS = """
        body {
            background-color: #121212 !important;
            color: #ffffff !important;
        }
        a {
            color: #bb86fc !important;
        }
        """
        
        let darkModeScript = """
        var style = document.createElement('style');
        style.innerHTML = `\(darkModeCSS)`;
        document.head.appendChild(style);
        """
        
        webView.evaluateJavaScript(darkModeScript, completionHandler: nil)
    }
}
