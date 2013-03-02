//
//  MFLHintLabel.m
//  MFLHintLabel
//
//  Created by teejay on 2/27/13.
//  Copyright (c) 2013 teejay. All rights reserved.
//

#import "MFLHintLabel.h"
#import <QuartzCore/QuartzCore.h>
#import "UILabel+Lines.h"

@implementation MFLHintLabel


- (MFLHintLabel*)init
{
    self = [super init];
    return self;
}

- (MFLHintLabel *)createHintAnimationForText:(NSString*)text
                                    withFont:(UIFont*)font
                                 beginningAt:(CGPoint)startPoint
                                displayingAt:(CGPoint)displayPoint
                                    endingAt:(CGPoint)endPoint
                                inTargetView:(UIView*)view
{
    id animation = [self init];
    
    _font = font;
    _stringToDisplay = text;
    
    _startPosition = startPoint;
    _displayPosition = displayPoint;
    _endPosition = endPoint;
    _targetView = view;
    
    _alignment = NSTextAlignmentCenter;
    _textColor = [UIColor blackColor];
    [self setDefaultProperties];
    
    return animation;
}

- (MFLHintLabel *)createHintAnimationForLabel:(UILabel*)label
                                  beginningAt:(CGPoint)startPoint
                                 displayingAt:(CGPoint)displayPoint
                                     endingAt:(CGPoint)endPoint
                                 inTargetView:(UIView*)view
{
    id animation = [self init];
    
    _font = label.font;
    _stringToDisplay = label.text;
    _alignment = label.textAlignment;
    
    _startPosition = startPoint;
    _displayPosition = displayPoint;
    _endPosition = endPoint;
    _targetView = view;
    
    _textColor = label.textColor;
    _lineArray = [label linesForWidth:_widthConstraint];
    
    [self setDefaultProperties];
    
    return animation;
}

- (void)setDefaultProperties
{
    _animationType = kMFLAnimationCurvedExplode;
    _duration = .5;
    _displayTime = 2;
    _widthConstraint = CGRectGetWidth(_targetView.bounds) - 60;
}




- (void)prepareToRun
{
    UILabel *testLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.widthConstraint, 250)];
    [testLabel setTextAlignment:self.alignment];
    [testLabel setFont:self.font];
    [testLabel setText:self.stringToDisplay];
    _lineArray = [testLabel linesForWidth:self.widthConstraint];
    
    [self createLabels];
    
}

#pragma mark Running Methods

- (void)run
{
    CGFloat finalWaitTime = [self animateToDisplayPosition];
    [self performSelector:@selector(animateToFinalPosition)
               withObject:nil
               afterDelay:self.displayTime+finalWaitTime+self.duration
                  inModes:@[NSDefaultRunLoopMode]];
    
}

- (void)createLabels
{
    
    CGFloat xOffset = self.startPosition.x;
    CGFloat yOffset = self.startPosition.y;
    self.labelArray = [@[] mutableCopy];
    
    for (NSString *line in self.lineArray) {
        NSMutableArray *lineLabels = [@[] mutableCopy];
        
        if (self.alignment == NSTextAlignmentCenter) {
            CGSize lineSize = [line sizeWithFont:self.font];
            xOffset = self.startPosition.x + ((self.widthConstraint - lineSize.width)/2) ;
        }else{
            xOffset = self.startPosition.x;
        }
        
        for (int i = 0; i < line.length; i++) {
            
            NSString*character = [line substringWithRange:NSMakeRange(i, 1)];
            CGSize characterSize = [character sizeWithFont:self.font];
            
            UILabel *characterLabel = [[UILabel alloc]initWithFrame:CGRectMake(xOffset,
                                                                               yOffset,
                                                                               characterSize.width,
                                                                               characterSize.height)];
            
            [characterLabel setFont:self.font];
            [characterLabel setTextColor:self.textColor];
            [characterLabel setBackgroundColor:[UIColor clearColor]];
            [characterLabel setText:character];
            [lineLabels addObject:characterLabel];
            [self.targetView addSubview:characterLabel];
            
            if (self.shouldFade) {
                characterLabel.alpha = 0;
            }
            
            xOffset += characterSize.width;
        }
        
        [self.labelArray addObject:lineLabels];
        yOffset += self.font.pointSize;
    }
}

#pragma mark Animation Methods

