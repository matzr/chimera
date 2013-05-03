//
//  Preferences.m
//  Chimera
//
//  Created by Mathieu Gardère on 3/05/13.
//  Copyright (c) 2013 LesBandits.com. All rights reserved.
//

#import "Preferences.h"


static Preferences *_instance;

@implementation Preferences

NSString * kShakeForRandom = @"ShakeForRandom";
NSString * kExtraAnimals = @"ExtraAnimals";
NSString * kBackgroundSounds = @"BackgroundSounds";
NSString * kSoundEffects = @"SoundEffects";

-(id)init {
    self = [super init];
    if (self) {
        _instance = self;
    }
    return self;
}

+(Preferences *)instance {
    if (!_instance) {
        _instance = [[Preferences alloc] init];
    }
    return _instance;
}

-(BOOL)extraAnimalsEnabled {
    return [self boolForKey:kExtraAnimals withDefault:NO];
}

-(BOOL)backgroundSoundsEnabled {
    return [self boolForKey:kBackgroundSounds withDefault:YES];
}

-(BOOL)soundEffectsEnabled {
    return [self boolForKey:kSoundEffects withDefault:YES];
}

-(BOOL)shakeForRandom {
    return [self boolForKey:kShakeForRandom withDefault:YES];
}

-(BOOL)boolForKey:(NSString *)key withDefault:(BOOL)defaultValue{
    id value = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (value) {
        return [value boolValue];
    } else {
        return defaultValue;
    }
}

-(void)setValue:(id)value forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)setExtraAnimalsEnabled:(BOOL)extraAnimalsEnabled {
    [self setValue:@(extraAnimalsEnabled) forKey:kExtraAnimals];
}

-(void)setBackgroundSoundsEnabled:(BOOL)backgroundSoundsEnabled {
    [self setValue:@(backgroundSoundsEnabled) forKey:kBackgroundSounds];
}

-(void)setSoundEffectsEnabled:(BOOL)soundEffectsEnabled {
    [self setValue:@(soundEffectsEnabled) forKey:kSoundEffects];
}

-(void)setShakeForRandom:(BOOL)shakeForRandom {
    [self setValue:@(shakeForRandom) forKey:kShakeForRandom];
}

@end
