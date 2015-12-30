//
//  EZLivePlayViewController.m
//  EZOpenSDKDemo
//
//  Created by DeJohn Dong on 15/10/28.
//  Copyright © 2015年 hikvision. All rights reserved.
//

#import "EZLivePlayViewController.h"
#import "EZOpenSDK.h"
#import "UIViewController+EZBackPop.h"
#import "EZDeviceInfo.h"
#import "EZPlayer.h"
#import "DDKit.h"
#import "Masonry.h"
#import "HIKLoadView.h"
#import "HIKLoadPercentView.h"
#import "BabyQ.pch"
#import "Config.h"
#import "AppDelegate.h"

@interface EZLivePlayViewController ()<EZPlayerDelegate, UIAlertViewDelegate>
{
    BOOL _isOpenSound;
    BOOL _isPlaying;
    
    NSTimer *_recordTimer;
    
    FILE *_localRecord;
    
    NSString *_filePath;
    
    NSTimeInterval _seconds;
    CALayer *_orangeLayer;
}

@property (nonatomic, strong) EZPlayer *player;
@property (nonatomic, strong) HIKLoadView *loadingView;
@property (nonatomic, strong) HIKLoadPercentView *loadingPercentView;
@property (nonatomic, weak) IBOutlet UIButton *playerPlayButton;
@property (nonatomic, weak) IBOutlet UIView *playerView;
@property (nonatomic, weak) IBOutlet UIView *toolBar;
@property (nonatomic, weak) IBOutlet UIView *bottomView;
@property (nonatomic, weak) IBOutlet UIButton *controlButton;
@property (nonatomic, weak) IBOutlet UIButton *talkButton;
@property (nonatomic, weak) IBOutlet UIButton *captureButton;
@property (nonatomic, weak) IBOutlet UIButton *localRecordButton;
@property (nonatomic, weak) IBOutlet UIButton *playButton;
@property (nonatomic, weak) IBOutlet UIButton *voiceButton;
@property (nonatomic, weak) IBOutlet UIButton *qualityButton;
@property (nonatomic, weak) IBOutlet UIButton *emptyButton;
@property (nonatomic, weak) IBOutlet UIButton *largeButton;
@property (nonatomic, weak) IBOutlet UIButton *largeBackButton;
@property (nonatomic, weak) IBOutlet UIView *ptzView;
@property (nonatomic, weak) IBOutlet UIButton *ptzCloseButton;
@property (nonatomic, weak) IBOutlet UIButton *ptzControlButton;
@property (nonatomic, weak) IBOutlet UIView *qualityView;
@property (nonatomic, weak) IBOutlet UIButton *highButton;
@property (nonatomic, weak) IBOutlet UIButton *middleButton;
@property (nonatomic, weak) IBOutlet UIButton *lowButton;
@property (nonatomic, weak) IBOutlet UIButton *ptzUpButton;
@property (nonatomic, weak) IBOutlet UIButton *ptzLeftButton;
@property (nonatomic, weak) IBOutlet UIButton *ptzDownButton;
@property (nonatomic, weak) IBOutlet UIButton *ptzRightButton;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *ptzViewContraint;
@property (nonatomic, weak) IBOutlet UILabel *localRecordLabel;
@property (nonatomic, weak) IBOutlet UIView *talkView;
@property (nonatomic, weak) IBOutlet UIButton *talkCloseButton;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *talkViewContraint;
@property (nonatomic, weak) IBOutlet UIImageView *speakImageView;
@property (nonatomic, weak) IBOutlet UILabel *largeTitleLabel;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *localRecrodContraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *toolBarContraint;

@property (nonatomic, weak) IBOutlet UIScrollView *playScrollView;


@end

@implementation EZLivePlayViewController

- (void)dealloc
{
    [EZOpenSDK releasePlayer:_player];
}

