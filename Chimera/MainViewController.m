#import "MainViewController.h"

@implementation MainViewController

@synthesize topLoopScrollView;
@synthesize middleLoopScrollView;
@synthesize bottomLoopScrollView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [topLoopScrollView loadPicturesWithPrefix:@"part_head"];
    [topLoopScrollView setPicturesSize:CGSizeMake(self.view.frame.size.width, 250) andOffset:CGPointMake(0, 0)];
    [topLoopScrollView randomizePosition];
    [middleLoopScrollView loadPicturesWithPrefix:@"part_body"];
    [middleLoopScrollView setPicturesSize:CGSizeMake(self.view.frame.size.width, 380) andOffset:CGPointMake(0, -100)];
    [middleLoopScrollView randomizePosition];
    [bottomLoopScrollView loadPicturesWithPrefix:@"part_feet"];
    [bottomLoopScrollView setPicturesSize:CGSizeMake(self.view.frame.size.width, 350) andOffset:CGPointMake(0, -100)];
    [bottomLoopScrollView randomizePosition];
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

@end