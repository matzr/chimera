//
//  MG_LoopScrollView.h
//  Chimera
//
//  Created by Mathieu Gardère on 28/09/12.
//  Copyright (c) 2012 LesBandits.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MG_LoopScrollView : UIScrollView<UIScrollViewDelegate> {
    NSMutableArray * _slideImages;
    NSMutableArray * _slideImages_blurred;
    CGSize _picturesSize;
    CGPoint _picturesOffset;
    int _currentIndex;
    double _currentOffset;
    UITapGestureRecognizer * _tapGestureRecognizer;
}

@property (nonatomic,assign) int currentIndex;

-(void)loadPicturesWithPrefix:(NSString*)prefix;
-(void)setPicturesSize:(CGSize)newSize andOffset:(CGPoint)newOffset;
-(void)randomizePosition;

@end
