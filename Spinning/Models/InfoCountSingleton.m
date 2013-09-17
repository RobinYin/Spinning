//
//  InfoCountSingleton.m
//  Spinning
//
//  Created by Robin on 9/17/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "InfoCountSingleton.h"

@implementation InfoCountSingleton
@synthesize notice = _notice;
@synthesize topic = _topic;
+(InfoCountSingleton *)sharedInstance {
    
    static InfoCountSingleton *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init
{
    if (self = [super init]) {
        self.notice = [NSString stringWithFormat:@"0"];
        self.topic = [NSString stringWithFormat:@"0"];
        [self update];
        NSLog(@"notice = %@,topic = %@",self.notice,self.topic);
    }
    return self;
}

- (void)update
{
    NSDictionary *dictionary = [[NSUserDefaults standardUserDefaults] dictionaryForKey:kSpinningHttpKeyInfoCountShared];
    if (dictionary) {
        self.notice = defaultEmptyString([dictionary objectForKey:kSpinningHttpKeyNotice]);
        self.topic = defaultEmptyString([dictionary objectForKey:kSpinningHttpKeyTopic]);
        NSLog(@"notice = %@,topic = %@",self.notice,self.topic);
    }
}
- (void)save
{
    NSLog(@"%@",self.notice);
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:self.notice, kSpinningHttpKeyNotice,self.topic ,kSpinningHttpKeyTopic ,nil];
    [[NSUserDefaults standardUserDefaults] setObject:dictionary forKey:kSpinningHttpKeyInfoCountShared];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)dealloc
{
    RbSafeRelease(_topic);
    RbSafeRelease(_notice);
    RbSuperDealoc;
}
@end
