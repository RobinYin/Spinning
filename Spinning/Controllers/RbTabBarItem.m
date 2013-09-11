//
//  RbTabBarItem.m
//  Spinning
//
//  Created by Robin on 8/11/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "RbTabBarItem.h"

@implementation RbTabBarItem
@synthesize selectedImage=_selectedImage, image=_image;

-(id)initWithImage:(UIImage*)image selectedImage:(UIImage*)selectedImage
{
    if ((self = [super init])) {
        self.image = image;
        self.selectedImage = selectedImage;
    }return self;
}

- (void)dealloc
{
    RbSafeRelease(_selectedImage);
    RbSafeRelease(_image);
    RbSuperDealoc;
}
@end
