//
//  ARAVideo.m
//  ARAlbumList
//
//  Created by Alessio Roberto on 09/01/14.
//  Copyright (c) 2014 Alessio Roberto. All rights reserved.
//

#import "ARAVideo.h"

@implementation ARAVideo

- (void)deserializeDictionary:(NSDictionary *)dict
{
    // video
    self.title = dict[@"title"];
    self.description = dict[@"description"];
    self.uploadDate = dict[@"upload_date"];
    self.videoThumbUrl = dict[@"thumbnail_medium"];
    
    // user
    self.userName = dict[@"user_name"];
    self.userThumbUrl = dict[@"user_portrait_medium"];
}

@end
