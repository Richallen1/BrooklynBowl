//
//  WhatsOnTableViewCell.h
//  BrooklynBowl
//
//  Created by Rich Allen on 03/03/2014.
//  Copyright (c) 2014 Magic Entertainment. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WhatsOnTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *artistImage;
@property (strong, nonatomic) IBOutlet UILabel *mainTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;


@end
