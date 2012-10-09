//
//  MG_LoopScrollView.m
//  Chimera
//
//  Created by Mathieu Gardère on 28/09/12.
//  Copyright (c) 2012 LesBandits.com. All rights reserved.
//

#import "MG_LoopScrollView.h"

@interface MG_LoopScrollView()

@property (nonatomic, strong) UIView* normalImagesContainer;
@property (nonatomic, strong) UIView* blurredImagesContainer;

-(void)initContent;
-(int)getArrayIndexForPositionIndex:(int)positionIndex;
-(int)numberOfPicturesBefore;
-(void)blur;
-(void)unblur;

@end

@implementation MG_LoopScrollView

@synthesize normalImagesContainer;
@synthesize blurredImagesContainer;

-(void)internalInit {
    _slideImages = [NSMutableArray array];
    _slideImages_blurred = [NSMutableArray array];
    self.normalImagesContainer = [[UIView alloc]init];
    self.blurredImagesContainer = [[UIView alloc]init];
    [self addSubview:self.normalImagesContainer];
    [self addSubview:self.blurredImagesContainer];
    self.normalImagesContainer.alpha = 1;
    self.blurredImagesContainer.alpha = 0;
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapScrollView:)];
    [self addGestureRecognizer:_tapGestureRecognizer];
    self.delegate = self;
    [self setShowsHorizontalScrollIndicator:NO];
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

-(void)blur {
    [UIView animateWithDuration:.15 animations:^{
        self.normalImagesContainer.alpha = 0.0;
        self.blurredImagesContainer.alpha = 1.0;
    }];
}

-(void)unblur {
    [UIView animateWithDuration:.15 animations:^{
        self.normalImagesContainer.alpha = 1.0;
        self.blurredImagesContainer.alpha = 0.0;
    }];
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    [self blur];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x > _currentOffset) {
        [self wentToNext];
    }
    if (scrollView.contentOffset.x < _currentOffset) {
        [self wentToPrevious];
    }
    
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
    
    CGRect frame = CGRectMake(0, 0, totalContentWidth, height);
    self.contentSize = CGSizeMake(totalContentWidth, height);
    self.normalImagesContainer.frame = frame;
    self.blurredImagesContainer.frame = frame;

    
    for (int i = [self.normalImagesContainer.subviews count] - 1; i >= 0; i -= 1) {
        [((UIView*)([self.normalImagesContainer.subviews objectAtIndex:i])) removeFromSuperview];
    }
    
    for (int i = [self.blurredImagesContainer.subviews count] - 1; i >= 0; i -= 1) {
        [((UIView*)([self.blurredImagesContainer.subviews objectAtIndex:i])) removeFromSuperview];
    }
    
    for (int i = 0; i < [_slideImages count]; i += 1) {
        imageView = [[UIImageView alloc] initWithImage:[MG_LoopScrollView imageWithImage:[_slideImages objectAtIndex:[self getArrayIndexForPositionIndex:i-[self numberOfPicturesBefore]]] scaledToSize:_picturesSize]];
        imageView.frame = CGRectMake(currentX, _picturesOffset.y, imageView.frame.size.width, imageView.frame.size.height);
        [self.normalImagesContainer addSubview:imageView];
        imageView = [[UIImageView alloc] initWithImage:[MG_LoopScrollView imageWithImage:[_slideImages_blurred objectAtIndex:[self getArrayIndexForPositionIndex:i-[self numberOfPicturesBefore]]] scaledToSize:_picturesSize]];
        imageView.frame = CGRectMake(currentX, _picturesOffset.y, imageView.frame.size.width, imageView.frame.size.height);
        [self.blurredImagesContainer addSubview:imageView];
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
    [self initContent];
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
    _currentOffset = self.contentOffset.x;
    [self unblur];
}

-(void)wentToPrevious {
    if (--_currentIndex == -1) {
        _currentIndex = [_slideImages count] - 1;
    }
    if (!(self.contentOffset.x)) {
        [self initContent];
    }
    _currentOffset = self.contentOffset.x;
    [self unblur];
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

-(void)randomizePosition {
    int randNum = arc4random_uniform([_slideImages count]);
    self.currentIndex = randNum;
}

-(void)tapScrollView:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint touchLocation = [gestureRecognizer locationOfTouch:0 inView:self];
    [self blur];
    if (touchLocation.x - self.contentOffset.x < self.frame.size.width / 2) {
        [self scrollRectToVisible:CGRectMake(self.contentOffset.x - self.frame.size.width, 0, self.frame.size.width, self.frame.size.height) animated:YES];
        [self performSelector:@selector(wentToPrevious) withObject:self afterDelay:.5];
    } else {
        [self scrollRectToVisible:CGRectMake(self.contentOffset.x + self.frame.size.width, 0, self.frame.size.width, self.frame.size.height) animated:YES];
        [self performSelector:@selector(wentToNext) withObject:self afterDelay:.5];
    }
}

@end
