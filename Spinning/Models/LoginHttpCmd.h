//
//  LoginHttpCmd.h
//  Spinning
//
//  Created by Robin on 9/16/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "SingleHttpCmd.h"

@interface LoginHttpCmd : SingleHttpCmd
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;
@end
