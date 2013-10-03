//
//  HistoryHttpCmd.m
//  Spinning
//
//  Created by Robin on 10/3/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "HistoryHttpCmd.h"
@implementation HistoryModel
@synthesize code = _code;
@synthesize registertime = _registertime;
@synthesize name = _name;

- (id)init
{
    if (self = [super init]) {
        self.code = nil;
        self.registertime = nil;
        self.name = nil;
    }
    return self;
}

- (void)dealloc
{
    RbSafeRelease(_name);
    RbSafeRelease(_code);
    RbSafeRelease(_registertime);
    RbSuperDealoc;
}

- (void) parseResultData:(NSDictionary*) dictionary{
    
    if (dictionary == nil) {
        return;
    }
    
    self.code = defaultEmptyString([dictionary objectForKey:kSpinningHttpKeyCode]);
    self.registertime = defaultEmptyString([dictionary objectForKey:kSpinningHttpKeyRegistertime]);
    self.name = defaultEmptyString([dictionary objectForKey:kSpinningHttpKeyName]);
    
}

@end

@implementation HistoryHttpCmd

-(id)init{
    self = [super init];
    if (self) {
    }
    return self;
}

- (NSString*)onSuffixUrl
{
    return kSpinningGetUsermeeting;
}

- (NSMutableDictionary *)paramDict
{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    self.userId = [RbUser sharedInstance].userid;
    if (self.userId) {
        [dic setObject:self.userId forKey:kSpinningHttpRequestKeyUserid];
    }
    return dic;
}

- (void) parseResultData:(NSDictionary*) dictionary{
    
    if (dictionary == nil) {
        return;
    }
    
    NSArray *array = defaultNilObject([dictionary objectForKey:kSpinningHttpKeyList]);
    
    if (array) {
        for (NSDictionary *dic in array) {
            ListModel *model = [[HistoryModel alloc]init];
            [model parseResultData:dic];
            [self.lists addObject:model];
            RbSafeRelease(model);
        }
    }
}

- (void)dealloc
{
    RbSuperDealoc;
}


@end
