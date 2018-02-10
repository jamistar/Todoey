//
//  RealmMigration.swift
//  Todoey
//
//  Created by Jami on 2018/2/10.
//  Copyright © 2018年 Jami. All rights reserved.
//

import Foundation
import RealmSwift

class RealmMigration {
    
    
    func didApplicationLunch () {
        self.migrationVersion()
    }
    
    func migrationVersion() {
        
        
        let config = Realm.Configuration(
            
            schemaVersion : 2 ,
            
            migrationBlock : { migration , oldSchemaVersion in
                
                //                if (oldSchemaVersion < 1) {
                //                    如果你有必須針對舊板本遷移到新板本的資料改變，就寫在這裡。
                //                    詳細的做法可以參考官方的範例
                //                }
                
        }
            
        )
        
        Realm.Configuration.defaultConfiguration = config
        
    }
    
}

let realm = try! Realm() //不要理會這一行是不是會報黃色警告給你，寫在這完完全全就是讓realm這個變數變成全域使用。你就不用每一次都下這一行。
