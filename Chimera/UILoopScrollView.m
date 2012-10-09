//
//  UILoopScrollView.m
//  Chimera
//
//  Created by Mathieu Gardère on 20/09/12.
//  Copyright (c) 2012 LesBandits.com. All rights reserved.
//

#import "UILoopScrollView.h"

#define LEFT_EDGE_OFSET 0

@implementation UILoopScrollView

- (id)initWithFrame:(CGRect)frame filenamePrefix:(NSString*)filenamePrefix numberOfFiles:(int)numberOfFiles {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(void)initPictures:(NSString *)prefix withVerticalOffset:(int)offset {
    _filenamePrefix = prefix;
    _slideImages = [NSMutableArray array];
    _offset = offset;
    [self loadImages];
}

-(void)loadImages {
    CGRect scrollFrame;
    scrollFrame.origin.x = 0;
    scrollFrame.origin.y = 0;
    scrollFrame.size.width = self.frame.size.width;
    scrollFrame.size.height = self.frame.size.height;
    
    self.pagingEnabled = YES;
    self.delegate = self;
    self.userInteractionEnabled = YES;
    
    _slideImages = [[NSMutableArray alloc] init];
    
    
    UIImage *image;
    NSString *filenameSuffix;
    NSString *filename;
    NSString *format = [NSString stringWithFormat:@"%%0%dd", 4];
    int i = 0;
    do {
        filenameSuffix = [NSString stringWithFormat:format, ++i];
        filename = [NSString stringWithFormat:@"%@_%@", _filenamePrefix, filenameSuffix];
        image = [UIImage imageNamed:filename];
        if (image) {
            [_slideImages addObject:filename];
        }
    } while (image);
    
    //add the last image first
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[_slideImages objectAtIndex:([_slideImages count]-1)]]];
    imageView.frame = CGRectMake(LEFT_EDGE_OFSET, -_offset, self.frame.size.width, self.frame.size.height);
    [self addSubview:imageView];
    
    for (int i = 0;i<[_slideImages count];i++) {
        //loop this bit
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[_slideImages objectAtIndex:i]]];
        imageView.frame = CGRectMake((self.frame.size.width * i) + LEFT_EDGE_OFSET + 320, -_offset, self.frame.size.width, self.frame.size.height);
        [self addSubview:imageView];
        //
    }
    
    //add the first image at the end
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[_slideImages objectAtIndex:0]]];
    imageView.frame = CGRectMake((self.frame.size.width * ([_slideImages count] + 1)) + LEFT_EDGE_OFSET, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:imageView];
    
    [self setContentSize:CGSizeMake(self.frame.size.width * ([_slideImages count] + 2), self.frame.size.height)];
    [self setContentOffset:CGPointMake(0, 0)];
    [self scrollRectToVisible:CGRectMake(self.frame.size.width,0,self.frame.size.width,self.frame.size.height) animated:NO];
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;

}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int currentPage = floor((self.contentOffset.x - self.frame.size.width / ([_slideImages count]+2)) / self.frame.size.width) + 1;
    if (currentPage==0) {
        //go last but 1 page
        [self scrollRectToVisible:CGRectMake(self.frame.size.width * [_slideImages count],0,self.frame.size.width,self.frame.size.height) animated:NO];
    } else if (currentPage==([_slideImages count]+1)) {
        [self scrollRectToVisible:CGRectMake(self.frame.size.width,0,self.frame.size.width,self.frame.size.height) animated:NO];
    }
}

- (void)scrollToPreviousPage {
    CGRect currentFrame = CGRectMake(self.contentOffset.x - self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    [self scrollRectToVisible:currentFrame animated:YES];
}

- (void)scrollToNextPage {
    CGRect currentFrame = CGRectMake(self.contentOffset.x + self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    [self scrollRectToVisible:currentFrame animated:YES];
}



@end
