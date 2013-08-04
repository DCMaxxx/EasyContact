//
//  BCContactList.h
//  BetterContacts
//
//  Created by Maxime de Chalendar on 11/03/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCContact.h"


@interface SCContactList : NSObject

- (NSUInteger)numberOfInitials;
- (NSString *)initialAtIndex:(NSUInteger)index;
- (NSArray *)contactsForInitialAtIndex:(NSUInteger)index;
- (NSUInteger)numberOfContactsForInitialAtIndex:(NSUInteger)index;
- (SCContact *)getContactFromUID:(NSUInteger)UID;
- (void)sortArrayAccordingToSettings;
- (NSArray *)filterWithText:(NSString *)text;

@end
