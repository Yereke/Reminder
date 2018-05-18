//
//  FetchContacts.swift
//  RemindAPP
//
//  Created by MacBook on 28.03.2018.
//  Copyright © 2018 MacBook. All rights reserved.
//

import Foundation
import Contacts

class FetchContacts{
    
    static let share = FetchContacts()
    
    var contacStore = CNContactStore()
    var Contacts:[Contact] = Array()
    
    private init() {}
    
    func fetchContact() -> [Contact]{
        let key = [CNContactGivenNameKey,CNContactFamilyNameKey,CNContactPhoneNumbersKey] as [CNKeyDescriptor]
        let request = CNContactFetchRequest(keysToFetch: key)
        try! contacStore.enumerateContacts(with: request, usingBlock: { (contact, stoppingPoint) in
            
            let name = contact.givenName
            let familyName = contact.familyName
            if let number = contact.phoneNumbers.first?.value.stringValue{
                let contactToAppend = Contact.init(name, "ava", familyName, number)
                self.Contacts.append(contactToAppend)
            }
        })
        return Contacts
    }
}
