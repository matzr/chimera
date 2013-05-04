//
//  PurchaseScreenViewController.h
//  Chimera
//
//  Created by Mathieu Gardère on 4/05/13.
//  Copyright (c) 2013 LesBandits.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PurchaseScreenViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *purchaseMessageLabel;
- (IBAction)purchasePack1:(id)sender;
- (IBAction)back:(id)sender;

@end