- (void)centerScrollViewContents {
    CGSize boundsSize = self.playScrollView.bounds.size;
    CGRect contentsFrame = self.playerView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    self.playerView.frame = contentsFrame;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = _cameraName;
    self.largeTitleLabel.text = self.title;
    
    self.isAutorotate = YES;
    
    self.ptzView.hidden = YES;
    self.talkView.hidden = YES;
    
    self.talkButton.enabled = NO;
    self.controlButton.enabled = NO;
    self.captureButton.enabled = NO;
    self.localRecordButton.enabled = NO;
    
    // Tell the scroll view the size of the contents
    self.playScrollView.contentSize = self.playerView.frame.size;
    
    self.playScrollView.minimumZoomScale = 1.0f;
    self.playScrollView.maximumZoomScale = 2.0f;
    self.playScrollView.zoomScale = 1;
    
    [self centerScrollViewContents];
    
    
    [EZOpenSDK getDeviceInfo:_cameraId comletion:^(EZDeviceInfo *deviceInfo, NSError *error) {
        if(deviceInfo.isSupportTalk)
        {
            self.talkButton.enabled = YES;
        }
        if(deviceInfo.isSupportPTZ)
        {
            self.controlButton.enabled = YES;
        }
    }];
    
    _player = [EZPlayer createPlayerWithCameraId:_cameraId];
    _player.delegate = self;
    [_player setVideoLevel:EZVideoQualityLow];
    [self.qualityButton setTitle:@"流畅" forState:UIControlStateNormal];
    [_player setPlayerView:_playerView];
    [_player startRealPlay];
    
//    if(!_loadingView)
//        _loadingView = [[HIKLoadView alloc] initWithHIKLoadViewStyle:HIKLoadViewStyleSqureClockWise];
//    [self.view insertSubview:_loadingView aboveSubview:self.playerView];
//    [_loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.mas_equalTo(@14);
//        make.centerX.mas_equalTo(self.playerView.mas_centerX);
//        make.centerY.mas_equalTo(self.playerView.mas_centerY);
//    }];
//    [self.loadingView startSquareClcokwiseAnimation];
    
    
    if(!_loadingPercentView)
        _loadingPercentView = [[HIKLoadPercentView alloc] initWithFrame:CGRectMake(0, 0, 30, 20) percentStr:@"1"];
    [self.view insertSubview:_loadingPercentView aboveSubview:self.playerView];
    [_loadingPercentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(@14);
        make.centerX.mas_equalTo(self.playerView.mas_centerX);
        make.centerY.mas_equalTo(self.playerView.mas_centerY);
    }];
    [self.loadingPercentView showPercentAnimation];
    
    
    self.largeBackButton.hidden = YES;
    _isOpenSound = YES;
    
//    [self.controlButton centerImageAndTitlec];
//    [self.talkButton dd_centerImageAndTitle];
//    [self.captureButton dd_centerImageAndTitle];
//    [self.localRecordButton dd_centerImageAndTitle];
    
    [self.voiceButton setImage:[UIImage imageNamed:@"preview_unvoice_btn_sel"] forState:UIControlStateHighlighted];
    [self addLine];
    
    self.localRecordLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    self.localRecordLabel.layer.cornerRadius = 12.0f;
    self.localRecordLabel.layer.borderWidth = 1.0f;
    self.localRecordLabel.clipsToBounds = YES;
    self.playButton.enabled = NO;
    
    //WIFI change
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WifiStatedChanged) name:@"wifiStatesChanged" object:nil];
}


