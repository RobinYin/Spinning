//
//  RegisterHttpCmd.h
//  Spinning
//
//  Created by Robin on 9/16/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "SingleHttpCmd.h"

@interface RegisterHttpCmd : SingleHttpCmd
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *realname;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *company;
@property (nonatomic, retain) NSString *position;
@property (nonatomic, retain) NSString *usercell;
@end
