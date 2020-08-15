//
//  ListCharactersTableViewController.swift
//  MarvelApp
//
//  Created by Guilherme Takakuwa on 15/08/20.
//  Copyright © 2020 Guilherme Takakuwa. All rights reserved.
//

import UIKit
import CommonCrypto

class ListCharactersTableViewController: UITableViewController {
     let MARVEL_PUBLIC_KEY: String = "26a2b99fb1cde83f61e79d53c65803ba"
     let MARVEL_PRIVATE_KEY: String = "c4cc055e3f7668521cf813b4489d2ea791a17b8a"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let timestamp = "1"
        self.createAPIKey(timestamp,MARVEL_PRIVATE_KEY,MARVEL_PUBLIC_KEY)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }


    func createAPIKey(_ timestamp:String ,_ privateKey:String,_ publicKey:String) -> (String){
        let initialStringHash = timestamp + privateKey + publicKey
        let finalHash =  initialStringHash.md5
        print(finalHash)
        return finalHash
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
    
