//
//  VideoTableViewCell.h
//  BabyQ
//
//  Created by jeremy on 12/7/15.
//  Copyright © 2015 Fuyou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIImageView.h>
#import "VideoListItem.h"
#import "EZCameraInfo.h"

@interface VideoTableViewCell : UITableViewCell

@property (strong, nonatomic) EZCameraInfo *cameraInfo;

@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIButton *playButton;
@property (nonatomic, weak) IBOutlet UIImageView *offlineIcon;

//@property (strong, nonatomic) VideoListItem *videoListItem;

@property (nonatomic, weak) UIViewController *parentViewController;

- (IBAction)go2Play:(id)sender;


@end
