//
//  ContentViewController.m
//  twitter
//
//  Created by Rajeev Nayak on 6/29/14.
//  Copyright (c) 2014 jeev. All rights reserved.
//

#import "ContentViewController.h"

@interface ContentViewController ()

@end

@implementation ContentViewController

- (id)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        rootViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Hamburger Menu"] style:UIBarButtonItemStylePlain target:self action:@selector(onSlideoutButton)];

        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
        tapGestureRecognizer.delegate = self;
        [self.view addGestureRecognizer:tapGestureRecognizer];
    }
    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setViewControllers:(NSArray *)viewControllers {
    [super setViewControllers:viewControllers];
    self.topViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Hamburger Menu"] style:UIBarButtonItemStylePlain target:self action:@selector(onSlideoutButton)];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    // don't pass touch events to child views if the slideout is showing
    return self.slideoutShowing;
}

#pragma mark - event handlers

- (void)onSlideoutButton {
    if (self.slideoutShowing) {
        [self.slideoutDelegate hideSlideout:self];
    } else {
        [self.slideoutDelegate showSlideout:self];
    }
}

- (IBAction)onTap:(id)sender {
    if (self.slideoutShowing) {
        [self.slideoutDelegate hideSlideout:self];
    }
}

@end
