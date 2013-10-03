//
//  CheckinHttpCmd.m
//  Spinning
//
//  Created by Robin on 9/14/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "CheckinHttpCmd.h"

@implementation CheckinModel
@synthesize name = _name;
@synthesize description = _description;
@synthesize code = _code;
@synthesize address = _address;
@synthesize date = _date;
@synthesize sponsor = _sponsor;

- (id)init
{
    if (self = [super init]) {
        self.name = nil;
        self.description = nil;
        self.date = nil;
        self.sponsor = nil;
        self.address = nil;
        self.code = nil;
    }
    return self;
}

- (void) parseResultData:(NSDictionary*) dictionary{
    
    if (dictionary == nil) {
        return;
    }
    [super parseResultData:dictionary];
    
    self.name = defaultEmptyString([dictionary objectForKey:kSpinningHttpKeyName]);
    self.description = defaultEmptyString([dictionary objectForKey:kSpinningHttpKeyDescrpition]);
    self.date = defaultEmptyString([dictionary objectForKey:kSpinningHttpKeyData]);
    self.sponsor = defaultEmptyString([dictionary objectForKey:kSpinningHttpKeySponsor]);
    self.address = defaultEmptyString([dictionary objectForKey:kSpinningHttpKeyAddress]);
    self.code = defaultEmptyString([dictionary objectForKey:kSpinningHttpKeyCode]);
    
}

- (void)dealloc
{
    RbSafeRelease(_name);
    RbSafeRelease(_date);
    RbSafeRelease(_description);
    RbSafeRelease(_code);
    RbSafeRelease(_address);
    RbSafeRelease(_sponsor);
    RbSuperDealoc;
}

@end

@implementation CheckinHttpCmd
@synthesize meetingcode = _meetingcode;
@synthesize realname = _realname;
@synthesize address = _address;
@synthesize email = _email;
@synthesize company = _company;
@synthesize position = _position;
@synthesize usercell = _usercell;
-(id)init{
    self = [super init];
    if (self) {
        self.meetingcode = nil;
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
    return kSpinningJoinConference;
}

- (NSMutableDictionary *)paramDict
{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if ([RbUser sharedInstance].userid) {
        if (![[RbUser sharedInstance].userid isEqualToString:@""]) {
        [dic setObject:[RbUser sharedInstance].userid forKey:kSpinningHttpRequestKeyUserid];
        }
    }
    [dic setObject:self.meetingcode forKey:kSpinningHttpRequestKeyMeetingcode];
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
    
    NSDictionary *body = defaultNilObject([dictionary objectForKey:kSpinningHttpKeyMeeting]);
    NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithDictionary:header];
    if (body) {
        [mutableDic addEntriesFromDictionary:body];
    }
    
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:mutableDic];
    
    if (dic) {
        SingleModel *tmpModel = [[CheckinModel alloc]init];
        [tmpModel parseResultData:dic];
        self.model = tmpModel;
        RbSafeRelease(tmpModel);
    }
    
}


- (void)dealloc
{
    RbSafeRelease(_realname);
    RbSafeRelease(_address);
    RbSafeRelease(_email);
    RbSafeRelease(_company);
    RbSafeRelease(_position);
    RbSafeRelease(_usercell);
    RbSafeRelease(_meetingcode);
    RbSuperDealoc;
}

@end
