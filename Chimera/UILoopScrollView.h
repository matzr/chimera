//
//  UILoopScrollView.h
//  Chimera
//
//  Created by Mathieu Gardère on 20/09/12.
//  Copyright (c) 2012 LesBandits.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILoopScrollView : UIScrollView<UIScrollViewDelegate> {
    NSString * _filenamePrefix;
    NSMutableArray *_slideImages;
    int _offset;
}

-(void)initPictures: (NSString*)prefix withVerticalOffset:(int)offset;
-(void)scrollToPreviousPage;
-(void)scrollToNextPage;

@end
