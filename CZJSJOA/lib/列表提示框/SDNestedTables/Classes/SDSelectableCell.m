//
//  SDSelectableCell.m
//  SDNestedTablesExample
//
//  Created by Daniele De Matteis on 23/05/2012.
//  Copyright (c) 2012 Daniele De Matteis. All rights reserved.
//

#import "SDSelectableCell.h"

@implementation SDSelectableCell

@synthesize itemText, parentTable, selectableCellState;

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if((self = [super initWithCoder:aDecoder]))
    {
        selectableCellState = Unchecked;
    }
    return self;
}
- (void) layoutSubviews
{
    [super layoutSubviews];
    [self setupInterface];
}

- (void) setupInterface
{
    [self setClipsToBounds: YES];
    
    tapTransitionsOverlay.backgroundColor = [UIColor colorWithRed:0.15 green:0.54 blue:0.93 alpha:1.0];
    
    CGRect frame = self.itemText.frame;
    frame.size.width = checkBox.frame.origin.x - frame.origin.x - (int)(self.frame.size.width/30);
    self.itemText.frame = frame;
}

- (SelectableCellState) toggleCheck
{
    if (selectableCellState == Checked)
    {
        selectableCellState = Unchecked;
        [self styleDisabled];
    }
    else
    {
        selectableCellState = Checked;
        [self styleEnabled];
    }
    return selectableCellState;
}

- (void) check
{
    selectableCellState = Checked;
    [self styleEnabled];
}

- (void) uncheck
{
    selectableCellState = Unchecked;
    [self styleDisabled];
}

- (void) halfCheck
{
    selectableCellState = Halfchecked;
    [self styleHalfEnabled];
}

- (void) styleEnabled
{
    for (UIView *view in checkBox.subviews) [view removeFromSuperview];
    [checkBox addSubview:onCheckBox];
    checkBox.alpha = 1.0;
    itemText.alpha = 1.0;
    self.backgroundView.backgroundColor = [UIColor whiteColor];//[UIColor FromRGBWithAlpha(0xFFFFFF, 1.0)];
    self.backgroundView.alpha = 0.7;
}

- (void) styleDisabled
{
    for (UIView *view in checkBox.subviews) [view removeFromSuperview];
    [checkBox addSubview:offCheckBox];
    checkBox.alpha = 1.0;
    itemText.alpha = 0.4;
    self.backgroundView.backgroundColor = [UIColor colorWithWhite:10.0 alpha:1.0];
    self.backgroundView.alpha = 0.5;
}

- (void) styleHalfEnabled
{
    for (UIView *view in checkBox.subviews) [view removeFromSuperview];
    [checkBox addSubview:onCheckBox];
    checkBox.alpha = 0.45;
    itemText.alpha = 0.7;
    self.backgroundView.backgroundColor = [UIColor whiteColor];//UIColorFromRGBWithAlpha(0xFFFFFF, 1.0);
    self.backgroundView.alpha = 0.7;
}

- (void) tapTransition
{
    tapTransitionsOverlay.alpha = 1.0;
    [UIView beginAnimations:@"tapTransition" context:nil];
    [UIView setAnimationDuration:0.8];
    tapTransitionsOverlay.alpha = 0.0;
    [UIView commitAnimations];
}

@end
