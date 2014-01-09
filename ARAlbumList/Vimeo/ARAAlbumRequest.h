//
//  ARAAlbumRequest.h
//  ARAlbumList
//
//  Created by Alessio Roberto on 09/01/14.
//  Copyright (c) 2014 Alessio Roberto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ARAAlbumRequest : NSObject

- (void)requestAlbumList:(void(^)(id responseData))block;

@end
