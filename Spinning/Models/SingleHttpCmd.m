//
//  SingleHttpCmd.m
//  Spinning
//
//  Created by Robin on 9/3/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "SingleHttpCmd.h"

@implementation SingleModel
@synthesize code = _code;
@synthesize msg = _msg;
- (id)init
{
    if (self = [super init]) {
        self.code = nil;
        self.msg = nil;
    }
    return self;
}

- (void) parseResultData:(NSDictionary*) dictionary{
    
    if (dictionary == nil) {
        return;
    }
    self.code = defaultEmptyString([dictionary objectForKey:kSpinningHttpKeyCode]);
    self.msg = defaultEmptyString([dictionary objectForKey:kSpinningHttpKeyMsg]);
    
}

- (void)dealloc
{
    RbSafeRelease(_code);
    RbSafeRelease(_msg);
    RbSuperDealoc;
}

@end

@implementation SingleHttpCmd
@synthesize userId = _userId;
@synthesize model = _model;

- (id)init
{
    if (self = [super init]) {
        self.userId = nil;
        self.model = nil;
    }
    return self;
}

- (void) parseResultData:(NSDictionary*) dictionary{
    
    if (dictionary == nil) {
        return;
    }
    
    NSDictionary *header = defaultNilObject([dictionary objectForKey:kSpinningHttpKeyHeader]);
    
    if (header) {
            SingleModel *tmpModel = [[SingleModel alloc]init];
            [tmpModel parseResultData:header];
            self.model = tmpModel;
            RbSafeRelease(tmpModel);
    }
}

- (void)dealloc
{
    RbSafeRelease(_model);
    RbSafeRelease(_userId);
    RbSuperDealoc;
}

@end