- (void)WifiStatedChanged
{
    //判断当前网络状态
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if ([Config getWifiMode]) {
        if ([appDelegate isWifi])
        {

        }
        else
        {
            UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"当前不在WIFI网络下" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:okAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
            
            if(_isPlaying)
            {
                [_player stopRealPlay];
                [self.playButton setImage:[UIImage imageNamed:@"preview_play_btn_sel"] forState:UIControlStateHighlighted];
                [self.playButton setImage:[UIImage imageNamed:@"preview_play_btn"] forState:UIControlStateNormal];
                self.localRecordButton.enabled = NO;
                self.captureButton.enabled = NO;
                self.playerPlayButton.hidden = NO;
            }

            _isPlaying = FALSE;
            
        }
    }
    else
    {

    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.ptzViewContraint.constant = self.bottomView.frame.size.height;
    self.talkViewContraint.constant = self.ptzViewContraint.constant;
    
//    UIPinchGestureRecognizer *pinchGestureRecongnizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(changeImage:)];
//    pinchGestureRecongnizer.delegate = self;
//    [_playerView setUserInteractionEnabled:YES];
//    [_playerView addGestureRecognizer:pinchGestureRecongnizer];
}

- (void)changeImage:(UIPinchGestureRecognizer*)pinchGestureRecognizer {
        //[self.view bringSubviewToFront:pinchGestureRecognizer.view];
    
//        CGPoint location = [pinchGestureRecognizer locationInView:self.view];
//    
//        NSLog(@"location = %@", NSStringFromCGPoint(location));
//    
//        pinchGestureRecognizer.view.center = CGPointMake(location.x, location.y);
//        pinchGestureRecognizer.view.transform = CGAffineTransformScale(pinchGestureRecognizer.view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
//        pinchGestureRecognizer.scale = 1;
}

- (void)viewWillDisappear:(BOOL)animated {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideQualityView) object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"wifiStatesChanged" object:nil];
    [EZOpenSDK releasePlayer:_player];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration
{
    self.navigationController.navigationBarHidden = NO;
    self.toolBar.hidden = NO;
    self.largeBackButton.hidden = YES;
    self.bottomView.hidden = NO;
    self.largeTitleLabel.hidden = YES;
    self.localRecrodContraint.constant = 10;
    if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
       toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        self.navigationController.navigationBarHidden = YES;
        self.localRecrodContraint.constant = 50;
        self.toolBar.hidden = YES;
        self.largeTitleLabel.hidden = NO;
        self.largeBackButton.hidden = NO;
        self.bottomView.hidden = YES;
    }
}

//#pragma mark - UIAlertViewDelegate Methods
//
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 1)
//    {
//        NSString *smsCode = [alertView textFieldAtIndex:0].text;
//        //验证输入的安全短信验证码
//        [EZOpenSDK secureSmsValidate:smsCode completion:^(NSError *error) {
//            if (!error)
//            {
//                [_player startRealPlay];
//            }
//        }];
//    }
//}

#pragma mark - PlayerDelegate Methods

- (void)player:(EZPlayer *)player didPlayFailed:(NSError *)error
{
    NSLog(@"player = %@, error = %@",player, error);
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"播放失败请稍后重试！" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
                               [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)player:(EZPlayer *)player didReceviedMessage:(NSInteger)messageCode
{
    if(messageCode == PLAYER_REALPLAY_START)
    {
        self.captureButton.enabled = YES;
        self.localRecordButton.enabled = YES;
        //[self.loadingView stopSquareClockwiseAnimation];
        [self.loadingPercentView hideRemovePercentAnimation];
        self.playButton.enabled = YES;
        [self.playButton setImage:[UIImage imageNamed:@"preview_stopplay_btn_sel"] forState:UIControlStateHighlighted];
        [self.playButton setImage:[UIImage imageNamed:@"preview_stopplay_btn"] forState:UIControlStateNormal];
        _isPlaying = YES;
        
        if(!_isOpenSound)
        {
            [player closeSound];
        }
    }
    else if (messageCode == PLAYER_NEED_VALIDATE_CODE)
    {
        //终端安全验证
        [EZOpenSDK getSMSCode:EZSMSTypeSecure completion:^(NSError *error) {
            if(!error)
            {
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"安全验证" message:@"请输入安全手机号码收到的安全验证短信内容" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//                alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
//                [alertView show];
                
                UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"安全验证" message:@"请输入安全手机号码收到的安全验证短信内容" preferredStyle:UIAlertControllerStyleAlert];
                
                [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
                    textField.placeholder = @"你的电话号码";
                    textField.secureTextEntry = NO;
                }];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                    
                    NSString *smsCode = [[[alertController textFields] objectAtIndex:0] text];
                    //验证输入的安全短信验证码
                    [EZOpenSDK secureSmsValidate:smsCode completion:^(NSError *error) {
                        if (!error)
                        {
                            [_player startRealPlay];
                        }
                    }];
                }];
                [alertController addAction:okAction];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:cancelAction];
                //
                [self presentViewController:alertController animated:YES completion:nil];
            }
        }];
    }
}

#pragma mark - Action Methods

