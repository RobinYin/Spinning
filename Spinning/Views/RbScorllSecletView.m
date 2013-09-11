//
//  RbScorllSecletView.m
//  Spinning
//
//  Created by Robin on 7/28/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "RbScorllSecletView.h"

@interface RbScorllSecletView()

@property (nonatomic, retain)NSArray *titleArray;
@property (nonatomic, retain)NSArray *rectArray;
@property (nonatomic, retain)NSMutableArray *buttons;
@end

@implementation RbScorllSecletView

@synthesize titleArray = _titleArray;
@synthesize rectArray = _rectArray;
@synthesize buttons = _buttons;
@synthesize selectDelegate = _selectDelegate;

- (void)dealloc
{
    RbSafeRelease(_titleArray);
    RbSafeRelease(_rectArray);
    RbSafeRelease(_buttons);
    RbSuperDealoc;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.delegate = self;
        self.backgroundColor = [UIColor colorWithRed:0./255. green:55./255 blue:110./255 alpha:1];
        self.pagingEnabled = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.buttons = [NSMutableArray array];
    }
    return self;
}

- (void)setTitles:(NSArray*)array
{
    self.titleArray = [NSArray arrayWithArray:array];
    self.rectArray = rectsFromArray(array, [UIFont systemFontOfSize:ScrollSelectFont], CGSizeMake(ScrollSelectWidth, ScrollSelectHeight),ScrollSelectGap);
    CGRect rect = CGRectFromString((NSString *)[self.rectArray lastObject]);
    self.contentSize = CGSizeMake(rect.origin.x + rect.size.width, ScrollSelectHeight);
    [self configureBtns];
}

- (void)configureBtns
{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
            self.buttons = [NSMutableArray array];
        }
    }
    for (int i = 0; i<[self.titleArray count]; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectFromString((NSString *)[self.rectArray objectAtIndex:i])];
        [button setTag:TagBegin+i];
        if (i == 0) {
            button.selected = YES;
        }
        [button setTitle:[NSString stringWithFormat:@"%@",[self.titleArray objectAtIndex:i]] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:ScrollSelectFont];
        [button setTitleColor:ScrollSelectBgNormalColor forState:UIControlStateNormal];
        [button setTitleColor:ScrollSelectBgSelectColor forState:UIControlStateSelected];
        [button addTarget:self action:@selector(touchDownForButton:) forControlEvents:UIControlEventTouchDown];
        [button addTarget:self action:@selector(touchUpForButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttons addObject:button];
        [self addSubview:button];
        }
}

-(void)touchDownForButton:(UIButton*)button {
    [button setSelected:YES];
}

-(void)touchUpForButton:(UIButton*)button {
    for (UIButton *b in self.buttons) {
        [b setSelected:NO];
    }
    [button setSelected:YES];
    [self adjustScrollViewContentX:button];
    if ([_selectDelegate respondsToSelector:@selector(scrollSelectAtIndex:)]) {
        [_selectDelegate scrollSelectAtIndex:button.tag - TagBegin];
    }
}

- (void)adjustScrollViewContentX:(UIButton *)sender
{
    
    CGFloat conOffset_x;
    if (sender.frame.origin.x+sender.frame.size.width/2<ScrollSelectWidth/2) {
        conOffset_x = 0;
    }else if(sender.frame.origin.x+sender.frame.size.width/2>ScrollSelectWidth/2 && sender.frame.origin.x+sender.frame.size.width/2<self.contentSize.width-ScrollSelectWidth/2){
        conOffset_x = -ScrollSelectWidth/2+sender.frame.origin.x+sender.frame.size.width/2;
    }else{
        conOffset_x = self.contentSize.width-ScrollSelectWidth;
    }
     [self setContentOffset:CGPointMake(conOffset_x , 0)  animated:YES];
  
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
