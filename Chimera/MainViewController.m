#import "MainViewController.h"
#import "AppDelegate.h"
#import "PaymentProcessor.h"
#import "Preferences.h"
#import "SettingsViewController.h"

@interface MainViewController() {
    
}

@end

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
    self.topLoopScrollView.mgdelegate = self;
    self.middleLoopScrollView.mgdelegate = self;
    self.bottomLoopScrollView.mgdelegate = self;
    
    self.successAnimationImageView.hidden = YES;
    
    [self initSuccessAnimation];
}

-(BOOL)canBecomeFirstResponder {
    return YES;
}

-(void)viewWillAppear:(BOOL)animated {
    NSMutableArray *pictureIndexes = [NSMutableArray array];
    [pictureIndexes addObjectsFromArray:@[@1, @2, @3, @4]];
    if ([Preferences instance].extraAnimalsEnabled) {
        [pictureIndexes addObjectsFromArray:@[@5, @6, @7, @8]];
    }
    
    [self.topLoopScrollView reset];
    self.topLoopScrollView.pictureIndexes = pictureIndexes;
    [self.topLoopScrollView loadPicturesWithPrefix:@"part_head"];
    [self.topLoopScrollView setPicturesSize:CGSizeMake(320, 260) andOffset:CGPointMake(0, -10)];
    self.topLoopScrollView.name = @"top";
    //    [self.topLoopScrollView randomizePosition];

    [self.middleLoopScrollView reset];
    self.middleLoopScrollView.pictureIndexes = pictureIndexes;
    [self.middleLoopScrollView loadPicturesWithPrefix:@"part_body"];
    [self.middleLoopScrollView setPicturesSize:CGSizeMake(320, 330) andOffset:CGPointMake(0, -89)];
    self.middleLoopScrollView.name = @"middle";
    //    [self.middleLoopScrollView randomizePosition];
    
    [self.bottomLoopScrollView reset];
    self.bottomLoopScrollView.pictureIndexes = pictureIndexes;
    [self.bottomLoopScrollView loadPicturesWithPrefix:@"part_feet"];
    [self.bottomLoopScrollView setPicturesSize:CGSizeMake(320, 280) andOffset:CGPointMake(0, -105)];
    self.bottomLoopScrollView.name = @"bottom";
    //    [self.bottomLoopScrollView randomizePosition];
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
    [[AppDelegate instance].tracker trackView:@"Main Screen (Lézanimo)"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        if ([Preferences instance].shakeForRandom) {
            [[AppDelegate instance].tracker trackEventWithCategory:@"UserAction" withAction:@"Randomized" withLabel:nil withValue:nil];
            [[AppDelegate instance] playRandomizerSound];
            [self.topLoopScrollView quickSpin];
            [self.middleLoopScrollView quickSpin];
            [self.bottomLoopScrollView quickSpin];
        }
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
    [[AppDelegate instance].tracker trackEventWithCategory:@"UserAction" withAction:@"Success" withLabel:[NSString stringWithFormat:@"animal %d", self.bottomLoopScrollView.currentAnimalId] withValue:nil];
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
    [self setDoubleTapToGoLabel:nil];
    [self setSettingsTapGestureRecognizer:nil];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
    
}

-(void)selectionChanged:(id)scrollView {
    if (self.topLoopScrollView.isAutoSpinning || self.middleLoopScrollView.isAutoSpinning || self.bottomLoopScrollView.isAutoSpinning) {
        return;
    }
    
    [[AppDelegate instance].tracker trackEventWithCategory:@"UserAction" withAction:@"Scrolled" withLabel:nil withValue:nil];
    
    if ( (self.topLoopScrollView.currentAnimalId == self.middleLoopScrollView.currentAnimalId) && (self.topLoopScrollView.currentAnimalId == self.bottomLoopScrollView.currentAnimalId)) {
        NSLog(@"selectionChanged: %d/%d/%d", self.topLoopScrollView.currentAnimalId, self.middleLoopScrollView.currentAnimalId, self.bottomLoopScrollView.currentAnimalId);
        [self onSuccessAnimation];
        [[AppDelegate instance] playCheeringSound];
    }
}

- (IBAction)doubleTap:(id)sender {
    SettingsViewController *settingsVc = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsScreen"];
    [self presentViewController:settingsVc animated:YES completion:^{
        
    }];
}

- (IBAction)singleTapSettings:(id)sender {
    [UIView animateWithDuration:.5 animations:^{
        self.doubleTapToGoLabel.alpha = 1;
    }];
    [self performSelector:@selector(hideDoubleTapLabel) withObject:nil afterDelay:3];
}

-(void)hideDoubleTapLabel {
    [UIView animateWithDuration:.5 animations:^{
        self.doubleTapToGoLabel.alpha = 0;
    }];
}
@end