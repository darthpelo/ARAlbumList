//
//  ARAAlbumRequest.m
//  ARAlbumList
//
//  Created by Alessio Roberto on 09/01/14.
//  Copyright (c) 2014 Alessio Roberto. All rights reserved.
//

#import "ARAAlbumRequest.h"
#import "AFNetworking.h"

static NSString * const urlStr = @"http://vimeo.com/api/v2/album/58/videos.json";

@implementation ARAAlbumRequest

- (void)requestAlbumList:(void (^)(id responseData))block
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        block(nil);
    }];
}

- (void)requestAlbumListPage:(NSInteger)page response:(void (^)(id))block
{
    NSString *pageUrlStr = [NSString stringWithFormat:@"%@?page=%d", urlStr, page];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:pageUrlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        block(nil);
    }];
}

@end
