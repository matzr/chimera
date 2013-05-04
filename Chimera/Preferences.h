//
//  Preferences.h
//  Chimera
//
//  Created by Mathieu Gardère on 3/05/13.
//  Copyright (c) 2013 LesBandits.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Preferences : NSObject

+(Preferences*)instance;

@property (nonatomic,assign) BOOL backgroundSoundsEnabled;
@property (nonatomic,assign) BOOL soundEffectsEnabled;
@property (nonatomic,assign) BOOL shakeForRandom;
@property (nonatomic,assign) BOOL extraAnimalsEnabled;
@property (nonatomic,assign) BOOL hasPurchasedPack1;

@end
