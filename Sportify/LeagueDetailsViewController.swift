//
//  LeagueDetailsViewController.swift
//  Sportify
//
//  Created by Hadir on 25/04/2024.
//

import UIKit
import SDWebImage

class LeagueDetailsViewController: UIViewController{
    
    var presenter: LeagueDetailsPresenter!
    @IBOutlet var detailsCollectionView: UICollectionView!
    
    @IBOutlet var favButton: UIBarButtonItem!
    
    var sectionTitles = ["Upcoming Events", "Latest Results", "Teams"]
    var upcomingEvents = [Event]()
    var latestEvents = [Event]()
    var teams = [Team]()
    var league: League!
    var isFavorite = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = LeagueDetailsPresenterImpl(view: self)
        setupCollectionView()
        getData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupFavButton()
        view.backgroundColor = .systemGray

    }
    
    
    @IBAction func toggleFavPressed(_ sender: UIBarButtonItem) {
        if isFavorite {
            presenter.deleteFromFav(league: league)
        }else{
            presenter.addToFav(league: league)
        }
        isFavorite.toggle()
        setupFavButton()
        
    }
    
    private func setupCollectionView(){
        detailsCollectionView.delegate = self
        detailsCollectionView.dataSource = self
        var nib = UINib(nibName: "LeagueDetailsCollectionViewCell", bundle: nil)
        detailsCollectionView.register(nib, forCellWithReuseIdentifier: "detailsCell")
        nib = UINib(nibName: "TeamsCollectionViewCell", bundle: nil)
        detailsCollectionView.register(nib, forCellWithReuseIdentifier: "teamCell")
        detailsCollectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeader")

        configureCompositionalLayout()
    }
    
    private func configureCompositionalLayout(){
        let layout = UICollectionViewCompositionalLayout {sectionIndex,enviroment in
            switch sectionIndex {
            case 0 :
                return AppLayouts.getUpcomingEventsSection()
            case 1 :
                return AppLayouts.getRecentResultsSection()
            default :
                return AppLayouts.getTeamsSection()
            }
        }
        detailsCollectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    private func setupFavButton(){
        isFavorite = presenter.isFav(league: league)
        if isFavorite{
            favButton.image = UIImage(systemName: "heart.fill")
        }else{
            favButton.image = UIImage(systemName: "heart")
        }
    }
    
    
}


extension LeagueDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0 :
            return upcomingEvents.count
        case 1 :
            return latestEvents.count
        default:
            return teams.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0 :
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "detailsCell", for: indexPath) as? LeagueDetailsCollectionViewCell else {fatalError("Unable deque cell...")}
            let cellData = upcomingEvents[indexPath.row]
            if AppCommon.shared.sport == .tennis{
                
            }else{
                cell.firstTeamNameLabel.text = cellData.eventHomeTeam ?? "Team name"
                cell.firstTeamLogo.sd_setImage(with: URL(string: cellData.eventHomeTeamLogo ?? ""), placeholderImage: UIImage(named: "AppIcon"))
                cell.secondTeamNameLabel.text = cellData.eventAwayTeam ?? "Team name"
                cell.secondTeamLogo.sd_setImage(with: URL(string: cellData.eventAwayTeamLogo ?? ""), placeholderImage: UIImage(named: "AppIcon"))

            }
            cell.timeLabel.text = cellData.eventTime ?? ""
            cell.dateLabel.text = ""
            if let date = cellData.eventDate{
                cell.scoreLabel.text = reformateDate(date)
            }else{
                cell.scoreLabel.text = ""
            }
            
            return cell
        case 1 :
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "detailsCell", for: indexPath) as? LeagueDetailsCollectionViewCell else {fatalError("Unable deque cell...")}
            let cellData = latestEvents[indexPath.row]
            cell.firstTeamNameLabel.text = cellData.eventHomeTeam ?? "Team name"
            cell.firstTeamLogo.sd_setImage(with: URL(string: cellData.eventHomeTeamLogo ?? ""), placeholderImage: UIImage(named: "AppIcon"))
            cell.secondTeamNameLabel.text = cellData.eventAwayTeam ?? "Team name"
            cell.secondTeamLogo.sd_setImage(with: URL(string: cellData.eventAwayTeamLogo ?? ""), placeholderImage: UIImage(named: "AppIcon"))
            cell.timeLabel.text = cellData.eventTime ?? ""
            if let date = cellData.eventDate{
                cell.dateLabel.text = reformateDate(date)
            }else{
                cell.dateLabel.text = ""
            }
            cell.scoreLabel.text = cellData.eventFinalResult ?? ""
            
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "teamCell", for: indexPath) as? TeamsCollectionViewCell else {fatalError("Unable deque cell...")}
            let team = teams[indexPath.row]
            cell.nameLabel.text = team.teamName
            cell.teamLogo.sd_setImage(with: URL(string: team.teamLogo ?? ""), placeholderImage: UIImage(named: "AppIcon"))
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if AppCommon.shared.sport == .football && indexPath.section == 2 {
            let destinationViewController = self.storyboard?.instantiateViewController(withIdentifier: "TeamDetailsTableViewController") as! TeamDetailsTableViewController
            destinationViewController.teamId = teams[indexPath.row].teamKey ?? 0
            self.navigationController?.pushViewController(destinationViewController, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as? SectionHeader else {
            fatalError("Failed to dequeue SectionHeaderView")
        }
        
        headerView.sectionHeaderlabel.text = sectionTitles[indexPath.section]
        
        return headerView
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 70)
    }
   
    
}



extension LeagueDetailsViewController: LeagueDetailsView{
    func showUpcomingEvents(events: [Event]?) {
        upcomingEvents = events?.reversed() ?? []
        detailsCollectionView.reloadData()
    }
    
    func showLatestEvents(events: [Event]?) {
        latestEvents = events ?? []
        detailsCollectionView.reloadData()
    }
    
    func showTeams(teams: [Team]?) {
        self.teams = teams ?? []
        detailsCollectionView.reloadData()
    }
    
    private func getData(){
        guard let sport = AppCommon.shared.sport else{
            print("Sport type is not provided")
            return
        }
        presenter.getUpcomingEvents(of: sport, for: String(league.leagueKey ?? 0))
        presenter.getLatestResults(of: sport, for: String(league.leagueKey ?? 0))
        presenter.getTeams(of: sport, for: String(league.leagueKey ?? 0))
    }
    
    private func reformateDate(_ dateString: String)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: dateString) else {
            print("Error: Unable to parse the date.")
            return ""
        }
        dateFormatter.dateFormat = "MM/dd"
        let reformattedDate = dateFormatter.string(from: date)
        return reformattedDate
    }
  

}

