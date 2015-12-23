//
//  VideoTableViewCell.m
//  BabyQ
//
//  Created by jeremy on 12/7/15.
//  Copyright © 2015 Fuyou. All rights reserved.
//

#import "VideoTableViewCell.h"
#import "VideoListItem.h"
#import "UIKit+AFNetworking.h"
#import "DDKit.h"
#import "Masonry.h"
#import "UIView+Util.h"

@implementation VideoTableViewCell

- (void)awakeFromNib {
    // Initialization code
   // self.contentView.constraints =
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (void)setVideoListItem:(VideoListItem *)videoListItem
//{
//    _videoListItem = videoListItem;
//    
//    _titleLabel.text = _videoListItem.titleStr;
//    
//    [_videoImageView setImage:_videoListItem.photo];
//}

- (void)setCameraInfo:(EZCameraInfo *)cameraInfo
{
    _cameraInfo = cameraInfo;
    _titleLabel.text = _cameraInfo.cameraName;
    [_titleLabel setBorderWidth:0.1f andColor:[UIColor grayColor]];
    
    [_videoImageView setImageWithURL:[NSURL URLWithString:cameraInfo.picUrl] placeholderImage:[UIImage imageNamed:@"Cell-photo"]];
    
//    [self.contentView dd_addSeparatorWithType:ViewSeparatorTypeBottom];
//    [self.contentView dd_addSeparatorWithType:ViewSeparatorTypeTop];
//    [self.contentView dd_addSeparatorWithType:ViewSeparatorTypeLeft];
//    [self.contentView dd_addSeparatorWithType:ViewSeparatorTypeRight];
    
    
//    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.mas_equalTo(self.titleLabel.mas_leading);
//        make.trailing.mas_equalTo(self.titleLabel.mas_trailing);
//        make.leading.mas_equalTo(self.videoImageView.mas_leading);
//        make.trailing.mas_equalTo(self.videoImageView.mas_trailing);
////        make.width.height.mas_equalTo(@14);
////        make.centerX.mas_equalTo(self.playerView.mas_centerX);
////        make.centerY.mas_equalTo(self.playerView.mas_centerY);
//    }];
    
}

- (void)go2Play
{
    [self.parentViewController performSelector:@selector(go2Play:) withObject:_cameraInfo];
}

- (IBAction)go2Play:(id)sender
{
    [self.parentViewController performSelector:@selector(go2Play:) withObject:_cameraInfo];
}


@end
