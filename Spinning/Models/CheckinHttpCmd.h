//
//  CheckinHttpCmd.h
//  Spinning
//
//  Created by Robin on 9/14/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "SingleHttpCmd.h"

@interface CheckinModel :SingleModel
@property (nonatomic, retain)NSString *address;
@property (nonatomic, retain)NSString *date;
@property (nonatomic, retain)NSString *description;
@property (nonatomic, retain)NSString *name;
@property (nonatomic, retain)NSString *sponsor;
@property (nonatomic, retain)NSString *code;
@end
@interface CheckinHttpCmd : SingleHttpCmd
@property (nonatomic, retain) NSString *meetingcode;
@property (nonatomic, retain) NSString *realname;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *company;
@property (nonatomic, retain) NSString *position;
@property (nonatomic, retain) NSString *usercell;
@end
