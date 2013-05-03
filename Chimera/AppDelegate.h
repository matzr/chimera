//
//  AppDelegate.h
//  Chimera
//
//  Created by Mathieu Gardère on 8/09/12.
//  Copyright (c) 2012 LesBandits.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "PaymentProcessor.h"
#import "GAITracker.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, AVAudioPlayerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, readonly) PaymentProcessor *paymentProcessor;
@property (strong, strong) id<GAITracker> tracker;

+(AppDelegate*) instance;

-(void)playSweepingSound;
-(void)playCheeringSound;
-(void)playRandomizerSound;

-(void)startBackgroundSound;
-(void)stopBackgroundSound;


@end
