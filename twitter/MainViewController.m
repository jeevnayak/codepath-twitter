//
//  MainViewController.m
//  twitter
//
//  Created by Rajeev Nayak on 6/29/14.
//  Copyright (c) 2014 jeev. All rights reserved.
//

#import "MainViewController.h"
#import "TimelineViewController.h"
#import "ProfileViewController.h"
#import "LoginViewController.h"
#import "TwitterClient.h"

NSTimeInterval const kSlideoutAnimationDuration = 0.25;
NSInteger const kSlideoutClosedOffset = 25;

@interface MainViewController ()

@property (nonatomic, strong) ContentViewController *contentViewController;
@property (nonatomic, strong) SlideoutViewController *slideoutViewController;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // init the slideout
	self.slideoutViewController = [[SlideoutViewController alloc] init];
    self.slideoutViewController.delegate = self;
	[self addChildViewController:self.slideoutViewController];
    self.slideoutViewController.view.frame = self.view.frame;
	[self.view addSubview:self.slideoutViewController.view];
	[self.slideoutViewController didMoveToParentViewController:self];

    // init the content
    TimelineViewController *vc = [[TimelineViewController alloc] init];
    vc.type = TimelineTypeHome;
    self.contentViewController = [[ContentViewController alloc] initWithRootViewController:vc];
    self.contentViewController.navigationBar.translucent = NO;
    self.contentViewController.slideoutDelegate = self;
    [self addChildViewController:self.contentViewController];
    self.contentViewController.view.frame = self.view.frame;
    [self.view addSubview:self.contentViewController.view];
    [self.contentViewController didMoveToParentViewController:self];

    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanGesture:)];
    [self.contentViewController.view addGestureRecognizer:panGestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ContentViewControllerDelegate

- (void)showSlideout:(ContentViewController *)vc {
    [self animateSlideoutOpen];
}

- (void)hideSlideout:(ContentViewController *)vc {
    [self animateSlideoutClosed];
}

#pragma mark - SlideoutViewControllerDelegate

- (void)slideoutViewController:(SlideoutViewController *)vc didSelectItem:(SlideoutItem)item {
    // replace the view controller in the content view based on which item was tapped
    UIViewController *newViewController;
    switch (item) {
        case SlideoutItemProfile:
        {
            ProfileViewController *pvc = [[ProfileViewController alloc] init];
            pvc.user = [User currentUser];
            newViewController = pvc;
            break;
        }
        case SlideoutItemTimeline:
        {
            TimelineViewController *tvc = [[TimelineViewController alloc] init];
            tvc.type = TimelineTypeHome;
            newViewController = tvc;
            break;
        }
        case SlideoutItemMentions:
        {
            TimelineViewController *tvc = [[TimelineViewController alloc] init];
            tvc.type = TimelineTypeMentions;
            newViewController = tvc;
            break;
        }
        case SlideoutItemLogout:
            [self logout];
            return;
        default:
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"invalid item" userInfo:nil];
    }
    [self.contentViewController setViewControllers:@[newViewController]];
    [self animateSlideoutClosed];
}

#pragma mark - event handlers

- (void)onPanGesture:(UIPanGestureRecognizer *)panGestureRecognizer {
    if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        // translate the content view controller based on the pan
        CGPoint translation = [panGestureRecognizer translationInView:self.view];
        CGFloat newX = MAX(self.contentViewController.view.center.x + translation.x, self.view.center.x);
        self.contentViewController.view.center = CGPointMake(newX, self.contentViewController.view.center.y);
        [panGestureRecognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    }

    if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        // open or close the slideout based on whether it's halfway off the screen
        BOOL openSlideout = self.contentViewController.view.center.x - self.view.center.x > self.contentViewController.view.frame.size.width / 2;
        if (openSlideout) {
            [self animateSlideoutOpen];
        } else {
            [self animateSlideoutClosed];
        }
    }
}

#pragma mark - helpers

- (void)animateSlideoutOpen {
    [UIView animateWithDuration:kSlideoutAnimationDuration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.contentViewController.view.frame = CGRectMake(self.view.frame.size.width - kSlideoutClosedOffset, 0, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             self.contentViewController.slideoutShowing = YES;
                         }
                     }];
}

- (void)animateSlideoutClosed {
    [UIView animateWithDuration:kSlideoutAnimationDuration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.contentViewController.view.frame = self.view.frame;
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             self.contentViewController.slideoutShowing = NO;
                         }
                     }];
}

- (void)logout {
    [[TwitterClient instance] logout];
    LoginViewController *vc = [[LoginViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

@end