- (IBAction)large:(id)sender
{
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}

- (IBAction)largeBack:(id)sender
{
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}

- (IBAction)capture:(id)sender
{
    UIImage *image = [_player capturePicture:100];
    [self saveImageToPhotosAlbum:image];
}

- (IBAction)talkButtonClicked:(id)sender
{
    [_player startVoiceTalk];
    [self.bottomView bringSubviewToFront:self.talkView];
    self.talkView.hidden = NO;
    self.speakImageView.alpha = 0;
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.talkViewContraint.constant = 0;
                         self.speakImageView.alpha = 1.0;
                         [self.bottomView setNeedsUpdateConstraints];
                         [self.bottomView layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                     }];
}

- (IBAction)voiceButtonClicked:(id)sender
{
    if(_isOpenSound){
        [_player closeSound];
        [self.voiceButton setImage:[UIImage imageNamed:@"preview_unvoice_btn_sel"] forState:UIControlStateHighlighted];
        [self.voiceButton setImage:[UIImage imageNamed:@"preview_unvoice_btn"] forState:UIControlStateNormal];
    }
    else
    {
        [_player openSound];
        [self.voiceButton setImage:[UIImage imageNamed:@"preview_voice_btn_sel"] forState:UIControlStateHighlighted];
        [self.voiceButton setImage:[UIImage imageNamed:@"preview_voice_btn"] forState:UIControlStateNormal];
    }
    _isOpenSound = !_isOpenSound;
}

- (IBAction)playButtonClicked:(id)sender
{
    //判断当前网络状态
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if ([Config getWifiMode]) {
        if ([appDelegate isWifi])
        {
            
        }
        else
        {
            UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"当前不在WIFI网络下" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:okAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
            
            if(_isPlaying)
            {
                [_player stopRealPlay];
                [self.playButton setImage:[UIImage imageNamed:@"preview_play_btn_sel"] forState:UIControlStateHighlighted];
                [self.playButton setImage:[UIImage imageNamed:@"preview_play_btn"] forState:UIControlStateNormal];
                self.localRecordButton.enabled = NO;
                self.captureButton.enabled = NO;
                self.playerPlayButton.hidden = NO;
            }
            
            _isPlaying = FALSE;
            
        }
    }
    else
    {
        if(_isPlaying)
        {
            [_player stopRealPlay];
            [self.playButton setImage:[UIImage imageNamed:@"preview_play_btn_sel"] forState:UIControlStateHighlighted];
            [self.playButton setImage:[UIImage imageNamed:@"preview_play_btn"] forState:UIControlStateNormal];
            self.localRecordButton.enabled = NO;
            self.captureButton.enabled = NO;
            self.playerPlayButton.hidden = NO;
        }
        else
        {
            [_player startRealPlay];
            self.playerPlayButton.hidden = YES;
            [self.playButton setImage:[UIImage imageNamed:@"preview_stopplay_btn_sel"] forState:UIControlStateHighlighted];
            [self.playButton setImage:[UIImage imageNamed:@"preview_stopplay_btn"] forState:UIControlStateNormal];
            //[self.loadingView startSquareClcokwiseAnimation];
            [self.loadingPercentView showPercentAnimation];
        }
        _isPlaying = !_isPlaying;
    }
    
}

- (IBAction)qualityButtonClicked:(id)sender
{
    if(self.qualityButton.selected)
    {
        self.qualityView.hidden = YES;
    }
    else
    {
        self.qualityView.hidden = NO;
        //停留5s以后隐藏视频质量View.
        [self performSelector:@selector(hideQualityView) withObject:nil afterDelay:5.0f];
    }
    self.qualityButton.selected = !self.qualityButton.selected;
}

- (void)hideQualityView
{
    self.qualityButton.selected = NO;
    self.qualityView.hidden = YES;
}