- (CGFloat)animateToPosition:(CGPoint)position
{
    
    NSMutableArray *unmovedArray = [@[] mutableCopy];
    
    for (NSArray *array in self.labelArray) { [unmovedArray addObjectsFromArray:array]; }
    
    int phaseCount = 0;
    CGFloat waitTime = 0;
    while (unmovedArray.count) {
        
        UILabel*character = unmovedArray[arc4random()%unmovedArray.count];
        
        [UIView animateWithDuration:self.duration
                              delay:waitTime
                            options:self.options
                         animations:^{
                             CGPoint offsetPoint = CGPointMake(position.x - character.center.x,
                                                               position.y - character.center.y);
                             character.center = CGPointMake(character.center.x + offsetPoint.x,
                                                            character.center.y + offsetPoint.y);
                             
                         } completion:^(BOOL finished) {
                             
                             
                             
                         }];
        
        [unmovedArray removeObject:character];
        
        phaseCount++;
        
        if (phaseCount == 3) {
            phaseCount = 0;
            waitTime+= .15;
        }
    }
    return waitTime;
}

- (CGFloat)animateToPosition:(CGPoint)endPosition fromPoint:(CGPoint)startPosition
{
    NSMutableArray *unmovedArray = [@[] mutableCopy];
    
    for (NSArray *array in self.labelArray) { [unmovedArray addObjectsFromArray:array]; }
    
    CGPoint offsetPoint = CGPointMake(endPosition.x - startPosition.x,
                                      endPosition.y - startPosition.y);
    int phaseCount = 0;
    CGFloat waitTime = 0;
    while (unmovedArray.count) {
        
        UILabel*character = unmovedArray[arc4random()%unmovedArray.count];
        
        [UIView animateWithDuration:self.duration
                              delay:waitTime
                            options:self.options
                         animations:^{
                             
                             character.center = CGPointMake(character.center.x + offsetPoint.x,
                                                            character.center.y + offsetPoint.y);
                             
                         } completion:^(BOOL finished) {
                             
                             
                             
                         }];
        
        [unmovedArray removeObject:character];
        
        phaseCount++;
        
        if (phaseCount == 3) {
            phaseCount = 0;
            waitTime+= .05;
        }
    }
    return waitTime;
}

- (CGFloat)explodeOnScreen
{
    NSMutableArray *unmovedArray = [@[] mutableCopy];
    
    for (NSArray *array in self.labelArray) { [unmovedArray addObjectsFromArray:array]; }
    
    
    
    int phaseCount = 0;
    CGFloat waitTime = 0;
    
    while (unmovedArray.count) {
        
        UILabel*character = unmovedArray[arc4random()%unmovedArray.count];
        
        CGRect containingRect =CGRectInset(self.targetView.frame,
                                           -character.frame.size.width,
                                           -character.frame.size.height);
        CGPoint offsetPoint;
        
        do {
            offsetPoint = CGPointMake(arc4random()%lrintf(containingRect.size.width*2),
                                      arc4random()%lrintf(containingRect.size.height*2));
            
        } while (!CGRectContainsPoint(containingRect, offsetPoint));
        
        if (arc4random()%2) {
            offsetPoint = CGPointMake(-offsetPoint.x, -offsetPoint.y);
        }
        CGPoint originalPoint = character.center;
        
        [UIView animateWithDuration:self.duration
                              delay:waitTime
                            options:self.options | UIViewAnimationOptionAutoreverse
                         animations:^{
                             
                             character.center = offsetPoint;
                             
                         } completion:^(BOOL finished) {
                             
                             character.center = originalPoint;
                             
                         }];
        
        [unmovedArray removeObject:character];
        
        phaseCount++;
    }
    return waitTime;
}

- (CGFloat)explodeToExit
{
    NSMutableArray *unmovedArray = [@[] mutableCopy];
    
    for (NSArray *array in self.labelArray) { [unmovedArray addObjectsFromArray:array]; }
    
    
    
    int phaseCount = 0;
    CGFloat waitTime = 0;
    
    while (unmovedArray.count) {
        
        UILabel *character = unmovedArray[arc4random()%unmovedArray.count];
        
        CGRect containingRect =CGRectInset(self.targetView.frame,
                                           -character.frame.size.width,
                                           -character.frame.size.height);
        CGPoint offsetPoint;
        
        do {
            offsetPoint = CGPointMake(arc4random()%lrintf(containingRect.size.width*2),
                                      arc4random()%lrintf(containingRect.size.height*2));
            
        } while (CGRectContainsPoint(containingRect, offsetPoint));
        
        if (arc4random()%2) {
            offsetPoint = CGPointMake(-offsetPoint.x, -offsetPoint.y);
        }
        
        [UIView animateWithDuration:self.duration
                              delay:waitTime
                            options:self.options
                         animations:^{
                             
                             character.center = offsetPoint;
                             
                         } completion:^(BOOL finished) {
                             
                             
                             
                         }];
        
        [unmovedArray removeObject:character];
        
        phaseCount++;
        
        if (phaseCount == 10) {
            phaseCount = 0;
            waitTime+= .15;
        }
    }
    return waitTime;
}


