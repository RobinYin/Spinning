//
//  RbUser.h
//  Spinning
//
//  Created by Robin on 7/28/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "SingleHttpCmd.h"

@interface RbUser : SingleModel
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *realname;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *company;
@property (nonatomic, retain) NSString *position;
@property (nonatomic, retain) NSString *usercell;
@property (nonatomic, retain) NSString *userid;

+(RbUser *)sharedInstance;
-(void)save;
-(void)clear;

@end
