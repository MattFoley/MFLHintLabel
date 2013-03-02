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
@end

@implementation MFLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)fireAnimation:(id)sender
{
    self.hintAnimation = [[MFLHintLabel alloc] createHintAnimationForText:@"The quick brown fox jumps over the lazy dog"
                                                                 withFont:[UIFont boldSystemFontOfSize:22]
                                                              beginningAt:CGPointMake(40, -200)
                                                             displayingAt:CGPointMake(40, self.view.center.y)
                                                                 endingAt:CGPointMake(40, self.view.frame.size.height+200)
                                                             inTargetView:self.view];
    [self.hintAnimation prepareToRun];
    [self.hintAnimation run];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