- (IBAction)qualitySelectedClicked:(id)sender
{
    if(sender == self.highButton)
    {
        [_player setVideoLevel:EZVideoQualityHigh];
        [self.qualityButton setTitle:@"高清" forState:UIControlStateNormal];
    }
    else if(sender == self.middleButton)
    {
        [_player setVideoLevel:EZVideoQualityMiddle];
        [self.qualityButton setTitle:@"均衡" forState:UIControlStateNormal];
    }
    else
    {
        [_player setVideoLevel:EZVideoQualityLow];
        [self.qualityButton setTitle:@"流畅" forState:UIControlStateNormal];
    }
    //[self.loadingView startSquareClcokwiseAnimation];
    [self.loadingPercentView showPercentAnimation];
    self.qualityView.hidden = YES;
}

- (IBAction)ptzControlButtonTouchDown:(id)sender
{
    EZPTZCommand command;
    NSString *imageName = nil;
    if(sender == self.ptzLeftButton)
    {
        command = EZPTZCommandLeft;
        imageName = @"ptz_left_sel";
    }
    else if (sender == self.ptzDownButton)
    {
        command = EZPTZCommandDown;
        imageName = @"ptz_bottom_sel";
    }
    else if (sender == self.ptzRightButton)
    {
        command = EZPtzCommandRight;
        imageName = @"ptz_right_sel";
    }
    else {
        command = EZPTZCommandUp;
        imageName = @"ptz_up_sel";
    }
    [self.ptzControlButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateDisabled];
    [EZOpenSDK controlPTZ:_cameraId
                  command:command
                   action:EZPTZActionStart
                    speed:3.0
                   result:^(BOOL result, NSError *error) {
                   }];
}

- (IBAction)ptzControlButtonTouchUpInside:(id)sender
{
    EZPTZCommand command;
    if(sender == self.ptzLeftButton)
    {
        command = EZPTZCommandLeft;
    }
    else if (sender == self.ptzDownButton)
    {
        command = EZPTZCommandDown;
    }
    else if (sender == self.ptzRightButton)
    {
        command = EZPtzCommandRight;
    }
    else {
        command = EZPTZCommandUp;
    }
    [self.ptzControlButton setImage:[UIImage imageNamed:@"ptz_bg"] forState:UIControlStateDisabled];
    [EZOpenSDK controlPTZ:_cameraId
                  command:command
                   action:EZPTZActionStop
                    speed:3.0
                   result:^(BOOL result, NSError *error) {
                   }];
}

- (IBAction)ptzViewShow:(id)sender
{
    self.ptzView.hidden = NO;
    [self.bottomView bringSubviewToFront:self.ptzView];
    self.ptzControlButton.alpha = 0;
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.ptzViewContraint.constant = 0;
                         self.ptzControlButton.alpha = 1.0;
                         [self.bottomView setNeedsUpdateConstraints];
                         [self.bottomView layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                     }];
}

- (IBAction)closePtzView:(id)sender
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.ptzControlButton.alpha = 0.0;
                         self.ptzViewContraint.constant = self.bottomView.frame.size.height;
                         [self.bottomView setNeedsUpdateConstraints];
                         [self.bottomView layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         self.ptzControlButton.alpha = 0;
                         self.ptzView.hidden = YES;
                     }];
}

- (IBAction)closeTalkView:(id)sender
{
    [_player stopVoiceTalk];
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.speakImageView.alpha = 0.0;
                         self.talkViewContraint.constant = self.bottomView.frame.size.height;
                         [self.bottomView setNeedsUpdateConstraints];
                         [self.bottomView layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         self.speakImageView.alpha = 0;
                         self.talkView.hidden = YES;
                     }];
}

