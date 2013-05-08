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
#import "MFLBezierHelper.h"

@interface MFLHintLabel ()
@property (nonatomic, assign) NSInteger charactersToMoveSimultaneously;
@property (nonatomic, assign) BOOL shouldFade;
@property (nonatomic, assign) CGFloat phaseDelayTime;

@property (nonatomic, strong) UIView *targetView;
@property (nonatomic, strong) NSArray *lineArray;

@property (nonatomic, copy) void (^animEndsBlock)(void);
@end
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
    _animateOffType = kMFLAnimateOffCurvedExplode;
    _animateOnType = kMFLAnimateOnLinear;
    _charactersToMoveSimultaneously = 2;
    _duration = .5;
    _displayTime = 2;
    _solitareTrailDuration = .1;
    _solitareTrailLength = 10;
    _randomizationFactor = 12;
    _tweakKerning = 0;
    _tweakLineheight = 0;
    _implodeFrameFactor = 1;
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
    CGFloat displayWaitTime = [self animateToDisplayPosition];
    
    double delayInSeconds = self.displayTime+displayWaitTime+self.duration;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        CGFloat removeWaitTime = [self animateToFinalPosition];
        
        if (removeWaitTime) {
            double delayInSeconds = self.displayTime+removeWaitTime+self.duration;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                
                if (self.animEndsBlock) {
                    self.animEndsBlock();
                    self.animEndsBlock = nil;
                }
                
                [self cleanAndRemoveAnimation];
            });
        }
    });
}

- (void)runWithCompletion:(void (^)())animEndsBlock
{
    self.animEndsBlock = animEndsBlock;
    [self run];
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
            
            xOffset += characterSize.width + self.tweakKerning;
        }
        
        [self.labelArray addObject:lineLabels];
        yOffset += self.font.pointSize + self.tweakLineheight;
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
        
        if (phaseCount == self.charactersToMoveSimultaneously) {
            phaseCount = 0;
            waitTime+= self.phaseDelayTime;
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
        
        if (phaseCount == self.charactersToMoveSimultaneously) {
            phaseCount = 0;
            waitTime+= self.phaseDelayTime;
        }
    }
    
    return waitTime;
}

- (CGFloat)explodeOnScreen
{
    NSMutableArray *unmovedArray = [@[] mutableCopy];
    
    for (NSArray *array in self.labelArray) { [unmovedArray addObjectsFromArray:array]; }
    
    CGFloat waitTime = self.duration*2;
    
    CGRect containingRect;
    if (CGRectEqualToRect(CGRectZero,self.implodeWithinFrame)) {
        CGRect growingRect;
        
        for (UILabel *label in unmovedArray) {
            if (label == unmovedArray[0]) {
                growingRect.origin = label.frame.origin;
            }
            growingRect = CGRectUnion(growingRect, label.frame);
        }
        
        containingRect = CGRectInset(growingRect,
                                     -(growingRect.size.width * (self.implodeFrameFactor-1)),
                                     -(growingRect.size.height * (self.implodeFrameFactor-1)));
        
    }else{
        containingRect = self.implodeWithinFrame;
    }
    
    while (unmovedArray.count) {
        
        UILabel*character = unmovedArray[arc4random()%unmovedArray.count];
        
        CGPoint offsetPoint;
        
        do {
            offsetPoint = CGPointMake(arc4random()%lrintf(containingRect.size.width),
                                      arc4random()%lrintf(containingRect.size.height));
            
            offsetPoint = CGPointMake(containingRect.origin.x + offsetPoint.x,
                                      containingRect.origin.y + offsetPoint.y);
            
        } while (!CGRectContainsPoint(containingRect, offsetPoint));
        
        CGPoint originalPoint = character.center;
        
        [UIView animateWithDuration:self.duration
                              delay:waitTime
                            options:self.options
                         animations:^{
                             
                             character.center = offsetPoint;
                             
                         } completion:^(BOOL finished) {
                             [UIView animateWithDuration:self.duration
                                                   delay:0
                                                 options:self.options
                                              animations:^{
                                                  character.center = originalPoint;
                                              }completion:nil];
                             
                         }];
        
        [unmovedArray removeObject:character];
        
    }
    return waitTime;
}


