//
//  MainViewController.h
//  Chimera
//
//  Created by Mathieu Gardère on 8/09/12.
//  Copyright (c) 2012 LesBandits.com. All rights reserved.
//

#import "FlipsideViewController.h"
#import "UILoopScrollView.h"
#import "MG_LoopScrollView.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, UIPopoverControllerDelegate>

@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;

@property (strong, nonatomic) IBOutlet MG_LoopScrollView *topLoopScrollView;
@property (strong, nonatomic) IBOutlet MG_LoopScrollView *middleLoopScrollView;
@property (strong, nonatomic) IBOutlet MG_LoopScrollView *bottomLoopScrollView;

@end
