//
//  WhatsOnTableViewCell.m
//  BrooklynBowl
//
//  Created by Rich Allen on 03/03/2014.
//  Copyright (c) 2014 Magic Entertainment. All rights reserved.
//

#import "WhatsOnTableViewCell.h"

@implementation WhatsOnTableViewCell
@synthesize artistImage = _artistImage;
@synthesize mainTitleLabel = _mainTitleLabel;
@synthesize timeLabel = _timeLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        UIImageView *imgView = [[UIImageView alloc]initWithImage:[[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"WhatsOnCell" ofType:@"jpg"]]];
        
        self.backgroundView = imgView;
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
