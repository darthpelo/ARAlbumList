//
//  ARAAlbumCell.m
//  ARAlbumList
//
//  Created by Alessio Roberto on 09/01/14.
//  Copyright (c) 2014 Alessio Roberto. All rights reserved.
//

#import "ARAAlbumCell.h"

@implementation ARAAlbumCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)awakeFromNib{
    UIColor* mainColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    UIColor* neutralColor = [UIColor colorWithWhite:0.7 alpha:1.0];
    
    NSString* fontName = @"Avenir-Light";
    NSString* boldFontName = @"Avenir-Book";
    
    self.titleLabel.textColor = mainColor;
    self.titleLabel.font = [UIFont fontWithName:boldFontName size:17.0f];
    
    self.descriptionLabel.textColor =  neutralColor;
    self.descriptionLabel.font =  [UIFont fontWithName:fontName size:10.0f];
    
    self.dateLabel.textColor = neutralColor;
    self.dateLabel.font =  [UIFont fontWithName:fontName size:10.0f];
    
    self.feedContainer.layer.cornerRadius = 3.0f;
    self.feedContainer.clipsToBounds = YES;
    self.feedContainer.backgroundColor = [UIColor darkGrayColor];
    
    self.picImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.picImageView.clipsToBounds = YES;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
