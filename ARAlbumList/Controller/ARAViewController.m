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

@interface ARAViewController () {
    NSMutableArray *videoList;
    ARAAlbumRequest *albumRequest;
}

@end

@implementation ARAViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (videoList == nil) {
        videoList = [[NSMutableArray alloc] init];
        [self getAlbumList];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    videoList = nil;
}

- (void)getAlbumList
{
    UIAlertView *alertDownload = [[UIAlertView alloc] initWithTitle:@"Downloading..." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    UIActivityIndicatorView *act = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [alertDownload setValue:act forKey:@"accessoryView"];
    [alertDownload show];
    [act startAnimating];
    
    albumRequest = [[ARAAlbumRequest alloc] init];
    
    [albumRequest requestAlbumList:^(id responseData) {
        if (responseData == nil) {
            [alertDownload dismissWithClickedButtonIndex:0 animated:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Network error occured. Retry later..." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        } else {
            for (NSDictionary *dict in responseData) {
                ARAVideo *video = [[ARAVideo alloc] init];
                [video deserializeDictionary:dict];
                [videoList addObject:video];
            }
            [self.tableView reloadData];
            
            ARAVideo *video = [videoList objectAtIndex:0];
            
            UIView *tableViewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
            UILabel *userName = [[UILabel alloc] initWithFrame:CGRectMake(100, 30, 200, 24)];
            NSString* boldFontName = @"Avenir-Black";
            [userName setFont:[UIFont fontWithName:boldFontName size:20]];
            userName.text = video.userName;
            userName.textColor = [UIColor blueColor];
            UIImageView *userImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 50, 50)];
            [userImage setImageWithURL:[NSURL URLWithString:video.userThumbUrl]];
            userImage.clipsToBounds = YES;
            userImage.layer.cornerRadius = 20.0f;
            userImage.layer.borderWidth = 2.0f;
            userImage .layer.borderColor = [UIColor blueColor].CGColor;
            [tableViewHeader addSubview:userImage];
            [tableViewHeader addSubview:userName];
            self.tableView.tableHeaderView = tableViewHeader;
            
            [alertDownload dismissWithClickedButtonIndex:0 animated:YES];
        }
    }];
    
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
    return videoList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"VideoCell";
    ARAAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[ARAAlbumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    
    ARAVideo *video = [videoList objectAtIndex:indexPath.row];
    
    if (video.videoThumb == nil) {
        [cell.activityIndicator startAnimating];
        NSURL *url = [NSURL URLWithString:video.videoThumbUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [cell.picImageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            [cell.activityIndicator stopAnimating];
            [cell.activityIndicator setHidden:YES];
            cell.picImageView.image = image;
            video.videoThumb = image;
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            NSLog(@"%@", error);
        }];
    } else
        cell.picImageView.image = video.videoThumb;
    
    cell.titleLabel.text = video.title;
    cell.descriptionLabel.text = video.description;
    cell.dateLabel.text = video.uploadDate;
    return cell;
}

@end
