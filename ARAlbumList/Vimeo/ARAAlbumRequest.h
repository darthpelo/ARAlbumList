//
//  ARAAlbumRequest.h
//  ARAlbumList
//
//  Created by Alessio Roberto on 09/01/14.
//  Copyright (c) 2014 Alessio Roberto. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 `ARAAlbumRequest` this class handles requests the list of videos in an album and images preview video.
 */
@interface ARAAlbumRequest : NSObject

///---------------------------------------------------
/// @name Request Videos List Callback
///---------------------------------------------------

/**
 Sets a callback to be executed when the videos list is downloaded.
 
 @param block A block object to be executed when the download end. This block has no return value and takes a single argument which represents the video list. The value may be nill if some errors occured.
 */
- (void)requestAlbumList:(void(^)(id responseData))block;
/**
 Sets a callback to be executed when the videos list of a page is downloaded.
 
 @param page The page number of the request
 @param block A block object to be executed when the download end. This block has no return value and takes a single argument which represents the video list. The value may be nill if some errors occured.
 */
- (void)requestAlbumListPage:(NSInteger)page response:(void(^)(id responseData))block;
/**
 Sets a callback to be executed when the image preview of a video is downloaded.
 
 @param urlStr The url of the image
 @param success A block object to be executed when the download end with success. This block has no return value and takes a single argument which represents the image.
 @param failure A block object to be executed when the download end with failure. This block has no return value and no argument.
 */
- (void)requestAlbumThumb:(NSString *)urlStr success:(void(^)(UIImage *image))success failure:(void(^)())failure;

@end
