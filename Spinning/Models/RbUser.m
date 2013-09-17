//
//  RbUser.m
//  Spinning
//
//  Created by Robin on 7/28/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "RbUser.h"

@implementation RbUser
@synthesize username = _username;
@synthesize password = _password;
@synthesize realname = _realname;
@synthesize address = _address;
@synthesize email = _email;
@synthesize company = _company;
@synthesize position = _position;
@synthesize usercell = _usercell;
@synthesize userid = _userid;

+(RbUser *)sharedInstance {
    
    static RbUser *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init
{
    if (self = [super init]) {
        self.username = nil;
        self.password = nil;
        self.realname = nil;
        self.address = nil;
        self.email = nil;
        self.company = nil;
        self.position = nil;
        self.usercell = nil;
        self.userid = nil;
        [self update];
    }
    return self;
}

- (void) parseResultData:(NSDictionary*) dictionary{
    if (dictionary == nil) {
        return;
    }
    
    [super parseResultData:dictionary];
    self.userid = defaultEmptyString([dictionary objectForKey:kSpinningHttpRequestKeyUserid]);
    self.username = defaultEmptyString([dictionary objectForKey:kSpinningHttpRequestKeyUsername]);
    self.realname = defaultEmptyString([dictionary objectForKey:kSpinningHttpRequestKeyRealname]);
    self.address = defaultEmptyString([dictionary objectForKey:kSpinningHttpRequestKeyAddress]);
    self.email = defaultEmptyString([dictionary objectForKey:kSpinningHttpRequestKeyEmail]);
    self.company = defaultEmptyString([dictionary objectForKey:kSpinningHttpRequestKeyCompany]);
    self.position = defaultEmptyString([dictionary objectForKey:kSpinningHttpRequestKeyPosition]);
    self.usercell = defaultEmptyString([dictionary objectForKey:kSpinningHttpRequestKeyUsercell]);
}

- (void)update
{
    NSDictionary *dictionary = [[NSUserDefaults standardUserDefaults] dictionaryForKey:kSpinningHttpKeySaveUser];
    if (dictionary) {
        self.userid = defaultEmptyString([dictionary objectForKey:kSpinningHttpRequestKeyUserid]);
        self.username = defaultEmptyString([dictionary objectForKey:kSpinningHttpRequestKeyUsername]);
        self.password = defaultEmptyString([dictionary objectForKey:kSpinningHttpRequestKeyPassword]);
        self.realname = defaultEmptyString([dictionary objectForKey:kSpinningHttpRequestKeyRealname]);
        self.address = defaultEmptyString([dictionary objectForKey:kSpinningHttpRequestKeyAddress]);
        self.email = defaultEmptyString([dictionary objectForKey:kSpinningHttpRequestKeyEmail]);
        self.company = defaultEmptyString([dictionary objectForKey:kSpinningHttpRequestKeyCompany]);
        self.position = defaultEmptyString([dictionary objectForKey:kSpinningHttpRequestKeyPosition]);
        self.usercell = defaultEmptyString([dictionary objectForKey:kSpinningHttpRequestKeyUsercell]);
    }
}
- (void)save
{
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:self.userid, kSpinningHttpRequestKeyUserid,self.username ,kSpinningHttpRequestKeyUsername ,self.password,kSpinningHttpRequestKeyPassword, self.realname,kSpinningHttpRequestKeyRealname,self.address, kSpinningHttpRequestKeyAddress,self.email,kSpinningHttpRequestKeyEmail,self.position,kSpinningHttpRequestKeyPosition,self.company,kSpinningHttpRequestKeyCompany,self.usercell,kSpinningHttpRequestKeyUsercell,nil];
    [[NSUserDefaults standardUserDefaults] setObject:dictionary forKey:kSpinningHttpKeySaveUser];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)clear
{
    self.username = nil;
    self.password = nil;
    self.realname = nil;
    self.address = nil;
    self.email = nil;
    self.company = nil;
    self.position = nil;
    self.usercell = nil;
    self.userid = nil;
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kSpinningHttpKeySaveUser];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)dealloc
{
    RbSafeRelease(_username);
    RbSafeRelease(_password);
    RbSafeRelease(_realname);
    RbSafeRelease(_address);
    RbSafeRelease(_email);
    RbSafeRelease(_company);
    RbSafeRelease(_position);
    RbSafeRelease(_usercell);
    RbSafeRelease(_userid);
    RbSuperDealoc;
}


@end
