//
//  LocalDataSourceImpl.swift
//  Sportify
//
//  Created by Ramez Hamdi Saeed on 25/04/2024.
//

import Foundation
import UIKit

class LocalDataSourceImpl : LocalDataSource{
    
    private let shared = LocalDataSourceImpl()
    private var leagues = [LeaguesDB]()
    
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    func getLeaguesFromFav() -> [League]? {
        do{
            leagues = try context!.fetch(LeaguesDB.fetchRequest())
            return prepareData()

        }catch{
            print("error happened while retireving the data over the dataBase")
            return [League]()
        }
    }
    
    func insertLeagueToFav(league: League) {
        let newLeague = LeaguesDB(context: self.context!)
        newLeague.leagueKey = Int32(league.leagueKey!)
        newLeague.leagueName = league.leagueName
        newLeague.countryKey = Int32(league.countryKey!)
        newLeague.countryName = league.countryName
        newLeague.leagueLogo = league.leagueLogo
        newLeague.countryLogo = league.countryLogo
        
        do{
            try context?.save()
            //don't forget to call the getLeaguesFromFav to update the data in the repository!!!!!!!
        }
        catch{
            print("error happened while retireving the data over the dataBase")

        }
    }
    
    func deleteLeagueToFav(league: League) {
        
    }
    
    func prepareData()->[League]{
        
        var preparedLeagues = [League]()
        
        for item in  0..<self.leagues.count{
            
            let leagueItem = League(leagueKey: Int(self.leagues[item].leagueKey), leagueName: self.leagues[item].leagueName, countryKey: Int(self.leagues[item].countryKey), countryName: self.leagues[item].countryName, leagueLogo: self.leagues[item].leagueName, countryLogo: self.leagues[item].countryLogo)
            
            preparedLeagues.append(leagueItem)
        }
        return preparedLeagues
    }
    
    
}
