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
#import "PurchaseScreenViewController.h"

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
    if (![Preferences instance].hasPurchasedPack1)  {
        //TODO: check the AppStore to see if the user is entitled
        [Preferences instance].extraAnimalsEnabled = NO;
        
        if (self.useExtraAnimalsSwitch.on) {
            [[AppDelegate instance].paymentProcessor requestProductDetails];
            if ((![AppDelegate instance].paymentProcessor.products) || ([[AppDelegate instance].paymentProcessor.products count] == 0)) {
                self.useExtraAnimalsSwitch.on = NO;
                [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Cannot access the AppStore. Please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                return;
            }
        }
        self.useExtraAnimalsSwitch.on = NO;
        PurchaseScreenViewController *settingsVc = [self.storyboard instantiateViewControllerWithIdentifier:@"PurchaseScreen"];
        [self presentViewController:settingsVc animated:YES completion:nil];
    } else {
        [Preferences instance].extraAnimalsEnabled = self.useExtraAnimalsSwitch.on;
        [[AppDelegate instance].tracker trackEventWithCategory:@"UserAction" withAction:@"Settings" withLabel:@"extraAnimals" withValue:@(self.useExtraAnimalsSwitch.on)];
    }
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
    [[AppDelegate instance].tracker trackEventWithCategory:@"UserAction" withAction:@"Settings" withLabel:@"shakeForRandom" withValue:@(self.shakeForRandomSwitch.on)];
}

- (IBAction)soundFxChange:(id)sender {
    [Preferences instance].soundEffectsEnabled = self.soundEffectsSwitch.on;
    [[AppDelegate instance].tracker trackEventWithCategory:@"UserAction" withAction:@"Settings" withLabel:@"soundFx" withValue:@(self.soundEffectsSwitch.on)];
}

- (IBAction)backgroundSoundsChange:(id)sender {
    [Preferences instance].backgroundSoundsEnabled = self.backgroundsSoundsSwitch.on;
    [[AppDelegate instance].tracker trackEventWithCategory:@"UserAction" withAction:@"Settings" withLabel:@"backgroundSounds" withValue:@(self.backgroundsSoundsSwitch.on)];
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
