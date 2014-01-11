//
//  ARAViewController.m
//  ARAlbumList
//
//  Created by Alessio Roberto on 09/01/14.
//  Copyright (c) 2014 Alessio Roberto. All rights reserved.
//

#import "ARAViewController.h"
#import "ARAAlbumRequest.h"
#import "ARAVideo.h"
#import "ARAAlbumCell.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "UIImageView+AFNetworking.h"
#import "UIActivityIndicatorView+AFNetworking.h"
#import "UIAlertView+AFNetworking.h"
#import "AFNetworkReachabilityManager.h"

static NSInteger const max_pages = 3;

@interface ARAViewController () {
    NSMutableArray *videoList;
    ARAAlbumRequest *albumRequest;
    
    UIAlertView *alertDownload;
    UIActivityIndicatorView *act;
    UIActivityIndicatorView *footerActivity;
    
    NSInteger lastPage;
}

@end

@implementation ARAViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        lastPage = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [UIColor blueColor];
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refresh addTarget:self
                action:@selector(refreshView:)
      forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (videoList == nil) {
        videoList = [[NSMutableArray alloc] init];
        
        alertDownload = [[UIAlertView alloc] initWithTitle:@"Downloading..." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
        act = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [alertDownload setValue:act forKey:@"accessoryView"];
        [alertDownload show];
        [act startAnimating];
        
        [self getAlbumList];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    videoList = nil;
}

#pragma mark - Privete Methods

- (void)refreshView:(UIRefreshControl *)refresh
{
    if (videoList == nil)
        videoList = [[NSMutableArray alloc] init];
    [videoList removeAllObjects];
    
    alertDownload = [[UIAlertView alloc] initWithTitle:@"Downloading..." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    act = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [alertDownload setValue:act forKey:@"accessoryView"];
    [alertDownload show];
    [act startAnimating];
    
    lastPage = 0;
    
    [self.tableView reloadData];
    
    [self getAlbumList];
    
    [refresh endRefreshing];
}

- (void)getAlbumList
{
    if (albumRequest == nil) {
        albumRequest = [[ARAAlbumRequest alloc] init];
    }
    
    if (lastPage < max_pages) {
        lastPage++;
        
        if (footerActivity) {
            [footerActivity startAnimating];
            [footerActivity setHidden:NO];
        }
        
        [albumRequest requestAlbumListPage:lastPage response:^(id responseData) {
            if (responseData == nil) {
                if (lastPage == 1)
                    [alertDownload dismissWithClickedButtonIndex:0 animated:YES];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Network error occured. Retry later..." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                
                [footerActivity stopAnimating];
                [footerActivity setHidden:YES];
            } else {
                for (NSDictionary *dict in responseData) {
                    ARAVideo *video = [[ARAVideo alloc] init];
                    [video deserializeDictionary:dict];
                    [videoList addObject:video];
                }
                
                // The tableview header with the user information, it should be configured to only load the first page of videos
                // Tableview footer view activityview configuration
                if (lastPage == 1) {
                    [alertDownload dismissWithClickedButtonIndex:0 animated:YES];
                    
                    ARAVideo *video = [videoList objectAtIndex:0];
                    
                    UIView *tableViewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
                    UILabel *userName = [[UILabel alloc] initWithFrame:CGRectMake(74, 35, 230, 22)];
                    NSString* boldFontName = @"Avenir-Black";
                    [userName setFont:[UIFont fontWithName:boldFontName size:20]];
                    userName.text = video.userName;
                    userName.textColor = [UIColor blueColor];
                    UIImageView *userImage = [[UIImageView alloc] initWithFrame:CGRectMake(17, 20, 50, 50)];
                    [userImage setImageWithURL:[NSURL URLWithString:video.userThumbUrl]];
                    userImage.clipsToBounds = YES;
                    userImage.layer.cornerRadius = 20.0f;
                    userImage.layer.borderWidth = 2.0f;
                    userImage .layer.borderColor = [UIColor blueColor].CGColor;
                    [tableViewHeader addSubview:userImage];
                    [tableViewHeader addSubview:userName];
                    self.tableView.tableHeaderView = tableViewHeader;
                    
                    UIView *tableViewFooter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
                    footerActivity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                    [footerActivity setFrame:CGRectMake((320 - footerActivity.frame.size.width) / 2, (45 - footerActivity.frame.size.height) / 2, footerActivity.frame.size.width, footerActivity.frame.size.height)];
                    [tableViewFooter addSubview:footerActivity];
                    [footerActivity startAnimating];
                    [footerActivity setHidden:NO];
                    
                    self.tableView.tableFooterView = tableViewFooter;
                }
                
                [self.tableView reloadData];
            }
        }];
    } else {
        [footerActivity stopAnimating];
        lastPage++;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return (videoList.count > 0 && videoList)?videoList.count:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"VideoCell";
    ARAAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[ARAAlbumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    
    ARAVideo *video = [videoList objectAtIndex:indexPath.row];
    [cell.activityIndicator startAnimating];
    [cell.activityIndicator setHidden:NO];
    if (video.videoThumb == nil) {
        [albumRequest requestAlbumThumb:video.videoThumbUrl success:^(UIImage *image) {
            cell.picImageView.image = image;
            video.videoThumb = image;
            [cell.activityIndicator stopAnimating];
            [cell.activityIndicator setHidden:YES];
        } failure:^{
            NSLog(@"Fail download image");
        }];
    } else {
        cell.picImageView.image = video.videoThumb;
        [cell.activityIndicator stopAnimating];
        [cell.activityIndicator setHidden:YES];
    }
    
    cell.titleLabel.text = video.title;
    cell.descriptionLabel.text = video.description;
    cell.dateLabel.text = video.uploadDate;
    
    // Check end list
    if (indexPath.row == videoList.count - 3) {
        [self getAlbumList];
    }
    
    return cell;
}

@end
