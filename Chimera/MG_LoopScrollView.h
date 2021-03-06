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
    NSMutableArray * _slideImageViews;
    CGSize _picturesSize;
    CGPoint _picturesOffset;
    int _currentIndex;
    int _currentStartIndex;
    double _currentOffset;
    UITapGestureRecognizer * _tapGestureRecognizer;
}

@property (nonatomic,strong) NSString *name;
@property (nonatomic,assign) int currentIndex;
@property (nonatomic,readonly) int currentAnimalId;
@property (nonatomic,strong) id<MG_LoopScrollViewDelegate> mgdelegate;
@property (nonatomic,strong) NSArray *pictureIndexes;
@property (nonatomic,assign) BOOL isAutoSpinning;

-(void)reset;
-(void)loadPicturesWithPrefix:(NSString*)prefix;
-(void)setPicturesSize:(CGSize)newSize andOffset:(CGPoint)newOffset;
-(void)randomizePosition;

-(void)quickSpin;

@end



