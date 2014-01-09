//
//  ARAVideo.h
//  ARAlbumList
//
//  Created by Alessio Roberto on 09/01/14.
//  Copyright (c) 2014 Alessio Roberto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ARAVideo : NSObject

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *description;

@property (nonatomic, strong) NSString *uploadDate;

@property (nonatomic, strong) UIImage *videoThumb;

@property (nonatomic, strong) NSString *videoThumbUrl;

@property (nonatomic, strong) NSString *userName;

@property (nonatomic, strong) UIImage *userThumb;

@property (nonatomic, strong) NSString *userThumbUrl;

- (void)deserializeDictionary:(NSDictionary *)dict;

@end
