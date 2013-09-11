//
//  NotifyHttpCmd.m
//  Spinning
//
//  Created by Robin on 9/3/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "NotifyHttpCmd.h"

@implementation NotifyModel

- (void)dealloc
{
    RbSuperDealoc;
}

@end

@implementation NotifyHttpCmd

-(id)init{
    self = [super init];
    if (self) {
    }
    return self;
}

- (NSString*)onSuffixUrl
{
    return kSpinningGetNoticeList;
}

- (NSMutableDictionary *)paramDict
{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.cursor forKey:kSpinningHttpRequestKeyId];
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
            ListModel *model = [[NotifyModel alloc]init];
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
