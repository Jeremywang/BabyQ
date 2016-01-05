//
//  EZLivePlayViewController.h
//  EZOpenSDKDemo
//
//  Created by DeJohn Dong on 15/10/28.
//  Copyright © 2015年 hikvision. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EZLivePlayViewController : UIViewController <UIGestureRecognizerDelegate, UIScrollViewDelegate>

@property (nonatomic, copy) NSString *cameraId;
@property (nonatomic, copy) NSString *cameraName;

//- (void)imageSavedToPhotosAlbum:(UIImage *)image
//       didFinishSavingWithError:(NSError *)error
//                    contextInfo:(void *)contextInfo;

@end