- (CGFloat)explodeToExitWithCurve
{
    NSMutableArray *unmovedArray = [@[] mutableCopy];
    
    for (NSArray *array in self.labelArray) { [unmovedArray addObjectsFromArray:array]; }
    
    
    
    int phaseCount = 0;
    CGFloat waitTime = 0;
    
    while (unmovedArray.count) {
        
        UILabel *character = unmovedArray[arc4random()%unmovedArray.count];
        
        CGRect containingRect =CGRectInset(self.targetView.frame,
                                           -character.frame.size.width,
                                           -character.frame.size.height);
        
        UIBezierPath *curvePath = [UIBezierPath bezierPath];
        [curvePath moveToPoint:character.center];
        
        CGPoint offsetPoint;
        
        if (character.center.x < self.targetView.center.x) {
            offsetPoint = CGPointMake(character.center.x/2,
                                      containingRect.size.height);
            [curvePath addQuadCurveToPoint:offsetPoint
                              controlPoint:CGPointMake(character.center.x/4, 0)];
        }else{
            offsetPoint = CGPointMake(containingRect.size.width-character.center.x/2,
                                      containingRect.size.height);
            [curvePath addQuadCurveToPoint:offsetPoint
                              controlPoint:CGPointMake(self.targetView.frame.size.width - character.center.x/4, 0)];
        }
        
        CAKeyframeAnimation *moveAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        moveAnim.path = curvePath.CGPath;
        moveAnim.duration = self.duration;
        moveAnim.fillMode = kCAFillModeForwards;
        moveAnim.beginTime = CACurrentMediaTime() + waitTime;
        moveAnim.removedOnCompletion = NO;
        
        [character.layer addAnimation:moveAnim forKey:@"stuff"];
        
        [unmovedArray removeObject:character];
        
        phaseCount++;
        
        if (phaseCount == 2) {
            phaseCount = 0;
            waitTime+= .05;
        }
    }
    return waitTime;
}


- (CGFloat)animateToDisplayPosition
{
    CGFloat waitTime = 0.5;
    switch (self.animationType) {
            
        case kMFLAnimationLinear:
        {
            waitTime = [self animateToPosition:self.displayPosition fromPoint:self.startPosition];
            break;
        }
            
        case kMFLAnimationCurvedExplode:
        {
            waitTime = [self animateToPosition:self.displayPosition fromPoint:self.startPosition];
            break;
        }
            
        case kMFLAnimationExplode:
        {
            waitTime = [self animateToPosition:self.displayPosition fromPoint:self.startPosition];
            break;
        }
        case kMFLAnimationImplode:
        {
            [self explodeOnScreen];
            break;
        }
            
        default:
            break;
    }
    return waitTime;
}

- (CGFloat)animateToFinalPosition
{
    
    CGFloat waitTime = 0;
    switch (self.animationType) {
            
        case kMFLAnimationLinear:
        {
            waitTime = [self animateToPosition:self.endPosition fromPoint:self.displayPosition];
            break;
        }
            
        case kMFLAnimationCurvedExplode:
        {
            [self explodeToExitWithCurve];
            break;
        }
            
        case kMFLAnimationExplode:
        {
            [self explodeToExit];
            break;
        }
            
        case kMFLAnimationImplode:
        {
            //waitTime = [self animateToPosition:self.displayPosition];
            break;
        }
        default:
            break;
    }
    
    return waitTime;
}

#pragma mark Stop methods

- (void)cleanAnimation
{
    self.targetView = nil;
    
    for (NSMutableArray*array in self.labelArray) {
        for (UILabel *label in array) {
            [label.layer removeAllAnimations];
            [label removeFromSuperview];
        }
        
        [array removeAllObjects];
    }
    
    [self.labelArray removeAllObjects];
    self.labelArray = nil;
    
    self.font = nil;
    self.stringToDisplay = nil;
    self.textColor = nil;
}

- (void)dealloc
{
    NSLog(@"You don't suck at memory management.");
}


@end
