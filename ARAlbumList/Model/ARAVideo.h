//
//  ARAVideo.h
//  ARAlbumList
//
//  Created by Alessio Roberto on 09/01/14.
//  Copyright (c) 2014 Alessio Roberto. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Class that rapreset a single video.
 */
@interface ARAVideo : NSObject
/**
 Video title.
 */
@property (nonatomic, strong) NSString *title;
/**
 Video description.
 */
@property (nonatomic, strong) NSString *description;
/**
 The upload date.
 */
@property (nonatomic, strong) NSString *uploadDate;
/**
 Video image preview.
 */
@property (nonatomic, strong) UIImage *videoThumb;
/**
 URL where the video image preview is located.
 */
@property (nonatomic, strong) NSString *videoThumbUrl;
/**
 User name.
 */
@property (nonatomic, strong) NSString *userName;
/**
 User profile picture.
 */
@property (nonatomic, strong) UIImage *userThumb;
/**
 URL where the user profile picture is located.
 */
@property (nonatomic, strong) NSString *userThumbUrl;

///---------------------
/// @name Initialization
///---------------------
/**
 Set all parameters of a single video object
 
 @param dict The Json structure that rapresent a single viedeo information.
 */
- (void)deserializeDictionary:(NSDictionary *)dict;

@end
