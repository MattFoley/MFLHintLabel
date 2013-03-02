//
//  MFLViewController.m
//  MFLHintLabel
//
//  Created by teejay on 2/25/13.
//  Copyright (c) 2013 teejay. All rights reserved.
//

#import "MFLViewController.h"
#import "MFLHintLabel.h"

@interface MFLViewController ()
@property (nonatomic, strong) MFLHintLabel *hintAnimation;
@property (nonatomic, strong) IBOutletCollection(UIButton) NSMutableArray *buttons;

@end

@implementation MFLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    for (UIButton*button in self.buttons) {
        UIImage *resizableButton = [[UIImage imageNamed:@"buttons_btn.png"]
                                   resizableImageWithCapInsets:UIEdgeInsetsMake(15, 15, 15, 15)];
        [button setBackgroundImage:resizableButton forState:UIControlStateNormal];
    }
	// Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)fireCurve:(id)sender
{
    [self.hintAnimation cleanAnimation];
    self.hintAnimation = [[MFLHintLabel alloc] createHintAnimationForText:@"The quick brown fox jumps over the lazy dog"
                                                                 withFont:[UIFont boldSystemFontOfSize:22]
                                                              beginningAt:CGPointMake(40, 150)
                                                             displayingAt:CGPointMake(20, self.view.center.y)
                                                                 endingAt:CGPointMake(40, self.view.frame.size.height+200)
                                                             inTargetView:self.view];
    [self.hintAnimation setAnimateOnType:kMFLAnimateOnImplode];
    [self.hintAnimation setAnimateOffType:kMFLAnimateOffCurvedExplode];
    
    [self.hintAnimation setPhaseDelayTimeIn:.05];
    [self.hintAnimation setPhaseDelayTimeOut:.05];
    
    [self.hintAnimation setCharactersToMoveSimultaneouslyIn:self.hintAnimation.stringToDisplay.length/3];
    [self.hintAnimation setCharactersToMoveSimultaneouslyOut:4];
    
    [self.hintAnimation prepareToRun];
    [self.hintAnimation run];
}

- (IBAction)fireExplode:(id)sender
{
    [self.hintAnimation cleanAnimation];
    self.hintAnimation = [[MFLHintLabel alloc] createHintAnimationForText:@"The quick brown fox jumps over the lazy dog"
                                                                 withFont:[UIFont boldSystemFontOfSize:22]
                                                              beginningAt:CGPointMake(20, self.view.center.y)
                                                             displayingAt:CGPointMake(20, self.view.center.y)
                                                                 endingAt:CGPointMake(40, self.view.frame.size.height+200)
                                                             inTargetView:self.view];
    [self.hintAnimation setAnimateOnType:kMFLAnimateOnImplode];
    [self.hintAnimation setAnimateOffType:kMFLAnimateOffExplode];
    
    [self.hintAnimation setPhaseDelayTimeIn:.05];
    [self.hintAnimation setPhaseDelayTimeOut:.05];
    
    [self.hintAnimation setCharactersToMoveSimultaneouslyIn:self.hintAnimation.stringToDisplay.length];
    [self.hintAnimation setCharactersToMoveSimultaneouslyOut:5];
    
    [self.hintAnimation prepareToRun];
    [self.hintAnimation run];
}

- (IBAction)fireLinear:(id)sender
{
    [self.hintAnimation cleanAnimation];
    self.hintAnimation = [[MFLHintLabel alloc] createHintAnimationForText:@"The quick brown fox jumps over the lazy dog"
                                                                 withFont:[UIFont boldSystemFontOfSize:22]
                                                              beginningAt:CGPointMake(40, -200)
                                                             displayingAt:CGPointMake(20, self.view.center.y)
                                                                 endingAt:CGPointMake(40, self.view.frame.size.height+200)
                                                             inTargetView:self.view];
    [self.hintAnimation setAnimateOnType:kMFLAnimateOnLinear];
    [self.hintAnimation setAnimateOffType:kMFLAnimateOffLinear];
    
    [self.hintAnimation setPhaseDelayTimeIn:.05];
    [self.hintAnimation setPhaseDelayTimeOut:.1];
    
    [self.hintAnimation setCharactersToMoveSimultaneouslyIn:3];
    [self.hintAnimation setCharactersToMoveSimultaneouslyOut:2];
    
    [self.hintAnimation prepareToRun];
    [self.hintAnimation run];
}

- (IBAction)fireImplode:(id)sender
{
    [self.hintAnimation cleanAnimation];
    self.hintAnimation = [[MFLHintLabel alloc] createHintAnimationForText:@"The quick brown fox jumps over the lazy dog"
                                                                 withFont:[UIFont boldSystemFontOfSize:22]
                                                              beginningAt:CGPointMake(40, 150)
                                                             displayingAt:CGPointMake(20, self.view.center.y)
                                                                 endingAt:CGPointMake(40, self.view.frame.size.height+200)
                                                             inTargetView:self.view];
    [self.hintAnimation setAnimateOnType:kMFLAnimateOnImplode];
    [self.hintAnimation setAnimateOffType:kMFLAnimateOffExplode];
    
    [self.hintAnimation setPhaseDelayTimeIn:.05];
    [self.hintAnimation setPhaseDelayTimeOut:.05];
    
    [self.hintAnimation setCharactersToMoveSimultaneouslyIn:self.hintAnimation.stringToDisplay.length];
    [self.hintAnimation setCharactersToMoveSimultaneouslyOut:self.hintAnimation.stringToDisplay.length];
    [self.hintAnimation prepareToRun];
    [self.hintAnimation run];
}

