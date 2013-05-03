//
//  SettingsViewController.m
//  Chimera
//
//  Created by Mathieu Gardère on 2/05/13.
//  Copyright (c) 2013 LesBandits.com. All rights reserved.
//

#import "SettingsViewController.h"
#import "PaymentProcessor.h"
#import "Preferences.h"

@interface SettingsViewController () {
}

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.soundEffectsSwitch setOnTintColor:[UIColor colorWithRed:.9 green:.743 blue:0 alpha:1]];
    [self.soundEffectsSwitch setTintColor:[UIColor grayColor]];
    [self.backgroundsSoundsSwitch setOnTintColor:[UIColor colorWithRed:.9 green:.743 blue:0 alpha:1]];
    [self.backgroundsSoundsSwitch setTintColor:[UIColor grayColor]];
    [self.shakeForRandomSwitch setOnTintColor:[UIColor colorWithRed:.9 green:.743 blue:0 alpha:1]];
    [self.shakeForRandomSwitch setTintColor:[UIColor grayColor]];
    [self.useExtraAnimalsSwitch setOnTintColor:[UIColor colorWithRed:.9 green:.743 blue:0 alpha:1]];
    [self.useExtraAnimalsSwitch setTintColor:[UIColor grayColor]];
}

- (IBAction)useExtraAnimalsChanged:(id)sender {
    [Preferences instance].extraAnimalsEnabled = self.useExtraAnimalsSwitch.on;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidUnload {
    [self setShakeForRandomSwitch:nil];
    [self setSoundEffectsSwitch:nil];
    [self setBackgroundsSoundsSwitch:nil];
    [self setUseExtraAnimalsSwitch:nil];
    [super viewDidUnload];
}
- (IBAction)shakeForRandomChange:(id)sender {
    [Preferences instance].shakeForRandom = self.shakeForRandomSwitch.on;
}

- (IBAction)soundFxChange:(id)sender {
    [Preferences instance].soundEffectsEnabled = self.soundEffectsSwitch.on;
}

- (IBAction)backgroundSoundsChange:(id)sender {
    [Preferences instance].backgroundSoundsEnabled = self.backgroundsSoundsSwitch.on;
    if (self.backgroundsSoundsSwitch.on) {
        [[AppDelegate instance] startBackgroundSound];
    } else {
        [[AppDelegate instance] stopBackgroundSound];
    }
}

- (IBAction)purchase:(id)sender {
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[AppDelegate instance].tracker trackView:@"Settings"];
    
    self.shakeForRandomSwitch.on = [Preferences instance].shakeForRandom;
    self.soundEffectsSwitch.on = [Preferences instance].soundEffectsEnabled;
    self.backgroundsSoundsSwitch.on = [Preferences instance].backgroundSoundsEnabled;
    self.useExtraAnimalsSwitch.on = [Preferences instance].extraAnimalsEnabled;
}
@end
