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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getCharacter()
        
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
//        hero = characterArray index:indexPath
        if let nomeLabel = self.view.viewWithTag(100) as? UILabel {
//            nomeLabel.text = hero.name
        }
        return cell
    }
    
    
    func createAPIKey(timestamp timestamp:String ,privateKey privateKey:String,publicKey publicKey:String) -> (String){
        let initialStringHash = timestamp + privateKey + publicKey
        let finalHash =  initialStringHash.md5
        print(finalHash)
        return finalHash
    }
    
    func getCharacter(){
        let APIhash = self.createAPIKey(timestamp:"1",privateKey:MARVEL_PRIVATE_KEY,publicKey:MARVEL_PUBLIC_KEY)
        let charactersEndpoint = "characters?"
        let ts = "ts=1"
        let publicKey = "&apikey="+MARVEL_PUBLIC_KEY
        let hash = "&hash="+APIhash
        let limit = "&limit="+String(limitNumber)
        let offset = "&offset="+String(offsetNumber)
        
        AF.request(BASE_URL+charactersEndpoint+ts+publicKey+hash+limit+offset).response { response in
            self.offsetNumber = self.offsetNumber + self.limitNumber
            debugPrint(response.data)
//            let responseDictionary:Dictionary   = response
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

