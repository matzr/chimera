//
//  MG_LoopScrollView.m
//  Chimera
//
//  Created by Mathieu Gardère on 28/09/12.
//  Copyright (c) 2012 LesBandits.com. All rights reserved.
//

#import "MG_LoopScrollView.h"

@interface MG_LoopScrollView()

-(void)initContent;
-(int)getArrayIndexForPositionIndex:(int)positionIndex;
-(int)numberOfPicturesBefore;

@end

@implementation MG_LoopScrollView

-(void)internalInit {
    _slideImages = [NSMutableArray array];
    _slideImages_blurred = [NSMutableArray array];
    self.delegate = self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self internalInit];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self internalInit];
    }
    return self;
}


-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    //TODO: substitute blurred images to normal ones
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"%f", scrollView.contentOffset.x);
    if (scrollView.contentOffset.x > _currentOffset) {
        NSLog(@"Moved to next");
        [self wentToNext];
    }
    if (scrollView.contentOffset.x < _currentOffset) {
        NSLog(@"Moved to previous");
        [self wentToPrevious];
    }
    
    _currentOffset = scrollView.contentOffset.x;
    //TODO: substitute normal images to blurred ones
    //TODO: re-arrange pictures - reset index/offset
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(void)initContent {
    double totalContentWidth = 0;
    double height = 0;
    UIImageView *imageView;
    double currentX = 0;
    
    if ([_slideImages count]) {
        if (!(_picturesSize.height)) {
            _picturesSize = ((UIImage*)[_slideImages objectAtIndex:0]).size;
        }
        height = self.frame.size.height;
    }

    totalContentWidth += _picturesSize.width * [_slideImages count];
    
    self.contentSize = CGSizeMake(totalContentWidth, height);
    
    for (int i = [self.subviews count] - 1; i >= 0; i -= 1) {
        [((UIView*)([self.subviews objectAtIndex:i])) removeFromSuperview];
    }
    
    for (int i = 0; i < [_slideImages count]; i += 1) {
        imageView = [[UIImageView alloc] initWithImage:[MG_LoopScrollView imageWithImage:[_slideImages objectAtIndex:[self getArrayIndexForPositionIndex:i-[self numberOfPicturesBefore]]] scaledToSize:_picturesSize]];
        imageView.frame = CGRectMake(currentX, _picturesOffset.y, imageView.frame.size.width, imageView.frame.size.height);
        [self addSubview:imageView];
        currentX += imageView.frame.size.width;
    }
    
    _currentOffset = [self numberOfPicturesBefore] * _picturesSize.width;
    [self setContentOffset:CGPointMake(_currentOffset, 0) animated:NO];
}

-(void)loadPicturesWithPrefix:(NSString*)prefix {
    UIImage *image;
    UIImage *image_blurred;
    NSString *filenameSuffix;
    NSString *filename;
    NSString *filename_blurred;
    NSString *format = [NSString stringWithFormat:@"%%0%dd", 4];
    int i = 0;
    do {
        filenameSuffix = [NSString stringWithFormat:format, ++i];
        filename = [NSString stringWithFormat:@"%@_%@", prefix, filenameSuffix];
        filename_blurred = [NSString stringWithFormat:@"%@_blur_%@", prefix, filenameSuffix];
        image = [UIImage imageNamed:filename];
        image_blurred = [UIImage imageNamed:filename_blurred];
        if (image && image_blurred) {
            [_slideImages addObject:image];
            [_slideImages_blurred addObject:image_blurred];
        }
    } while (image);
    
    [self initContent];
}

-(void)setPicturesSize:(CGSize)newSize andOffset:(CGPoint)newOffset {
    _picturesSize = newSize;
    _picturesOffset = newOffset;
    [self initContent];
}

-(void)setCurrentIndex:(int)newIndex {
    _currentIndex = newIndex;
    //TODO: scroll to the appropriate position
}

-(int)currentIndex {
    return _currentIndex;
}

-(int)centerIndex {
    return (int)([_slideImages count] / 2);
}

-(int)numberOfPicturesBefore {
    return [_slideImages count] - [self centerIndex];
}

-(double)getCenterOffset {
    return _picturesSize.width * [self numberOfPicturesBefore];
}

-(void)wentToNext {
    if (++_currentIndex == [_slideImages count]) {
        _currentIndex = 0;
    }
    if (self.contentOffset.x == _picturesSize.width * ([_slideImages count] -1)) {
        [self initContent];
    }
}

-(void)wentToPrevious {
    if (--_currentIndex == -1) {
        _currentIndex = [_slideImages count] - 1;
    }
    if (!(self.contentOffset.x)) {
        [self initContent];
    }
}

-(int)getArrayIndexForPositionIndex:(int)positionIndex {
    positionIndex += _currentIndex;
    if (positionIndex < 0) {
        return [_slideImages count] + positionIndex;
    } else if (positionIndex >= [_slideImages count]){
        return positionIndex - [_slideImages count];
    } else {
        return positionIndex;
    }
}

@end
