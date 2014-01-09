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
        videoList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self getAlbumList];
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
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    albumRequest = [[ARAAlbumRequest alloc] init];
    
    [albumRequest requestAlbumList:^(id responseData) {
        if (responseData == nil) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Network error occured. Retry later..." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        } else {
            for (NSDictionary *dict in responseData) {
                ARAVideo *video = [[ARAVideo alloc] init];
                [video deserializeDictionary:dict];
                [videoList addObject:video];
            }
            [self.tableView reloadData];
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
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
        NSURL *url = [NSURL URLWithString:video.videoThumbUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
        [cell.picImageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            cell.picImageView.image = image;
            video.videoThumb = image;
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            NSLog(@"%@", error);
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        }];
    } else
        cell.picImageView.image = video.videoThumb;
    
    cell.titleLabel.text = video.title;
    cell.descriptionLabel.text = video.description;
    cell.dateLabel.text = video.uploadDate;
    return cell;
}

@end
