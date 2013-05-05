//
//  PurchaseScreenViewController.m
//  Chimera
//
//  Created by Mathieu Gardère on 4/05/13.
//  Copyright (c) 2013 LesBandits.com. All rights reserved.
//

#import "PurchaseScreenViewController.h"
#import "Preferences.h"

@interface PurchaseScreenViewController ()

@end

@implementation PurchaseScreenViewController

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchaseSucceeded:) name:@"purchaseSucceeded" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchaseFailed:) name:@"purchaseFailed" object:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    SKProduct *pack1 = [[AppDelegate instance].paymentProcessor.products objectAtIndex:0];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setLocale:[pack1 priceLocale]];
    NSString *price = [formatter stringFromNumber:[pack1 price]];
    [[AppDelegate instance].tracker trackView:@"Purchase"];
    self.purchaseMessageLabel.text = [self.purchaseMessageLabel.text stringByReplacingOccurrencesOfString:@"..." withString:price];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setPurchaseMessageLabel:nil];
    [super viewDidUnload];
}

- (IBAction)purchasePack1:(id)sender {
    [[AppDelegate instance].paymentProcessor purchasePack1];
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (IBAction)back:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}


-(void)purchaseFailed:(NSNotification*)notification {
}

-(void)purchaseSucceeded:(NSNotification*)notification {
    [Preferences instance].hasPurchasedPack1 = YES;
    [Preferences instance].extraAnimalsEnabled = YES;
    [self dismissModalViewControllerAnimated:YES];
}

@end
