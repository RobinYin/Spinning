//
//  ModifypwdHttpCmd.h
//  Spinning
//
//  Created by Robin on 9/18/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "SingleHttpCmd.h"

@interface ModifypwdHttpCmd : SingleHttpCmd
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *oldpwd;
@end
