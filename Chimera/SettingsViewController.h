//
//  SettingsViewController.h
//  Chimera
//
//  Created by Mathieu Gardère on 2/05/13.
//  Copyright (c) 2013 LesBandits.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController

- (IBAction)back:(id)sender;

@property (weak, nonatomic) IBOutlet UISwitch *shakeForRandomSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *soundEffectsSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *backgroundsSoundsSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *useExtraAnimalsSwitch;
- (IBAction)shakeForRandomChange:(id)sender;
- (IBAction)soundFxChange:(id)sender;
- (IBAction)backgroundSoundsChange:(id)sender;

- (IBAction)purchase:(id)sender;
@end
