//
//  HomeViewController.swift
//  Sportify
//
//  Created by Ramez Hamdi Saeed on 24/04/2024.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var sportsCollectionView: UICollectionView!
    let sports = [SportCategory(name: "Football", image: "footBall"),SportCategory(name: "BasketBall", image: "basketBall"),SportCategory(name: "Cricket", image: "cricket"),SportCategory(name: "Tennis", image: "tennis")]

    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "sportCollectionViewCell", bundle: nil)
        self.sportsCollectionView.register(nib, forCellWithReuseIdentifier: "sportCell")

        getLeagues(of: .football)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if OnBoardingManager.shared.isNewuser(){
            let welcomeVC = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
            welcomeVC.modalPresentationStyle = .fullScreen
            present(welcomeVC, animated: true)
        }
    }

}


extension HomeViewController : UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sports.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"sportCell", for: indexPath) as! sportCollectionViewCell
        cell.backgroundColor = .systemTeal
        let sportImage = self.sports[indexPath.item].image
        let sportName = self.sports[indexPath.item].name
       cell.image.image = UIImage(named: sportImage)
        cell.sportName.text = sportName
        cell.layer.cornerRadius = 20
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.sportsCollectionView.frame.width/2, height: self.sportsCollectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 40
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    //LeagueRepositoryImpl Usage
    func getLeagues(of sport: Sport){
        print("getting the leagues...")
        LeagueRepositoryImpl.shared.getLeaguesFromNetwork(of: sport){result in
            switch result{
            case .success(let leagues):
                //your logic goes here
                print(leagues)
            case .failure(let error):
                //error handling here
                print(error)
            }
        }
    }

    
}
