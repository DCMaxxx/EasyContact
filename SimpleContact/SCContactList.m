//
//  BCContactList.m
//  BetterContacts
//
//  Created by Maxime de Chalendar on 11/03/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import "SCContactList.h"

#import "SCSettingsHandler.h"


@interface SCContactList ()

@property (nonatomic) ABAddressBookRef addressBook;
@property (strong, nonatomic) NSMutableArray * sectionnedContacts;
@property (strong, nonatomic) NSMutableDictionary * sectionsIndexes;
@property (strong, nonatomic) NSMutableDictionary * favorites;

@end

static NSString * const DicKeyInitial = @"initial";
static NSString * const DicKeyContact = @"contacts";


/*----------------------------------------------------------------------------*/
#pragma mark - Implementation
/*----------------------------------------------------------------------------*/
@implementation SCContactList

/*----------------------------------------------------------------------------*/
#pragma mark - Init
/*----------------------------------------------------------------------------*/
- (id)init {
    if (self = [super init]) {
        _addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        if (!_addressBook)
            return nil;
        
        _sectionnedContacts = [self getArrayOfSections];
        
        BOOL orderByFirstName = [[SCSettingsHandler sharedInstance] getOption:eSOFirstName ofCategory:eSCListOrder];
        CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(_addressBook);
        CFMutableArrayRef peopleMutable = CFArrayCreateMutableCopy(kCFAllocatorDefault, CFArrayGetCount(people), people);
        CFArraySortValues(peopleMutable, CFRangeMake(0, CFArrayGetCount(peopleMutable)), (CFComparatorFunction) ABPersonComparePeopleByName,
                          (void*)(orderByFirstName ? kABPersonFirstNameProperty : kABPersonLastNameProperty));
        NSArray * allPersons = (__bridge_transfer NSArray *)peopleMutable;
        
        for (NSUInteger i = 0; i < [allPersons count]; ++i) {
            ABRecordRef currentPerson = (__bridge ABRecordRef)[allPersons objectAtIndex:i];
            SCContact * contact = [[SCContact alloc] initWithAddressBookContact:currentPerson];
            [self addContact:contact InSection:_sectionnedContacts];
        }
    }
    return self;
}


/*----------------------------------------------------------------------------*/
#pragma mark - Advanced getters
/*----------------------------------------------------------------------------*/
- (NSUInteger)numberOfInitials {
    return [_sectionnedContacts count];
}

- (NSString *)initialAtIndex:(NSUInteger)index {
    return [(NSDictionary *)[_sectionnedContacts objectAtIndex:index] objectForKey:DicKeyInitial];
}

- (NSArray *)contactsForInitialAtIndex:(NSUInteger)index {
    return [(NSDictionary *)[_sectionnedContacts objectAtIndex:index] objectForKey:DicKeyContact];
}

- (NSUInteger)numberOfContactsForInitialAtIndex:(NSUInteger)index {
    NSArray * contacts = [self contactsForInitialAtIndex:index];
    return [contacts count];
}

- (SCContact *)getContactFromUID:(NSUInteger)UID {
    for (NSDictionary * section in _sectionnedContacts) {
        for (SCContact * contact in [section objectForKey:DicKeyContact]) {
            if ([contact UID] == UID)
                return contact;
        }
    }
    return nil;
}


/*----------------------------------------------------------------------------*/
#pragma mark - Sorting and searching
/*----------------------------------------------------------------------------*/
- (void)sortArrayAccordingToSettings {
    NSMutableArray * newSections = [self getArrayOfSections];
    for (NSMutableDictionary * section in _sectionnedContacts)
        for (SCContact * contact in [section objectForKey:DicKeyContact])
            [self addContact:contact InSection:newSections];
    _sectionnedContacts = newSections;
}

- (NSArray *)filterWithText:(NSString *)text {
    NSMutableArray * result = [[NSMutableArray alloc] init];
    for (NSMutableDictionary * section in _sectionnedContacts) {
        for (SCContact * contact in [section objectForKey:DicKeyContact]) {
            NSRange firstName = [[contact firstName] rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange lastName = [[contact lastName] rangeOfString:text options:NSCaseInsensitiveSearch];
            if (firstName.location != NSNotFound || lastName.location != NSNotFound)
                [result addObject:contact];
        }
    }
    return result;
}


/*----------------------------------------------------------------------------*/
#pragma mark - Misc hidden methods
/*----------------------------------------------------------------------------*/
- (NSMutableArray *)getArrayOfSections {
    NSString * sections = [self sections];
    NSMutableArray * newSections = [[NSMutableArray alloc] initWithCapacity:[sections length]];
    for (NSInteger i = 0; i < [sections length]; ++i) {
        NSString * character = [sections substringWithRange:NSMakeRange(i, 1)];
        NSMutableDictionary * section = [[NSMutableDictionary alloc] init];
        [section setObject:character forKey:DicKeyInitial];
        [section setObject:[[NSMutableArray alloc] init] forKey:DicKeyContact];
        [newSections addObject:section];
    }
    return newSections;
}

- (void)addContact:(SCContact *)contact InSection:(NSMutableArray *)sections {
    NSRange idx;
    if ([[contact importantName] length]) {
        NSString * sectionTitle = [[contact importantName] substringToIndex:1];
        idx = [[self sections] rangeOfString:sectionTitle options:NSCaseInsensitiveSearch];
    } else
        idx.location = NSNotFound;
    if (idx.location == NSNotFound)
        idx.location = [[self sections] length] - 1;
    NSMutableDictionary * dic = [sections objectAtIndex:idx.location];
    NSMutableArray * contacts = [dic objectForKey:DicKeyContact];
    [contacts addObject:contact];
}

- (NSString *)sections {
    return @"ABCDEFGHIJKLMNOPQRSTUVWXYZ#";
}

@end