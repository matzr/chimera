//
//  AppDelegate.m
//  Chimera
//
//  Created by Mathieu Gardère on 8/09/12.
//  Copyright (c) 2012 LesBandits.com. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate() {
    AVAudioPlayer *backgroundMusicPlayer;
    AVAudioPlayer *sweepSoundPlayer;
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    application.applicationSupportsShakeToEdit = YES;
    
    backgroundMusicPlayer = [self getMusicPlayerForPathForResource:@"dans_la_jungle" withExtension:@"mp3"];
    backgroundMusicPlayer.numberOfLoops = -1;
    
    sweepSoundPlayer = [self getMusicPlayerForPathForResource:@"whip_whoosh_large_dowel_rod" withExtension:@"mp3"];
    sweepSoundPlayer.numberOfLoops = 1;
    
    // start of your application:didFinishLaunchingWithOptions // ...
    [TestFlight takeOff:@"758ff72b-8faf-4a51-a945-9eced5c3276c"];
    // The rest of your application:didFinishLaunchingWithOptions method// ...

    
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
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [backgroundMusicPlayer play];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)playSweepingSound {
    [sweepSoundPlayer stop];
    [sweepSoundPlayer play];
}

@end
