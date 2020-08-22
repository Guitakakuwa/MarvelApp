//
//  ListCharactersTableViewController.swift
//  MarvelApp
//
//  Created by Guilherme Takakuwa on 15/08/20.
//  Copyright © 2020 Guilherme Takakuwa. All rights reserved.
//

import UIKit
import CommonCrypto
import Alamofire

class ListCharactersTableViewController: UITableViewController {
    let MARVEL_PUBLIC_KEY: String = "26a2b99fb1cde83f61e79d53c65803ba"
    let MARVEL_PRIVATE_KEY: String = "c4cc055e3f7668521cf813b4489d2ea791a17b8a"
    let BASE_URL: String = "http://gateway.marvel.com/v1/public/"
    var offsetNumber = 0
    var limitNumber = 20
    var heroArray:[Hero] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getCharacter { (info) in
            self.heroArray = info?.data.results as! [Hero]
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "characterInformationCell", for: indexPath)
        if(heroArray.count != 0){
            if let nameLabel = self.view.viewWithTag(100) as? UILabel {
                nameLabel.text = self.heroArray[indexPath.item].name
            }
            if let lastModifiedLabel = self.view.viewWithTag(101) as? UILabel {
                let lastModified = self.heroArray[indexPath.item].modified
                
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                let date = dateFormatter.date(from:lastModified)!
                dateFormatter.dateFormat = "MMM dd,yyyy"
                
                lastModifiedLabel.text = dateFormatter.string(from: date)
                print(date)
            }
            if let descriptionLabel = self.view.viewWithTag(102) as? UILabel {
                let description = self.heroArray[indexPath.item].description
                
                if( description != ""){
                descriptionLabel.text = description
                }else{
                    descriptionLabel.text = "Sem descrição"
                }
            }
        }
        return cell
    }
    
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.data(using: .utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
                return json
            } catch {
                print("Something went wrong")
            }
        }
        return nil
    }
    
    func createAPIKey(timestamp:String ,privateKey:String,publicKey:String) -> (String){
        let initialStringHash = timestamp + privateKey + publicKey
        let finalHash =  initialStringHash.md5
        print(finalHash)
        return finalHash
    }
    
    func getCharacter(onComplete: @escaping (MarvelInfo?) -> Void) {
        let APIhash = self.createAPIKey(timestamp: "1",privateKey: MARVEL_PRIVATE_KEY,publicKey: MARVEL_PUBLIC_KEY)
        let charactersEndpoint = "characters?"
        let ts = "ts=1"
        let publicKey = "&apikey="+MARVEL_PUBLIC_KEY
        let hash = "&hash="+APIhash
        let limit = "&limit="+String(limitNumber)
        let offset = "&offset="+String(offsetNumber)
        let marvelAPI = BASE_URL+charactersEndpoint+ts+publicKey+hash+limit+offset
        
        AF.request(marvelAPI).responseJSON { (response) in
            guard let data = response.data,
                let marvelInfo = try? JSONDecoder().decode(MarvelInfo.self, from: data),
                marvelInfo.code == 200 else {
                    onComplete(nil)
                    return
            }
            onComplete(marvelInfo)
            
        }
    }
    
    
}

extension String {
    var md5: String {
        let data = Data(self.utf8)
        let hash = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) -> [UInt8] in
            var hash = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
            CC_MD5(bytes.baseAddress, CC_LONG(data.count), &hash)
            return hash
        }
        return hash.map { String(format: "%02x", $0) }.joined()
    }
}

