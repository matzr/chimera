#import "MainViewController.h"
#import "AppDelegate.h"

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
    [self.topLoopScrollView loadPicturesWithPrefix:@"part_head"];
    [self.topLoopScrollView setPicturesSize:CGSizeMake(320, 260) andOffset:CGPointMake(0, -10)];
    [self.topLoopScrollView randomizePosition];
    [self.middleLoopScrollView loadPicturesWithPrefix:@"part_body"];
    [self.middleLoopScrollView setPicturesSize:CGSizeMake(320, 330) andOffset:CGPointMake(0, -89)];
    [self.middleLoopScrollView randomizePosition];
    [self.bottomLoopScrollView loadPicturesWithPrefix:@"part_feet"];
    [self.bottomLoopScrollView setPicturesSize:CGSizeMake(320, 280) andOffset:CGPointMake(0, -105)];
    
    self.topLoopScrollView.mgdelegate = self;
    self.middleLoopScrollView.mgdelegate = self;
    self.bottomLoopScrollView.mgdelegate = self;
    
    [self.bottomLoopScrollView randomizePosition];
    self.successAnimationImageView.hidden = YES;

    [self initSuccessAnimation];
}

-(BOOL)canBecomeFirstResponder {
    return YES;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        [self.topLoopScrollView quickSpin];
        [self.middleLoopScrollView quickSpin];
        [self.bottomLoopScrollView quickSpin];
    }
}

-(void)initSuccessAnimation {
    UIImage* img1 = [UIImage imageNamed:@"blink-flash_0001"];
    UIImage* img2 = [UIImage imageNamed:@"blink-flash_0002"];
    
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
    NSLog(@"selectionChanged: %d/%d/%d", self.topLoopScrollView.currentAnimalId, self.middleLoopScrollView.currentAnimalId, self.bottomLoopScrollView.currentAnimalId);
    if ( (self.topLoopScrollView.currentAnimalId == self.middleLoopScrollView.currentAnimalId) && (self.topLoopScrollView.currentAnimalId == self.bottomLoopScrollView.currentAnimalId)) {
        [self onSuccessAnimation];
        [((AppDelegate *)[UIApplication sharedApplication].delegate) playCheeringSound];
    }
}

@end