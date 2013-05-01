//
//  PaymentProcessor.h
//  Chimera
//
//  Created by Mathieu Gardère on 1/05/13.
//  Copyright (c) 2013 LesBandits.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaymentProcessor : NSObject<SKPaymentTransactionObserver, SKProductsRequestDelegate>

@property (nonatomic,strong) NSArray* products;

-(void)requestProductDetails;
-(void)purchasePack1;

@end
