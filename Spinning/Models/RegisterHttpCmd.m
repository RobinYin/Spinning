//
//  RegisterHttpCmd.m
//  Spinning
//
//  Created by Robin on 9/16/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "RegisterHttpCmd.h"

@implementation RegisterHttpCmd

@synthesize username = _username;
@synthesize password = _password;
@synthesize realname = _realname;
@synthesize address = _address;
@synthesize email = _email;
@synthesize company = _company;
@synthesize position = _position;
@synthesize usercell = _usercell;

-(id)init{
    self = [super init];
    if (self) {
        self.username = nil;
        self.password = nil;
        self.realname = nil;
        self.address = nil;
        self.email = nil;
        self.company = nil;
        self.position = nil;
        self.usercell = nil;
    }
    return self;
}

- (NSString*)onSuffixUrl
{
    return kSpinningRegisterUser;
}

- (NSMutableDictionary *)paramDict
{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.username forKey:kSpinningHttpRequestKeyUsername];
    [dic setObject:self.password forKey:kSpinningHttpRequestKeyPassword];
    [dic setObject:self.realname forKey:kSpinningHttpRequestKeyRealname];
    [dic setObject:self.address forKey:kSpinningHttpRequestKeyAddress];
    [dic setObject:self.email forKey:kSpinningHttpRequestKeyEmail];
    [dic setObject:self.company forKey:kSpinningHttpRequestKeyCompany];
    [dic setObject:self.position forKey:kSpinningHttpRequestKeyPosition];
    [dic setObject:self.usercell forKey:kSpinningHttpRequestKeyUsercell];
    return dic;
}

- (void) parseResultData:(NSDictionary*) dictionary{
    
    if (dictionary == nil) {
        return;
    }
    
    NSDictionary *header = defaultNilObject([dictionary objectForKey:kSpinningHttpKeyHeader]);
    
    NSDictionary *body = defaultNilObject([dictionary objectForKey:kSpinningHttpKeyUser]);
    NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithDictionary:header];
    if (body) {
        [mutableDic addEntriesFromDictionary:body];
    }
    
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:mutableDic];
    
    if (dic) {
        RbUser *user = [RbUser sharedInstance];
        [user parseResultData:dic];
        self.model = user;
    }
    
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
    RbSuperDealoc;
}

@end
