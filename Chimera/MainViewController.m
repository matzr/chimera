#import "MainViewController.h"
#import "AppDelegate.h"
#import "PaymentProcessor.h"
#import "Preferences.h"
#import "SettingsViewController.h"
#import <QuartzCore/QuartzCore.h>

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
    self.activityView.layer.cornerRadius = 10;
    self.activityView.layer.masksToBounds = YES;
    
    [self initSuccessAnimation];
}

-(BOOL)canBecomeFirstResponder {
    return YES;
}

-(void)viewWillAppear:(BOOL)animated {
    [self positionElements];
    [super viewWillAppear:animated];
    self.activityView.hidden = NO;
}

-(void)viewDidAppear:(BOOL)animated {
    
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
    
    [super viewDidAppear:animated];
    self.activityView.hidden = YES;
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
    [self.successAnimationImageView setAnimationRepeatCount:32];
}

-(void)onSuccessAnimation {
    [self disableUserInteraction];
    [[AppDelegate instance].tracker trackEventWithCategory:@"UserAction" withAction:@"Success" withLabel:[NSString stringWithFormat:@"animal %d", self.bottomLoopScrollView.currentAnimalId] withValue:nil];
    self.successAnimationImageView.hidden = NO;
    [self.successAnimationImageView startAnimating];
    [self performSelector:@selector(hideSuccessAnimation) withObject:nil afterDelay:4];
    [UIView animateWithDuration:.5 animations:^{
        CGAffineTransform tr = CGAffineTransformScale(self.view.transform, 1.3, 1.3);
        CGAffineTransform transformHead = CGAffineTransformMakeRotation(M_PI_2 / 4);
        self.topLoopScrollView.transform = CGAffineTransformConcat(tr, transformHead);
    }];
    
    [UIView animateWithDuration:4 animations:^{
        CGAffineTransform transformSuccessAnim = CGAffineTransformMakeRotation(M_PI_2 / 2);
        self.successAnimationImageView.transform = transformSuccessAnim;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.3 animations:^{
            CGAffineTransform transform = CGAffineTransformMakeRotation(0);
            self.successAnimationImageView.transform = transform;
            self.topLoopScrollView.transform = transform;
        }];
    }];
    [self performSelector:@selector(enableUserInteraction) withObject:nil afterDelay:4];
}

-(void)hideSuccessAnimation {
    self.successAnimationImageView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    NSLog(@"memory warning");
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [self setBottomLine:nil];
    [self setTopLine:nil];
    [self setActivityView:nil];
    [self setDoubleTapToGoLabel:nil];
    [self setSettingsTapGestureRecognizer:nil];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)selectionChanged:(id)scrollView {
    if (self.topLoopScrollView.isAutoSpinning || self.middleLoopScrollView.isAutoSpinning || self.bottomLoopScrollView.isAutoSpinning) {
        return;
    }

    [[AppDelegate instance].tracker trackEventWithCategory:@"UserAction" withAction:@"Scrolled" withLabel:nil withValue:nil];
    
    if ( (self.topLoopScrollView.currentAnimalId == self.middleLoopScrollView.currentAnimalId) && (self.topLoopScrollView.currentAnimalId == self.bottomLoopScrollView.currentAnimalId)) {
        [self onSuccessAnimation];
        [[AppDelegate instance] playCheeringSound];
    }
}

- (IBAction)doubleTap:(id)sender {
    SettingsViewController *settingsVc = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsScreen"];
    [self presentViewController:settingsVc animated:YES completion:nil];
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

-(void)disableUserInteraction {
    [self setUserInteractionWithScrollView:NO];
}

-(void)enableUserInteraction {
    [self setUserInteractionWithScrollView:YES
     ];
}

-(void)setUserInteractionWithScrollView:(BOOL)activate {
    self.topLoopScrollView.userInteractionEnabled = activate;
    self.middleLoopScrollView.userInteractionEnabled = activate;
    self.bottomLoopScrollView.userInteractionEnabled = activate;
}

-(void)positionElements {
    CGFloat y1, y2;
    CGRect frame = self.topLoopScrollView.frame;
    frame.origin.y = (self.view.frame.size.height - (153 *3)) / 2;
    self.topLoopScrollView.frame = frame;
    frame.origin.y += 153;
    y1 = frame.origin.y;
    self.middleLoopScrollView.frame = frame;
    frame.origin.y += 153;
    y2 = frame.origin.y;
    self.bottomLoopScrollView.frame = frame;
    
    frame = self.topLine.frame;
    frame.origin.y = y1;
    self.topLine.frame = frame;
    
    frame = self.bottomLine.frame;
    frame.origin.y = y2 - 	20;
    self.bottomLine.frame = frame;
}

@end