- (CGFloat)implodeOntoScreen
{
    CGFloat xOffset = self.displayPosition.x;
    CGFloat yOffset = self.displayPosition.y;
    CGFloat waitTime = 0;
    NSInteger phaseCount = 0;
    
    for (int i = 0; i <self.labelArray.count; i++) {
        
        NSArray *line = [self.labelArray objectAtIndex:i];
        NSString *lineText = [self.lineArray objectAtIndex:i];
        
        if (self.alignment == NSTextAlignmentCenter) {
            CGSize lineSize = [lineText sizeWithFont:self.font];
            xOffset = self.displayPosition.x + ((self.widthConstraint - lineSize.width)/2) ;
        }else{
            xOffset = self.displayPosition.x;
        }
        
        for (UILabel *character in line) {
            
            CGSize characterSize = [character.text sizeWithFont:self.font];
            
            [UIView animateWithDuration:self.duration delay:.3 options:self.options animations:^{
                character.frame = CGRectMake(xOffset,
                                             yOffset,
                                             characterSize.width,
                                             characterSize.height);
                
                
                if (self.shouldFade) {
                    character.alpha = 0;
                }
            } completion:^(BOOL finished) {
                
            }];
            xOffset += characterSize.width + self.tweakKerning;
            
            phaseCount++;
            
            if (phaseCount == self.charactersToMoveSimultaneously) {
                phaseCount = 0;
                waitTime+= self.phaseDelayTime;
            }
            
        }
        
        yOffset += self.font.pointSize + self.tweakLineheight;
    }
    
    return waitTime;
}

- (CGFloat)animateToDisplayPosition
{
    self.phaseDelayTime = self.phaseDelayTimeIn;
    self.shouldFade = self.shouldFadeIn;
    self.charactersToMoveSimultaneously = self.charactersToMoveSimultaneouslyIn;
    
    CGFloat waitTime = 0.5;
    switch (self.animateOnType) {
            
        case kMFLAnimateOnLinear:
        {
            waitTime = [self animateToPosition:self.displayPosition fromPoint:self.startPosition];
            break;
        }
        case kMFLAnimateOnImplode:
        {
            [self setToExplodedPoints];
            waitTime = [self implodeOntoScreen];
            break;
        }
        case kMFLAnimateOnNone:
        {
            waitTime = 0;
            break;
        }
            
        default:
            break;
    }
    
    return waitTime;
}

- (void)setToExplodedPoints
{
    NSMutableArray *unmovedArray = [@[] mutableCopy];
    
    for (NSArray *array in self.labelArray) { [unmovedArray addObjectsFromArray:array]; }
    
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
        
        character.center = offsetPoint;
        
        [unmovedArray removeObject:character];
    }
}


#pragma mark Exit Functions

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
        
        if (phaseCount == self.charactersToMoveSimultaneously) {
            phaseCount = 0;
            waitTime+= self.phaseDelayTime;
        }
    }
    return waitTime;
}


- (CGFloat)explodeToExitWithHighlyRandomCurve
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
        CGFloat randomOffset = ((arc4random()%(lrintf(character.frame.size.width*self.randomizationFactor)))-
                                (character.frame.size.width*(self.randomizationFactor/2)));
        
        if (character.center.x < self.targetView.center.x) {
            offsetPoint = CGPointMake(character.center.x/2 + randomOffset,
                                      containingRect.size.height);
            [curvePath addQuadCurveToPoint:offsetPoint
                              controlPoint:CGPointMake(character.center.x/4, 0)];
        }else{
            offsetPoint = CGPointMake(containingRect.size.width-character.center.x/2 + randomOffset,
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
        
        if (phaseCount == self.charactersToMoveSimultaneously) {
            phaseCount = 0;
            waitTime+= self.phaseDelayTime;
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
        
        if (phaseCount == self.charactersToMoveSimultaneously) {
            phaseCount = 0;
            waitTime+= self.phaseDelayTime;
        }
    }
    return waitTime;
}

- (CGFloat)solitareToExitRandomly
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
        
        CGFloat randomOffset = ((arc4random()%(lrintf(character.frame.size.width*12)))-character.frame.size.width*6);
        
        if (character.center.x < self.targetView.center.x) {
            offsetPoint = CGPointMake(character.center.x/2 + randomOffset,
                                      containingRect.size.height);
            [curvePath addQuadCurveToPoint:offsetPoint
                              controlPoint:CGPointMake(character.center.x/4, 0)];
        }else{
            offsetPoint = CGPointMake(containingRect.size.width-character.center.x/2 + randomOffset,
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
        
        
        [unmovedArray removeObject:character];
        
        NSArray*solitarePoints = getUniformPointsFromCGPath(curvePath.CGPath, self.solitareTrailLength);
        
        
        NSMutableArray *trailArray = [@[] mutableCopy];
        for (NSValue *pointVal in solitarePoints) {
            
            CGPoint point = pointVal.CGPointValue;
            
            UILabel *trail = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,
                                                                      character.frame.size.width,
                                                                      character.frame.size.height)];
            [trail setCenter:point];
            
            [trail setText:character.text];
            [trail setTextColor:character.textColor];
            [trail setFont:character.font];
            [trail setBackgroundColor:[UIColor clearColor]];
            [trailArray addObject:trail];
            
            CGFloat trailDisplayTime = ((self.duration/solitarePoints.count)*[solitarePoints
                                                                              indexOfObject:pointVal]+waitTime);
            NSLog(@"%f", trailDisplayTime);
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(trailDisplayTime * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [UIView animateWithDuration:(self.duration/solitarePoints.count) animations:^{
                    if (pointVal != solitarePoints.lastObject) {
                        CGPoint point =[[solitarePoints objectAtIndex:
                                         [solitarePoints indexOfObject:pointVal]+1] CGPointValue];
                        [character setCenter:point];
                    }
                }];
                
                [self.targetView addSubview:trail];
                
                
                double delayInSeconds = self.solitareTrailDuration;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [UIView animateWithDuration:.3 animations:^{
                        [trail setAlpha:0];
                    }completion:^(BOOL finished) {
                        [trailArray removeObject:trail];
                        [trail removeFromSuperview];
                        if (trailArray.count == 0) {
                            [self.labelArray removeObject:trailArray];
                        }
                    }];
                });
            });
        }
        
        [self.labelArray addObject:trailArray];
        
        
        
        phaseCount++;
        
        if (phaseCount == self.charactersToMoveSimultaneously) {
            phaseCount = 0;
            waitTime+= self.phaseDelayTime;
        }
    }
    return waitTime;
}

