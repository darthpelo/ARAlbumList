//
//  ARAAlbumRequest.h
//  ARAlbumList
//
//  Created by Alessio Roberto on 09/01/14.
//  Copyright (c) 2014 Alessio Roberto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ARAAlbumRequest : NSObject {
    BOOL reachable;
}

- (void)requestAlbumList:(void(^)(id responseData))block;

- (void)requestAlbumListPage:(NSInteger)page response:(void(^)(id responseData))block;

- (void)requestAlbumThumb:(NSString *)urlStr success:(void(^)(UIImage *image))success failure:(void(^)())failure;

@end
