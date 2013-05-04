//
//  MG_LoopScrollView.m
//  Chimera
//
//  Created by Mathieu Gardère on 28/09/12.
//  Copyright (c) 2012 LesBandits.com. All rights reserved.
//

#import "MG_LoopScrollView.h"
#import "AppDelegate.h"

@interface MG_LoopScrollView() {
    NSString *_prefix;
}

@property (nonatomic, strong) UIView* normalImagesContainer;
@property (nonatomic, strong) NSMutableArray *shuffledIndexes;


enum ScrollDirection {
    kLeft,
    kRight
};

-(void)initContent;
-(void)rearrangeContent;
-(int)getArrayIndexForPositionIndex:(int)positionIndex;
-(int)numberOfPicturesBefore;
-(void)recursiveScrollWithDirection:(enum ScrollDirection)direction timeLeft:(NSTimeInterval)timeLeft posLeft:(int)posLeft;

@end

@implementation MG_LoopScrollView

@synthesize normalImagesContainer;
@synthesize mgdelegate;

-(void)reset {
    _slideImages = [NSMutableArray array];
    _slideImageViews = [NSMutableArray array];
    for (UIView *view in self.normalImagesContainer.subviews) {
        [view removeFromSuperview];
    }
    self.normalImagesContainer.alpha = 1;
    _currentStartIndex = 0;
    _currentOffset = 0;
    _currentIndex = 0;
}

-(void)internalInit {
    self.normalImagesContainer = [[UIView alloc]init];
    [self addSubview:self.normalImagesContainer];
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapScrollView:)];
    [self addGestureRecognizer:_tapGestureRecognizer];
    self.delegate = self;
    [self setShowsHorizontalScrollIndicator:NO];
    [self reset];
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


-(void)checkPosition {
    if (!(self.contentOffset.x)) {
        _currentIndex = 0;
        [self rearrangeContent];
    } else if (self.contentOffset.x == _picturesSize.width * ([_slideImages count] -1)) {
        _currentIndex = [_slideImages count] - 1;
        [self rearrangeContent];
    }
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    self.userInteractionEnabled = NO;
    [UIViewController cancelPreviousPerformRequestsWithTarget:self selector:@selector(checkPosition) object:nil];
    [self performSelector:@selector(checkPosition) withObject:nil afterDelay:.8];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.userInteractionEnabled = YES;
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

    [_slideImageViews removeAllObjects];
    
    for (int i = [self.normalImagesContainer.subviews count] - 1; i >= 0; i -= 1) {
        [((UIView*)([self.normalImagesContainer.subviews objectAtIndex:i])) removeFromSuperview];
    }
    
    for (int i = 0; i < [_slideImages count]; i += 1) {
        imageView = [[UIImageView alloc] initWithImage:[MG_LoopScrollView imageWithImage:[_slideImages objectAtIndex:[self getArrayIndexForPositionIndex:i-[self numberOfPicturesBefore]]] scaledToSize:_picturesSize]];
        [self.normalImagesContainer addSubview:imageView];
        [_slideImageViews addObject:imageView];
    }
    
    [self rearrangeContent];
}

-(void)loadPicturesWithPrefix:(NSString*)prefix {
    UIImage *image;
    NSString *filenameSuffix;
    NSString *filename;
    NSString *format = [NSString stringWithFormat:@"%%0%dd", 4];
    NSMutableArray *tempNormal = [NSMutableArray array];
    self.shuffledIndexes = [NSMutableArray array];
    _prefix = prefix;
    int i = 0;
    for (NSNumber *pictureIndex in self.pictureIndexes) {
        filenameSuffix = [NSString stringWithFormat:format, pictureIndex.intValue];
        filename = [NSString stringWithFormat:@"%@_%@", prefix, filenameSuffix];
        image = [UIImage imageNamed:filename];
        if (image) {
            [self.shuffledIndexes addObject:[NSNumber numberWithInt:i++]];
            [_slideImages addObject:image];
        }
    }
    [self.shuffledIndexes shuffle];
    
    for (i = 0; i < [self.shuffledIndexes count]; i += 1) {
        int indexToPick = [self.shuffledIndexes[i] intValue];
        tempNormal[i] = _slideImages[indexToPick];
    }
    
    _slideImages = tempNormal;
    [self initContent];
}

-(void)setPicturesSize:(CGSize)newSize andOffset:(CGPoint)newOffset {
    _picturesSize = newSize;
    _picturesOffset = newOffset;
    [self initContent];
}

-(void)setCurrentIndex:(int)newIndex {
    _currentIndex = newIndex;
    [self rearrangeContent];
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
        [self rearrangeContent];
    }
    _currentOffset = self.contentOffset.x;
    
    if (self.delegate) {
        [self.mgdelegate selectionChanged:self];
    }
}

