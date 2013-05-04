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
                                     [NSSet setWithObject: @"CHIMERA_IMAGEPACK_001"]];
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
        if ([transaction.payment.productIdentifier isEqualToString:@"CHIMERA_IMAGEPACK_001"] && transaction.transactionState == SKPaymentTransactionStatePurchased) {
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
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

@end