- (CGFloat)solitareToExit
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
        
        
        [unmovedArray removeObject:character];
        
        NSArray*solitarePoints = getUniformPointsFromCGPath(curvePath.CGPath, self.solitareTrailLength);
        
        
        NSMutableArray *trailArray = [@[] mutableCopy];
        for (NSValue *pointVal in solitarePoints) {
            
            CGPoint point = pointVal.CGPointValue;
            
            UILabel *trail = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,
                                                                      character.frame.size.width,
                                                                      character.frame.size.height)];
            [trail setCenter:point];
            
            [trail setText:character.text];
            [trail setTextColor:character.textColor];
            [trail setFont:character.font];
            [trail setBackgroundColor:[UIColor clearColor]];
            [trailArray addObject:trail];
            
            CGFloat trailDisplayTime = ((self.duration/solitarePoints.count)*[solitarePoints
                                                                              indexOfObject:pointVal]+waitTime);
            NSLog(@"%f", trailDisplayTime);
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(trailDisplayTime * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [UIView animateWithDuration:(self.duration/solitarePoints.count) animations:^{
                    if (pointVal != solitarePoints.lastObject) {
                        CGPoint point =[[solitarePoints objectAtIndex:
                                         [solitarePoints indexOfObject:pointVal]+1] CGPointValue];
                        [character setCenter:point];
                    }
                }];
                
                [self.targetView addSubview:trail];
                
                
                double delayInSeconds = self.solitareTrailDuration;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [UIView animateWithDuration:.3 animations:^{
                        [trail setAlpha:0];
                    }completion:^(BOOL finished) {
                        [trailArray removeObject:trail];
                        [trail removeFromSuperview];
                        if (trailArray.count == 0) {
                            [self.labelArray removeObject:trailArray];
                        }
                    }];
                });
            });
        }
        
        [self.labelArray addObject:trailArray];
        
        
        phaseCount++;
        
        if (phaseCount == self.charactersToMoveSimultaneously) {
            phaseCount = 0;
            waitTime+= self.phaseDelayTime;
        }
    }
    return waitTime;
}


- (CGFloat)animateToFinalPosition
{
    self.phaseDelayTime = self.phaseDelayTimeOut;
    self.shouldFade = self.shouldFadeOut;
    self.charactersToMoveSimultaneously = self.charactersToMoveSimultaneouslyOut;
    
    CGFloat waitTime = 0;
    switch (self.animateOffType) {
            
        case kMFLAnimateOffLinear:
        {
            waitTime = [self animateToPosition:self.endPosition fromPoint:self.displayPosition];
            break;
        }
            
        case kMFLAnimateOffCurvedExplode:
        {
            waitTime = [self explodeToExitWithCurve];
            break;
        }
            
        case kMFLAnimateOffExplode:
        {
            waitTime = [self explodeToExit];
            break;
        }
            
        case kMFLAnimateImplodeStill:
        {
            waitTime = [self explodeOnScreen];
            break;
        }
            
        case kMFLAnimateOffSolitare:
        {
            waitTime = [self solitareToExit];
            break;
        }
            
        case kMFLAnimateOffRandomCurvedExplode:
        {
            waitTime = [self explodeToExitWithHighlyRandomCurve];
            break;
        }
            
        case kMFLAnimateOffRandomSolitare:
        {
            waitTime = [self solitareToExitRandomly];
        }
            
        case kMFLAnimateOffNone:
        {
            waitTime = 0;
        }
        
        default:
            break;
    }
    
    return waitTime;
}

#pragma mark Stop methods

- (void)stop
{
    [self cleanAndRemoveAnimation];
}

- (void)cleanAndRemoveAnimation
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
    self.animEndsBlock = nil;
}

- (void)dealloc
{
    NSLog(@"%@ dealloc", [self description]);
}


@end