-(void)wentToPrevious {
    if (--_currentIndex == -1) {
        _currentIndex = [_slideImages count] - 1;
    }
    if (!(self.contentOffset.x)) {
        [self rearrangeContent];
    }
    _currentOffset = self.contentOffset.x;
    
    if (self.delegate) {
        [self.mgdelegate selectionChanged:self];
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

-(void)randomizePosition {
    int randNum = arc4random_uniform([_slideImages count]);
    self.currentIndex = randNum;
}

- (void)scrollLeft {
    [self scrollRectToVisible:CGRectMake(self.contentOffset.x - self.frame.size.width, 0, self.frame.size.width, self.frame.size.height) animated:YES];
    [self performSelector:@selector(wentToPrevious) withObject:self afterDelay:.5];
}

- (void)moveLeft {
    [self scrollRectToVisible:CGRectMake(self.contentOffset.x - self.frame.size.width, 0, self.frame.size.width, self.frame.size.height) animated:NO];
    [self wentToPrevious];
}

- (void)scrollRight {
    [self scrollRectToVisible:CGRectMake(self.contentOffset.x + self.frame.size.width, 0, self.frame.size.width, self.frame.size.height) animated:YES];
    [self performSelector:@selector(wentToNext) withObject:self afterDelay:.5];
}

- (void)moveRight {
    [self scrollRectToVisible:CGRectMake(self.contentOffset.x + self.frame.size.width, 0, self.frame.size.width, self.frame.size.height) animated:NO];
    [self wentToNext];
}

-(void)tapScrollView:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint touchLocation = [gestureRecognizer locationOfTouch:0 inView:self];
    if (touchLocation.x - self.contentOffset.x < self.frame.size.width / 2) {
        [self scrollLeft];
    } else {
        [self scrollRight];
    }
}

-(void)rearrangeContent {
    double currentX = 0;
    UIImageView *imageView;
    CGRect frame;
 
    for (int i = 0; i < [_slideImages count]; i += 1) {
        imageView = [_slideImageViews objectAtIndex:[self getArrayIndexForPositionIndex:i-[self numberOfPicturesBefore]]];
        frame = CGRectMake(currentX, _picturesOffset.y, imageView.frame.size.width, imageView.frame.size.height);
        
        //Reposition normal image
        imageView.frame = frame;

        currentX += imageView.frame.size.width;
    }

    _currentOffset = [self numberOfPicturesBefore] * _picturesSize.width;
    [self setContentOffset:CGPointMake(_currentOffset, 0) animated:NO];
}

-(void)setCorrectIndex {
    _currentIndex = (int)(self.contentOffset.x / (self.frame.size.width)?self.frame.size.width:1);
}

-(void)quickSpin {
    if (self.isAutoSpinning) {
        return;
    }
    self.userInteractionEnabled = NO;
    self.isAutoSpinning = YES;
    enum ScrollDirection scrollDir = (arc4random_uniform(2))?kRight:kLeft;
    usleep(1000);
    int numberOfPosToScroll = 10 + arc4random_uniform(16);
    NSLog(@"%@ will spin to the %@ for %d position(s)", self.name, (scrollDir == kLeft)?@"left":@"right", numberOfPosToScroll);
    NSString *format = [NSString stringWithFormat:@"%%0%dd", 4];
    int totalWidth = numberOfPosToScroll * _picturesSize.width;
    int x = (scrollDir == kRight) ? 0 : -((numberOfPosToScroll - 1) * _picturesSize.width);
    x += _currentOffset;
    UIView *overlay = [[UIView alloc]initWithFrame:CGRectMake(x, 0, totalWidth, _picturesSize.height)];
    overlay.tag = 238732478;
    int suffix;
    NSString *filename;
    UIImage *image;
    suffix = ([self currentAnimalId] + 1);
    filename = [NSString stringWithFormat:@"%@_%@", _prefix, [NSString stringWithFormat:format, suffix]];
    image = [UIImage imageNamed:filename];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake((scrollDir == kRight)?0:(numberOfPosToScroll - 1) * _picturesSize.width, _picturesOffset.y, _picturesSize.width, _picturesSize.height);
    [overlay addSubview:imageView];
    
    for (int i = 1; i < numberOfPosToScroll - 2; i++) {
        suffix = [[_shuffledIndexes objectAtIndex:(i % [_shuffledIndexes count])] intValue] + 1;
        filename = [NSString stringWithFormat:@"%@_blur_%@", _prefix, [NSString stringWithFormat:format, suffix]];
        image = [UIImage imageNamed:filename];
        imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(i * _picturesSize.width, _picturesOffset.y, _picturesSize.width, _picturesSize.height);
        [overlay addSubview:imageView];
    }
    [self addSubview:overlay];
    
    suffix = (scrollDir == kRight) ? [self nextAnimalId]: [self previousAnimalId];
    suffix += 1;
    filename = [NSString stringWithFormat:@"%@_%@", _prefix, [NSString stringWithFormat:format, suffix]];
    image = [UIImage imageNamed:filename];
    imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake((scrollDir == kRight)?(numberOfPosToScroll - 1) * _picturesSize.width:0, _picturesOffset.y, _picturesSize.width, _picturesSize.height);
    [overlay addSubview:imageView];

    self.normalImagesContainer.hidden = YES;
    
    [UIView animateWithDuration:5 animations:^{
        CGRect frame = overlay.frame;
        frame.origin.x = (scrollDir == kRight)  ? -((numberOfPosToScroll - 1) * _picturesSize.width) : 0;
        frame.origin.x += _currentOffset;
        overlay.frame = frame;
    } completion:^(BOOL finished) {
        [overlay removeFromSuperview];
        if (scrollDir == kRight) {
            [self moveRight];
        } else {
            [self moveLeft];
        }
        self.userInteractionEnabled = YES;
        self.normalImagesContainer.hidden = NO;
        self.isAutoSpinning = NO;
        [self.mgdelegate selectionChanged:self];
    }];
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [((AppDelegate *)[UIApplication sharedApplication].delegate) playSweepingSound];
}

-(int)currentAnimalId {
    return [self.shuffledIndexes[[self getArrayIndexForPositionIndex:[self centerIndex]]] intValue];
}

-(int)nextAnimalId {
    int index = [self getArrayIndexForPositionIndex:[self centerIndex]];
    if (++index == [_slideImages count]) {
        index = 0;
    }
    return [self.shuffledIndexes[index] intValue];
}

-(int)previousAnimalId {
    int index = [self getArrayIndexForPositionIndex:[self centerIndex]];
    if (--index == -1) {
        index = [_slideImages count] - 1;
    }
    return [self.shuffledIndexes[index] intValue];
}

@end
