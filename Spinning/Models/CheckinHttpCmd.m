//
//  CheckinHttpCmd.m
//  Spinning
//
//  Created by Robin on 9/14/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "CheckinHttpCmd.h"

@implementation CheckinModel
@end

@implementation CheckinHttpCmd
@synthesize meetingcode = _meetingcode;

-(id)init{
    self = [super init];
    if (self) {
        self.meetingcode = nil;
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
    if (self.userId) {
        [dic setObject:self.userId forKey:kSpinningHttpRequestKeyUserid];
    }
    [dic setObject:self.meetingcode forKey:kSpinningHttpRequestKeyMeetingcode];
    
    return dic;
}

- (void)dealloc
{
    RbSafeRelease(_meetingcode);
    RbSuperDealoc;
}

@end
