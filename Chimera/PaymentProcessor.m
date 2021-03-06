//
//  PaymentProcessor.m
//  Chimera
//
//  Created by Mathieu Gardère on 1/05/13.
//  Copyright (c) 2013 LesBandits.com. All rights reserved.
//

#import "PaymentProcessor.h"

@implementation PaymentProcessor


-(id)init {
    self = [super init];
    if (self) {
        self.products = nil;
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}

-(void)requestProductDetails {
    if ([SKPaymentQueue canMakePayments]) {
        SKProductsRequest *request= [[SKProductsRequest alloc]
                                     initWithProductIdentifiers:
                                     [NSSet setWithObject: @"WILDSWIPE_PACK001"]];
        request.delegate = self;
        [request start];
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [[NSNotificationCenter defaultCenter] postNotificationName:@"purchaseSucceeded" object:self];
                [[AppDelegate instance].tracker trackEventWithCategory:@"Purchase" withAction:@"newPurchase" withLabel:nil withValue:nil];
                NSLog(@"purchased");
                break;
            case SKPaymentTransactionStateFailed:
                [[NSNotificationCenter defaultCenter] postNotificationName:@"purchaseFailed" object:self];
                NSLog(@"failed");
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"restored");
                break;
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"purchasing");
                break;
            default:
                break;
        }
    }
}

-(void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error {
    NSLog(@"-(void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error {");
}

-(void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
    NSLog(@"-(void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {");
    for (SKPaymentTransaction *transaction in [queue transactions]) {
        if ([transaction.payment.productIdentifier isEqualToString:@"WILDSWIPE_PACK001"] && ((transaction.transactionState == SKPaymentTransactionStatePurchased)|| (transaction.transactionState == SKPaymentTransactionStateRestored))) {
            [[AppDelegate instance].tracker trackEventWithCategory:@"Purchase" withAction:@"restoredPurchase" withLabel:nil withValue:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"purchaseSucceeded" object:self];
        }
    }
}

-(void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions {
    NSLog(@"-(void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions {");
}

-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    self.products = response.products;
}

-(void)purchasePack1 {
    SKProduct *selectedProduct = [self.products objectAtIndex:0];
    SKPayment *payment = [SKPayment paymentWithProduct:selectedProduct];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

-(void)restoreTransactions {
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

@end
