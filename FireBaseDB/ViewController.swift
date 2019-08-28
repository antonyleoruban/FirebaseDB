//
//  ViewController.swift
//  FireBaseDB
//
//  Created by Antony Leo Ruban Yesudass on 28/08/19.
//  Copyright © 2019 Antony Leo Ruban Yesudass. All rights reserved.
//

import UIKit
import Firebase


class ViewController: UIViewController {
    
    var refArtists: DatabaseReference!

    @IBOutlet weak var tableViewArtists: UITableView!
    
    //list to store all the artist
    var artistList = [ArtistModel]()

    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldGenre: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        

        refArtists = Database.database().reference().child("artists_new")
        // Do any additional setup after loading the view.
        fetchArtistsList()
        self.tableViewArtists.tableFooterView = UIView()
        
        //let appIP1 = ITMRemoteConfig.shared.getBaseUrl1()
        print("Base url is ",RemoteConfigClass.shared.getBaseUrl1())
        print("Json is ",RemoteConfigClass.shared.getJSon())


        
    }
    
    func fetchArtistsList() {
        
        //observing the data changes
        refArtists.observe(DataEventType.value, with: { (snapshot) in
            
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                
                //clearing the list
                self.artistList.removeAll()
                
                //iterating through all the values
                for artists in snapshot.children.allObjects as! [DataSnapshot] {
                    //getting values
                    let artistObject = artists.value as? [String: AnyObject]
                    let artistName  = artistObject?["artistName"]
                    let artistId  = artistObject?["id"]
                    let artistGenre = artistObject?["artistGenre"]
                    
                    //creating artist object with model and fetched values
                    let artist = ArtistModel(id: artistId as! String?, name: artistName as! String?, genre: artistGenre as! String?)
                    
                    //appending it to list
                    self.artistList.append(artist)
                }
                
                //reloading the tableview
                 self.tableViewArtists.reloadData()
            }else
            {
                self.artistList.removeAll()
                self.tableViewArtists.reloadData()

            }
        })
        
    }

    @IBAction func AddArtistAction(_ sender: Any) {
        
        if(textFieldName.text != "" && textFieldGenre.text != "")
        {
            self.view .endEditing(true)
                    let key = refArtists.childByAutoId().key
                    let artist = ["id":key,
                                  "artistName": textFieldName.text,
                                  "artistGenre": textFieldGenre.text]
            
                    refArtists.child(key!).setValue(artist)
            fetchArtistsList()
        }
    }
}


extension ViewController:UITableViewDataSource, UITableViewDelegate{
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return artistList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        //creating a cell using the custom class
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistCell", for: indexPath) as! ArtistCell
        
        //the artist object
        let artist: ArtistModel
        
        //getting the artist of selected position
        artist = artistList[indexPath.row]
        
        //adding values to labels
        cell.labelName.text = artist.name
        cell.labelGenre.text = artist.genre
        
        //returning cell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //getting the selected artist
        let artist  = artistList[indexPath.row]
        
        //building an alert
        let alertController = UIAlertController(title: artist.name, message: "Give new values to update ", preferredStyle: .alert)
        

        
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "Enter", style: .default) { (_) in
            
            //getting artist id
            let id = artist.id
            
            //getting new values
            let name = alertController.textFields?[0].text
            let genre = alertController.textFields?[1].text
            
            //calling the update method to update artist
            self.updateArtist(id: id!, name: name!, genre: genre!)//
        }
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        //adding two textfields to alert
        alertController.addTextField { (textField) in
            textField.text = artist.name
            textField.font = UIFont(name: "Courier", size: 20)

        }
        alertController.addTextField { (textField) in
            textField.text = artist.genre
            textField.font = UIFont(name: "Courier", size: 20)

        }
        
        //adding action
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)

        //presenting dialog
        present(alertController, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let artist  = artistList[indexPath.row]
            //getting artist id
            let id = artist.id
            refArtists.child(id!).setValue(nil)
            fetchArtistsList()
            // handle delete (by removing the data from your array and updating the tableview)
        }
    }
    
    func updateArtist(id:String, name:String, genre:String){
        //creating artist with the new given values
        let artist = ["id":id,
                      "artistName": name,
                      "artistGenre": genre
        ]
        
        //updating the artist using the key of the artist
        refArtists.child(id).setValue(artist)
        fetchArtistsList()

        
    }

}