- (IBAction)localButtonClicked:(id)sender
{
    //结束本地录像
    if(self.localRecordButton.selected)
    {
        [_player stopLocalRecord];
        fclose(_localRecord);
        self.localRecordLabel.hidden = YES;
        [_recordTimer invalidate];
        _recordTimer = nil;
        [self saveRecordToPhotosAlbum:_filePath];
    }
    else
    {
        //开始本地录像
        NSString *path = @"/OpenSDK/EzvizLoaclRecord";
        
        NSArray * docdirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString * docdir = [docdirs objectAtIndex:0];
        
        NSString * configFilePath = [docdir stringByAppendingPathComponent:path];
        if(![[NSFileManager defaultManager] fileExistsAtPath:configFilePath]){
            NSError *error = nil;
            [[NSFileManager defaultManager] createDirectoryAtPath:configFilePath
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:&error];
        }
        NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
        dateformatter.dateFormat = @"yyyyMMddHHmmssSSS";
        _filePath = [NSString stringWithFormat:@"%@/%@.mov",configFilePath,[dateformatter stringFromDate:[NSDate date]]];
        _localRecord = fopen([_filePath UTF8String], "wb+");
        [_player startLocalRecord:^(NSData *data) {
            if(!_localRecord ||
               !data)
                return;
            if ([data length] != fwrite([data bytes], 1, [data length], _localRecord))
            {
                NSLog(@"local record file write error");
                return;
            }
            fflush(_localRecord);
        }];
        self.localRecordLabel.hidden = NO;
        _seconds = 0;
        _recordTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerStart:) userInfo:nil repeats:YES];
    }
    self.localRecordButton.selected = !self.localRecordButton.selected;
}

- (void)timerStart:(NSTimer *)timer
{
    NSInteger currentTime = ++_seconds;
    self.localRecordLabel.text = [NSString stringWithFormat:@"  %02d:%02d", (int)currentTime/60, (int)currentTime % 60];
    if(!_orangeLayer)
    {
        _orangeLayer = [CALayer layer];
        _orangeLayer.frame = CGRectMake(10.0, 8.0, 8.0, 8.0);
        _orangeLayer.backgroundColor = UIColorFromRGB(0xff6000, 1.0).CGColor;
        _orangeLayer.cornerRadius = 4.0f;
    }
    if(currentTime % 2 == 0)
    {
        [_orangeLayer removeFromSuperlayer];
    }
    else
    {
        [self.localRecordLabel.layer addSublayer:_orangeLayer];
    }
}

#pragma mark - Private Methods

- (void)saveImageToPhotosAlbum:(UIImage *)savedImage
{
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)saveRecordToPhotosAlbum:(NSString *)path
{
    UISaveVideoAtPathToSavedPhotosAlbum(path, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), NULL);
}

// 指定回调方法
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *message = nil;
    if (!error) {
        message = @"已保存至手机相册";
    }
    else
    {
        message = [error description];
    }
    [UIView showMessage:message];
}

- (void)addLine
{
    for (UIView *view in self.toolBar.subviews) {
        if([view isKindOfClass:[UIImageView class]])
        {
            [view removeFromSuperview];
        }
    }
    CGFloat averageWidth = [UIScreen mainScreen].bounds.size.width/5.0;
    //UIImageView *lineImageView1 = [UIView instanceVerticalLine:20 color:[UIColor grayColor]];
    UIImageView *lineImageView1 = [UIView instanceVerticalLine:20.0 andColor:[UIColor grayColor]];
    
    lineImageView1.frame = CGRectMake(averageWidth, 7, lineImageView1.frame.size.width, lineImageView1.frame.size.height);
    [self.toolBar addSubview:lineImageView1];
    UIImageView *lineImageView2 = [UIView instanceVerticalLine:20 andColor:[UIColor grayColor]];
    lineImageView2.frame = CGRectMake(averageWidth * 2, 7, lineImageView2.frame.size.width, lineImageView2.frame.size.height);
    [self.toolBar addSubview:lineImageView2];
    UIImageView *lineImageView3 = [UIView instanceVerticalLine:20 andColor:[UIColor grayColor]];
    lineImageView3.frame = CGRectMake(averageWidth * 3, 7, lineImageView3.frame.size.width, lineImageView3.frame.size.height);
    [self.toolBar addSubview:lineImageView3];
    UIImageView *lineImageView4 = [UIView instanceVerticalLine:20 andColor:[UIColor grayColor]];
    lineImageView4.frame = CGRectMake(averageWidth * 4, 7, lineImageView4.frame.size.width, lineImageView4.frame.size.height);
    [self.toolBar addSubview:lineImageView4];
}

#pragma mark - UIScrollViewDelegate

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    // Return the view that we want to zoom
    return self.playerView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // The scroll view has zoomed, so we need to re-center the contents
    NSLog(@"jeremy-------scrollViewDidZoom");
    [self centerScrollViewContents];
}

@end
