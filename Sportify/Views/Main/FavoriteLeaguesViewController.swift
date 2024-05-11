//
//  FavoriteLeaguesViewController.swift
//  Sportify
//
//  Created by Ramez Hamdi Saeed on 24/04/2024.
//

import UIKit

class FavoriteLeaguesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FavoriteLeaguesView{

    

    @IBOutlet weak var favoriteTableView: UITableView!
    var placeholderLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlaceholderLabel()
        let nib = UINib(nibName: "LeagueTableViewCell", bundle: nil)
        self.favoriteTableView.register(nib, forCellReuseIdentifier: "favoriteSportLeague")
        FavoriteLeaguesPresenter.setupView(tableViewToBeRefreshed: self)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        view.backgroundColor = UIColor(named: "backgroundColor")
        FavoriteLeaguesPresenter.getLeaguesFromFav() 
        favoriteTableView.reloadData()
    }
    
    func updateData(leagues: [League]) {
//        print(leagues.count)
        FavoriteLeaguesPresenter.leaguesDB = leagues
    }
    
    // MARK: - Table view data source
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         if FavoriteLeaguesPresenter.leaguesDB.isEmpty {
             placeholderLabel.isHidden = false
             return 0
         }else{
             placeholderLabel.isHidden = true
             return FavoriteLeaguesPresenter.leaguesDB.count
         }
         
    }

    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteSportLeague", for: indexPath) as! LeagueTableViewCell
         let imageUrl = (FavoriteLeaguesPresenter.leaguesDB[indexPath.row].leagueLogo ?? FavoriteLeaguesPresenter.leaguesDB[indexPath.row].countryLogo) ?? "UnKnown"

        cell.leagueImage.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "img_launcher"))

        let title:String = (FavoriteLeaguesPresenter.leaguesDB[indexPath.item].leagueName ?? FavoriteLeaguesPresenter.leaguesDB[indexPath.item].countryName) ?? "UnKnown"

        cell.leagueName?.text = title
        
        
        return cell
    }
   
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //navigate to the first view controller in the Details Story Board
         guard AppCommon.shared.isNetworkReachable() else {
             AppCommon.shared.showSimpleAlert(title:"Network Error", message: "Oops! Something went wrong with the network. Please check your internet connection and try again.",view: self)
             return
         }
         let storyboard = UIStoryboard(name: "Details", bundle: nil)
         
         if let destinationViewController = storyboard.instantiateViewController(withIdentifier: "LeagueDetailsViewController") as? LeagueDetailsViewController {
             destinationViewController.league = FavoriteLeaguesPresenter.leaguesDB[indexPath.row]
             FavoriteLeaguesPresenter.updateSportCategory(index: indexPath.row)
             navigationController?.pushViewController(destinationViewController, animated: true)
         }
    }
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let index = indexPath.row
            let leagueToBeRemoved = FavoriteLeaguesPresenter.leaguesDB[index]
            FavoriteLeaguesPresenter.deleteLeagueFromFav(league: leagueToBeRemoved)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } 
    }

    private func setupPlaceholderLabel() {
        placeholderLabel = UILabel()
        placeholderLabel.text = "You haven't added any favorite leagues yet!"
        placeholderLabel.textAlignment = .center
        placeholderLabel.textColor = .gray
        placeholderLabel.isHidden = true
        
        view.addSubview(placeholderLabel)
        
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

}
