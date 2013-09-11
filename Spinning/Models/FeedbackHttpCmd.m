//
//  FeedbackHttpCmd.m
//  Spinning
//
//  Created by Robin on 9/3/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "FeedbackHttpCmd.h"

@implementation FeedbackHttpCmd

@synthesize userId = _userId;
@synthesize suggestion = _suggestion;

-(id)init{
    self = [super init];
    if (self) {
    }
    return self;
}

- (NSString*)onSuffixUrl
{
    return kSpinningSuggestion;
}

- (NSMutableDictionary *)paramDict
{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.suggestion forKey:kSpinningHttpRequestKeyId];
    if (self.userId) {
        [dic setObject:self.userId forKey:kSpinningHttpRequestKeyUserid];
    }
    
    return dic;
}

- (void) parseResultData:(NSDictionary*) dictionary{
    

}

- (void)dealloc
{
    RbSafeRelease(_suggestion);
    RbSafeRelease(_userId);
    RbSuperDealoc;
}

@end
