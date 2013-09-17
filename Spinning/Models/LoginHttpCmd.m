//
//  LoginHttpCmd.m
//  Spinning
//
//  Created by Robin on 9/16/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "LoginHttpCmd.h"

@implementation LoginHttpCmd
@synthesize username = _username;
@synthesize password = _password;

-(id)init{
    self = [super init];
    if (self) {
        self.username = nil;
        self.password = nil;
    }
    return self;
}

- (NSString*)onSuffixUrl
{
    return kSpinningLoginUser;
}

- (NSMutableDictionary *)paramDict
{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.username forKey:kSpinningHttpRequestKeyUsername];
    [dic setObject:self.password forKey:kSpinningHttpRequestKeyPassword];
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
        user.password = self.password;
        [user parseResultData:dic];
        [user save];
        self.model = user;
    }
    
}

- (void)dealloc
{
    RbSafeRelease(_username);
    RbSafeRelease(_password);
    RbSuperDealoc;
}

@end
