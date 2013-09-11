//
//  NewsHttpCmd.m
//  Spinning
//
//  Created by Robin on 9/1/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "NewsHttpCmd.h"

@implementation NewsModel

- (void)dealloc
{
    RbSuperDealoc;
}

@end

@implementation NewsHttpCmd
@synthesize typeId = _typeId;

-(id)init{
    self = [super init];
    if (self) {
        self.typeId = [NSString string];
    }
    return self;
}

- (NSString*)onSuffixUrl
{
    return kSpinningGetNewsList;
}

- (NSMutableDictionary *)paramDict
{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.cursor forKey:kSpinningHttpRequestKeyId];
    [dic setObject:self.typeId forKey:kSpinningHttpRequestKeyTypeid];
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
            ListModel *model = [[NewsModel alloc]init];
            [model parseResultData:dic];
            [self.lists addObject:model];
            RbSafeRelease(model);
        }
    }
}

- (void)dealloc
{
    RbSafeRelease(_typeId);
    RbSuperDealoc;
}

@end
