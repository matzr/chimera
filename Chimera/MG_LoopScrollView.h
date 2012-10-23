//
//  MG_LoopScrollView.h
//  Chimera
//
//  Created by Mathieu Gardère on 28/09/12.
//  Copyright (c) 2012 LesBandits.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSMutableArray+Shuffable.h"

@protocol MG_LoopScrollViewDelegate

-(void)selectionChanged:(id)scrollView;

@end


@interface MG_LoopScrollView : UIScrollView<UIScrollViewDelegate> {
    NSMutableArray * _slideImages;
    NSMutableArray * _slideImages_blurred;
    NSMutableArray * _slideImageViews;
    NSMutableArray * _slideImageViews_blurred;
    CGSize _picturesSize;
    CGPoint _picturesOffset;
    int _currentIndex;
    int _currentStartIndex;
    double _currentOffset;
    UITapGestureRecognizer * _tapGestureRecognizer;
}

@property (nonatomic,assign) int currentIndex;
@property (nonatomic,strong) id<MG_LoopScrollViewDelegate> mgdelegate;

-(void)loadPicturesWithPrefix:(NSString*)prefix;
-(void)setPicturesSize:(CGSize)newSize andOffset:(CGPoint)newOffset;
-(void)randomizePosition;

-(void)quickSpin;

@end



