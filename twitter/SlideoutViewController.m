//
//  SlideoutViewController.m
//  twitter
//
//  Created by Rajeev Nayak on 6/29/14.
//  Copyright (c) 2014 jeev. All rights reserved.
//

#import "SlideoutViewController.h"
#import "SlideoutHeaderCell.h"

@interface SlideoutViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) SlideoutHeaderCell *prototypeHeaderCell;

@end

@implementation SlideoutViewController

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

    // init the table view
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    UINib *headerCellNib = [UINib nibWithNibName:@"SlideoutHeaderCell" bundle:nil];
    [self.tableView registerNib:headerCellNib forCellReuseIdentifier:@"SlideoutHeaderCell"];
    self.prototypeHeaderCell = [self.tableView dequeueReusableCellWithIdentifier:@"SlideoutHeaderCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"DefaultCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return SlideoutItemCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DefaultCell" forIndexPath:indexPath];
    cell.backgroundColor = tableView.backgroundColor;
    cell.textLabel.text = [self textForItem:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = [UIColor whiteColor];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    // add an invisible footer to prevent the table view from showing extra separators underneath the populated rows
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    SlideoutHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SlideoutHeaderCell"];
    cell.user = [User currentUser];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    self.prototypeHeaderCell.user = [User currentUser];
    [self.prototypeHeaderCell layoutSubviews];
    CGSize size = [self.prototypeHeaderCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.delegate slideoutViewController:self didSelectItem:indexPath.row];
}

#pragma mark - helpers

- (NSString *)textForItem:(SlideoutItem)item {
    switch (item) {
        case SlideoutItemProfile:
            return @"Profile";
        case SlideoutItemTimeline:
            return @"Timeline";
        case SlideoutItemMentions:
            return @"Mentions";
        case SlideoutItemLogout:
            return @"Sign Out";
        default:
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"invalid item" userInfo:nil];
    }
}

@end
