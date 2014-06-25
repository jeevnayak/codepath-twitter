//
//  ComposeTweetViewController.m
//  twitter
//
//  Created by Rajeev Nayak on 6/23/14.
//  Copyright (c) 2014 jeev. All rights reserved.
//

#import "ComposeTweetViewController.h"
#import "User.h"
#import "TwitterClient.h"
#import <UIImageView+AFNetworking.h>

NSInteger const kMaxCharacterCount = 140;

@interface ComposeTweetViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *userProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userScreenNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *tweetTextView;

@property (nonatomic, strong) UILabel *characterCountLabel;
@property (nonatomic, strong) UIBarButtonItem *tweetButton;

@end

@implementation ComposeTweetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // init the character count label
        self.characterCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 25, 15)];
        self.characterCountLabel.font = [UIFont systemFontOfSize:13];
        self.characterCountLabel.textColor = [UIColor lightGrayColor];
        self.characterCountLabel.text = [@(kMaxCharacterCount) stringValue];

        // init the nav bar items
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelButton)];
        UIBarButtonItem *characterCountButton = [[UIBarButtonItem alloc] initWithCustomView:self.characterCountLabel];
        self.tweetButton = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStyleDone target:self action:@selector(onTweetButton)];
        self.tweetButton.enabled = NO;
        self.navigationItem.rightBarButtonItems = @[self.tweetButton, characterCountButton];
    }
    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // set the nav bar style
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    navigationBar.barTintColor = nil;
    navigationBar.tintColor = nil;

    // init the views
    User *currentUser = [User currentUser];
    [self.userProfileImageView setImageWithURL:currentUser.profileImageUrl];
    self.userNameLabel.text = currentUser.name;
    self.userScreenNameLabel.text = [NSString stringWithFormat:@"@%@", currentUser.screenName];
    if (self.replyTo != nil) {
        NSString *initialTweetText = @"";
        if (self.replyTo.retweetedTweet != nil) {
            initialTweetText = [initialTweetText stringByAppendingFormat:@"@%@ ", self.replyTo.retweetedTweet.user.screenName];
        }
        initialTweetText = [initialTweetText stringByAppendingFormat:@"@%@ ", self.replyTo.user.screenName];
        self.tweetTextView.text = initialTweetText;
    }

    // give the text view focus
    [self.tweetTextView becomeFirstResponder];
    self.tweetTextView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    NSInteger charactersLeft = kMaxCharacterCount - textView.text.length;
    self.characterCountLabel.text = [@(charactersLeft) stringValue];
    self.characterCountLabel.textColor = (charactersLeft >= 20) ? [UIColor lightGrayColor] : [UIColor redColor];
    self.tweetButton.enabled = (charactersLeft >= 0) && (charactersLeft < kMaxCharacterCount);
}

#pragma mark - event handlers

- (void)onCancelButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onTweetButton {
    void (^success)(AFHTTPRequestOperation *operation, Tweet *tweet) = ^(AFHTTPRequestOperation *operation, Tweet *tweet) {
        if (self.delegate != nil) {
            [self.delegate didPostTweet:tweet];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    void (^failure)(AFHTTPRequestOperation *operation, NSError *error) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        // TODO: show network error view
    };

    // post the tweet
    if (self.replyTo != nil) {
        [[TwitterClient instance] postReply:self.tweetTextView.text toTweetWithIdStr:self.replyTo.idStr success:success failure:failure];
    } else {
        [[TwitterClient instance] postTweet:self.tweetTextView.text success:success failure:failure];
    }
}

@end
