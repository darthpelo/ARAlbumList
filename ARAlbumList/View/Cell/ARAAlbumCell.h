//
//  ARAAlbumCell.h
//  ARAlbumList
//
//  Created by Alessio Roberto on 09/01/14.
//  Copyright (c) 2014 Alessio Roberto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ARAAlbumCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIView *feedContainer;

@property (nonatomic, weak) IBOutlet UIImageView *picImageView;

@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;

@property (nonatomic, weak) IBOutlet UILabel *dateLabel;

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

@end
