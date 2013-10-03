//
//  ModifypwdHttpCmd.m
//  Spinning
//
//  Created by Robin on 9/18/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "ModifypwdHttpCmd.h"

@implementation ModifypwdHttpCmd
@synthesize username = _username;
@synthesize password = _password;
@synthesize oldpwd = _oldpwd;

-(id)init{
    self = [super init];
    if (self) {
        self.username = nil;
        self.password = nil;
        self.oldpwd = nil;
    }
    return self;
}

- (NSString*)onSuffixUrl
{
    return kSpinningModifyPwd;
}

- (NSMutableDictionary *)paramDict
{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.username forKey:kSpinningHttpRequestKeyUsername];
    [dic setObject:self.password forKey:kSpinningHttpRequestKeyNewpwd];
    [dic setObject:self.oldpwd forKey:kSpinningHttpRequestKeyOldpwd];
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
        if ( [defaultEmptyString([header objectForKey:kSpinningHttpKeyCode]) isEqualToString:kSpinningHttpKeyOk]) {
            user.password = self.password;
            [user save];
        }
        user.msg = defaultEmptyString([header objectForKey:kSpinningHttpKeyMsg]);
        user.code = defaultEmptyString([header objectForKey:kSpinningHttpKeyCode]);
        self.model = user;
    }
    
}

- (void)dealloc
{
    RbSafeRelease(_oldpwd);
    RbSafeRelease(_username);
    RbSafeRelease(_password);
    RbSuperDealoc;
}

@end