- (IBAction)fireSolitare:(id)sender
{
    [self.hintAnimation cleanAnimation];
    self.hintAnimation = [[MFLHintLabel alloc] createHintAnimationForText:@"the lazy dog"
                                                                 withFont:[UIFont boldSystemFontOfSize:22]
                                                              beginningAt:CGPointMake(40, -250)
                                                             displayingAt:CGPointMake(20, self.view.center.y)
                                                                 endingAt:CGPointMake(40, self.view.frame.size.height+200)
                                                             inTargetView:self.view];
    [self.hintAnimation setAnimateOnType:kMFLAnimateOnLinear];
    [self.hintAnimation setAnimateOffType:kMFLAnimateOffSolitare];
    
    [self.hintAnimation setDuration:5];
    
    [self.hintAnimation setPhaseDelayTimeIn:.05];
    [self.hintAnimation setPhaseDelayTimeOut:.05];
    
    [self.hintAnimation setCharactersToMoveSimultaneouslyIn:3];
    [self.hintAnimation setCharactersToMoveSimultaneouslyOut:5];
    
    [self.hintAnimation prepareToRun];
    [self.hintAnimation run];
}

- (IBAction)fireRandomSolitare:(id)sender
{
    [self.hintAnimation cleanAnimation];
    self.hintAnimation = [[MFLHintLabel alloc] createHintAnimationForText:@"the lazy dog"
                                                                 withFont:[UIFont boldSystemFontOfSize:22]
                                                              beginningAt:CGPointMake(40, -250)
                                                             displayingAt:CGPointMake(20, self.view.center.y)
                                                                 endingAt:CGPointMake(40, self.view.frame.size.height+200)
                                                             inTargetView:self.view];
    [self.hintAnimation setAnimateOnType:kMFLAnimateOnLinear];
    [self.hintAnimation setAnimateOffType:kMFLAnimateOffRandomSolitare];
    
    [self.hintAnimation setDuration:5];
    
    [self.hintAnimation setPhaseDelayTimeIn:.05];
    [self.hintAnimation setPhaseDelayTimeOut:.05];
    
    [self.hintAnimation setCharactersToMoveSimultaneouslyIn:3];
    [self.hintAnimation setCharactersToMoveSimultaneouslyOut:5];
    
    [self.hintAnimation prepareToRun];
    [self.hintAnimation run];
}

- (IBAction)fireRandomCurve:(id)sender
{
    [self.hintAnimation cleanAnimation];
    self.hintAnimation = [[MFLHintLabel alloc] createHintAnimationForText:@"The quick brown fox jumps over the lazy dog"
                                                                 withFont:[UIFont boldSystemFontOfSize:22]
                                                              beginningAt:CGPointMake(40, -250)
                                                             displayingAt:CGPointMake(20, self.view.center.y)
                                                                 endingAt:CGPointMake(40, self.view.frame.size.height+200)
                                                             inTargetView:self.view];
    [self.hintAnimation setAnimateOnType:kMFLAnimateOnLinear];
    [self.hintAnimation setAnimateOffType:kMFLAnimateOffRandomCurvedExplode];
    
    [self.hintAnimation setPhaseDelayTimeIn:.05];
    [self.hintAnimation setPhaseDelayTimeOut:.05];
    
    [self.hintAnimation setCharactersToMoveSimultaneouslyIn:3];
    [self.hintAnimation setCharactersToMoveSimultaneouslyOut:5];
    
    [self.hintAnimation prepareToRun];
    [self.hintAnimation run];
}

- (IBAction)fireImplodeFactorStill:(id)sender
{
    [self.hintAnimation cleanAnimation];
    self.hintAnimation = [[MFLHintLabel alloc] createHintAnimationForText:@"The quick brown fox jumps over the lazy dog"
                                                                 withFont:[UIFont boldSystemFontOfSize:22]
                                                              beginningAt:CGPointMake(40, -250)
                                                             displayingAt:CGPointMake(20, self.view.center.y)
                                                                 endingAt:CGPointMake(40, self.view.frame.size.height+200)
                                                             inTargetView:self.view];
    [self.hintAnimation setAnimateOnType:kMFLAnimateOnLinear];
    [self.hintAnimation setAnimateOffType:kMFLAnimateImplodeStill];
    
    [self.hintAnimation setImplodeFrameFactor:2];
    
    [self.hintAnimation setPhaseDelayTimeIn:.05];
    [self.hintAnimation setPhaseDelayTimeOut:.05];
    
    [self.hintAnimation setCharactersToMoveSimultaneouslyIn:3];
    [self.hintAnimation setCharactersToMoveSimultaneouslyOut:5];
    
    [self.hintAnimation prepareToRun];
    [self.hintAnimation run];
}

- (IBAction)fireImplodeFrameStill:(id)sender
{
    [self.hintAnimation cleanAnimation];
    self.hintAnimation = [[MFLHintLabel alloc] createHintAnimationForText:@"The quick brown fox jumps over the lazy dog"
                                                                 withFont:[UIFont boldSystemFontOfSize:22]
                                                              beginningAt:CGPointMake(40, -250)
                                                             displayingAt:CGPointMake(20, self.view.center.y)
                                                                 endingAt:CGPointMake(40, self.view.frame.size.height+200)
                                                             inTargetView:self.view];
    [self.hintAnimation setAnimateOnType:kMFLAnimateOnLinear];
    [self.hintAnimation setAnimateOffType:kMFLAnimateImplodeStill];
    
    [self.hintAnimation setImplodeWithinFrame:self.view.frame];
    
    [self.hintAnimation setPhaseDelayTimeIn:.05];
    [self.hintAnimation setPhaseDelayTimeOut:.05];
    
    [self.hintAnimation setCharactersToMoveSimultaneouslyIn:3];
    [self.hintAnimation setCharactersToMoveSimultaneouslyOut:5];
    
    [self.hintAnimation prepareToRun];
    [self.hintAnimation run];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
