#import "MainViewController.h"

@implementation MainViewController

@synthesize topLoopScrollView;
@synthesize middleLoopScrollView;
@synthesize bottomLoopScrollView;
@synthesize successAnimationImageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [topLoopScrollView loadPicturesWithPrefix:@"part_head"];
    [topLoopScrollView setPicturesSize:CGSizeMake(320, 260) andOffset:CGPointMake(0, 10)];
    [topLoopScrollView randomizePosition];
    [middleLoopScrollView loadPicturesWithPrefix:@"part_body"];
    [middleLoopScrollView setPicturesSize:CGSizeMake(320, 330) andOffset:CGPointMake(0, -69)];
    [middleLoopScrollView randomizePosition];
    [bottomLoopScrollView loadPicturesWithPrefix:@"part_feet"];
    [bottomLoopScrollView setPicturesSize:CGSizeMake(320, 280) andOffset:CGPointMake(0, -95)];
    
    topLoopScrollView.delegate = self;
    middleLoopScrollView.delegate = self;
    bottomLoopScrollView.delegate = self;
    
    [bottomLoopScrollView randomizePosition];
    self.successAnimationImageView.hidden = YES;
    
    //sound fx on picture swipe
    //sound fx on random
    //remonter les pattes legerement -- qques pixels
    
}

-(void)initSuccessAnimation {
    UIImage* img1 = [UIImage imageNamed:@"blink-flash_001"];
    UIImage* img2 = [UIImage imageNamed:@"blink-flash_002"];
    
    NSArray *images = [NSArray arrayWithObjects:img1,img2, nil];
    
    [self.successAnimationImageView setAnimationImages:images];
    [self.successAnimationImageView setAnimationDuration:0.167];
    [self.successAnimationImageView setAnimationRepeatCount:8];
}

-(void)onSuccessAnimation {
    self.successAnimationImageView.hidden = NO;
    [self.successAnimationImageView startAnimating];
    [self performSelector:@selector(hideSuccessAnimation) withObject:nil afterDelay:1.3];
}

-(void)hideSuccessAnimation {
    self.successAnimationImageView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


-(void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
    
}

-(void)selectionChanged:(id)scrollView {
    
}

@end