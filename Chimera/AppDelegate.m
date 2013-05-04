//
//  AppDelegate.m
//  Chimera
//
//  Created by Mathieu Gardère on 8/09/12.
//  Copyright (c) 2012 LesBandits.com. All rights reserved.
//

#import "AppDelegate.h"
#import "Appirater.h"
#import "Preferences.h"
#import <Crashlytics/Crashlytics.h>

static AppDelegate *_instance;

@interface AppDelegate() {
    AVAudioPlayer *backgroundMusicPlayer;
    AVAudioPlayer *sweepSoundPlayer;
    AVAudioPlayer *cheeringSoundPlayer;
    AVAudioPlayer *randomizerSoundPlayer;
    PaymentProcessor *_paymentProcessor;
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _instance = self;
    
    _paymentProcessor = [[PaymentProcessor alloc] init];
    
    application.applicationSupportsShakeToEdit = YES;
    
    backgroundMusicPlayer = [self getMusicPlayerForPathForResource:@"dans_la_jungle" withExtension:@"mp3"];
    backgroundMusicPlayer.numberOfLoops = -1;
    
    sweepSoundPlayer = [self getMusicPlayerForPathForResource:@"whip_whoosh_large_dowel_rod" withExtension:@"mp3"];
    sweepSoundPlayer.numberOfLoops = 0;
    
    cheeringSoundPlayer = [self getMusicPlayerForPathForResource:@"cheering" withExtension:@"mp3"];
    cheeringSoundPlayer.numberOfLoops = 0;
    
    randomizerSoundPlayer = [self getMusicPlayerForPathForResource:@"random" withExtension:@"mp3"];
    randomizerSoundPlayer.numberOfLoops = 0;
    
    // start of your application:didFinishLaunchingWithOptions // ...
    [TestFlight takeOff:@"758ff72b-8faf-4a51-a945-9eced5c3276c"];
    // The rest of your application:didFinishLaunchingWithOptions method// ...

    [Crashlytics startWithAPIKey:@"7e3a885f3571e836c73ceff201073edd359e84d5"];
    
    
    [Appirater setAppId:@"643073397"];
    [Appirater setDaysUntilPrompt:2];
    [Appirater setUsesUntilPrompt:10];
    [Appirater setSignificantEventsUntilPrompt:-1];
    [Appirater setTimeBeforeReminding:2];
    [Appirater appLaunched:YES];
    
    [self.paymentProcessor requestProductDetails];


    [GAI sharedInstance].debug = NO;
    [GAI sharedInstance].optOut = NO;
    [GAI sharedInstance].dispatchInterval = 5;
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    self.tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-40622546-1"];
    [self.tracker setSessionStart:YES];

    return YES;
}

-(AVAudioPlayer*)getMusicPlayerForPathForResource:(NSString *)fileName withExtension:(NSString*)fileType {
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:fileName ofType:fileType];
    AVAudioPlayer *audiolayer =[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundPath] error:nil];
    audiolayer.delegate = self;
    [audiolayer prepareToPlay];
    return  audiolayer;
}

							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [backgroundMusicPlayer stop];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [self.paymentProcessor requestProductDetails];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if ([Preferences instance].backgroundSoundsEnabled) {
        [backgroundMusicPlayer play];
    }
    [Appirater appEnteredForeground:YES];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)playSweepingSound {
    if ([Preferences instance].soundEffectsEnabled) {
        [sweepSoundPlayer stop];
        [sweepSoundPlayer play];
    }
}

-(void)playCheeringSound {
    if ([Preferences instance].soundEffectsEnabled) {
        [cheeringSoundPlayer stop];
        [cheeringSoundPlayer play];
    }
}

-(void)playRandomizerSound {
    if ([Preferences instance].soundEffectsEnabled) {
        [randomizerSoundPlayer stop];
        [randomizerSoundPlayer play];
    }
}

+(AppDelegate *)instance {
    return _instance;
}

-(PaymentProcessor *)paymentProcessor {
    return _paymentProcessor;
}

-(void)startBackgroundSound {
    [backgroundMusicPlayer play];
}

-(void)stopBackgroundSound {
    [backgroundMusicPlayer stop];
}

@end
