//
//  RemarkHttpCmd.m
//  Spinning
//
//  Created by Robin on 9/14/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "RemarkHttpCmd.h"
@implementation RemarkModel

@end

@implementation RemarkHttpCmd
@synthesize suggestion = _suggestion;
@synthesize mid = _mid;

-(id)init{
    self = [super init];
    if (self) {
        self.suggestion = nil;
        self.mid = nil;
    }
    return self;
}

- (NSString*)onSuffixUrl
{
    return kSpinningRemark;
}

- (NSMutableDictionary *)paramDict
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.suggestion forKey:kSpinningHttpRequestKeySuggestion];
    if (self.userId) {
        [dic setObject:self.userId forKey:kSpinningHttpRequestKeyUserid];
    }
    [dic setObject:self.mid forKey:kSpinningHttpKeyId];
    NSLog(@"dic = %@",dic);
    return dic;
}

- (void)dealloc
{
    RbSafeRelease(_mid);
    RbSafeRelease(_suggestion);
    RbSuperDealoc;
}

@end
