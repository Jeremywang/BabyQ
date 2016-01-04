//
//  MineTableViewController.m
//  YYMoney
//
//  Created by jeremy on 10/13/15.
//  Copyright © 2015 Fuyou. All rights reserved.
//

#import "MineTableViewController.h"
#import "Utils.h"
#import "Config.h"
#import "UIColor+Util.h"
#import "MyInfo.h"
#import "AppDelegate.h"
#import "UIScrollView+ScalableCover.h"
#import "UIView+Util.h"
#import "SettingsPage.h"
#import "AboutPage.h"
#import "LoginViewController.h"
#import "ChangePasswordViewController.h"

#import <MBProgressHUD.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <MJRefresh.h>
#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <QuartzCore/QuartzCore.h>

#import "EZOpenSDK.h"
#import "GlobalKit.h"

@interface MineTableViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *portrait;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;

//@property (nonatomic, weak) IBOutlet UIView *separator;
//
//@property (nonatomic, weak) IBOutlet UIButton *totalRevenueButton;
//@property (nonatomic, weak) IBOutlet UIButton *balanceButton;
//@property (nonatomic, weak) IBOutlet UIButton *apprenticeButton;


@property(nonatomic, strong) NSData *fileData;

//@property (nonatomic, strong) UIImageView *myQRCodeImageView;

@property (nonatomic, assign) int64_t myID;
@property (nonatomic, strong) MyInfo *myInfo;
@property (nonatomic, strong) NSMutableArray *noticeCounts;
@property (nonatomic, assign) int badgeValue;



@end

@implementation MineTableViewController



- (void)awakeFromNib
{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noticeUpdateHandler:) name:OSCAPI_USER_NOTICE object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userRefreshHandler:)  name:@"userRefresh"     object:nil];
//
    _noticeCounts = [NSMutableArray arrayWithArray:@[@(0), @(0), @(0), @(0), @(0)]];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.backgroundColor = [UIColor themeColor];
    self.tableView.separatorColor = [UIColor seperatorColor];
    
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    
    [self setUpSubviews];
    
    //_myID = [Config getOwnID];
    [self refreshHeaderView];
    
    [self refresh];
}

- (void)refresh
{
//    _myID = [Config getOwnID];
//    if (_myID == 0) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self refreshHeaderView];
//            [self.refreshControl endRefreshing];
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.tableView reloadData];
//            });
//        });
//    } else {
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager OSCManager];
//        
//        [manager GET:[NSString stringWithFormat:@"%@%@?uid=%lld", OSCAPI_PREFIX, OSCAPI_MY_INFORMATION, _myID]
//          parameters:nil
//             success:^(AFHTTPRequestOperation *operation, ONOXMLDocument *responseDocument) {
//                 ONOXMLElement *userXML = [responseDocument.rootElement firstChildWithTag:@"user"];
//                 _myInfo = [[OSCMyInfo alloc] initWithXML:userXML];
//                 
//                 [Config updateMyInfo:_myInfo];
//                 
//                 [self refreshHeaderView];
//                 [self.refreshControl endRefreshing];
//                 
//                 dispatch_async(dispatch_get_main_queue(), ^{
//                     [self.tableView reloadData];
//                 });
//             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                 MBProgressHUD *HUD = [Utils createHUD];
//                 HUD.mode = MBProgressHUDModeCustomView;
//                 HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
//                 HUD.labelText = @"网络异常，加载失败";
//                 
//                 [HUD hide:YES afterDelay:1];
//                 
//                 [self.refreshControl endRefreshing];
//             }];
//    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self LoadUserIcon];
    [[self tableView] reloadData];
}

- (void)dealloc
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - customize subviews

- (void)setUpSubviews
{
//    _totalRevenueButton.titleLabel.numberOfLines = 0;
//    _totalRevenueButton.titleLabel.textAlignment = NSTextAlignmentCenter;
//    
//    _balanceButton.titleLabel.numberOfLines = 0;
//    _balanceButton.titleLabel.textAlignment = NSTextAlignmentCenter;
//    
//    
//    _apprenticeButton.titleLabel.numberOfLines = 0;
//    _apprenticeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    
//    [_collectionButton addTarget:self action:@selector(pushFavoriteSVC) forControlEvents:UIControlEventTouchUpInside];
//    [_followingButton addTarget:self action:@selector(pushFriendsSVC:) forControlEvents:UIControlEventTouchUpInside];
//    [_fanButton addTarget:self action:@selector(pushFriendsSVC:) forControlEvents:UIControlEventTouchUpInside];
    
    [_portrait setBorderWidth:2.0 andColor:[UIColor whiteColor]];
    [_portrait setCornerRadius:25];
    [_portrait addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPortrait)]];
    
    [self setCoverImage];
    self.refreshControl.tintColor = [UIColor refreshControlColor];
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
//    return 0;
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [UITableViewCell new];
    cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    
    UIView *selectedBackground = [UIView new];
    selectedBackground.backgroundColor = [UIColor colorWithHex:0xF5FFFA];
    [cell setSelectedBackgroundView:selectedBackground];
    
    cell.backgroundColor = [UIColor cellsColor];//colorWithHex:0xF9F9F9
    
    cell.textLabel.text = @[@"清除缓存", @"仅在WIFI模式播放", @"关于我们", @"退出登录"][indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@[@"setting-clean", @"setting-wifi", @"setting-about", @"setting-exit"][indexPath.row]];
    
//    CGRect imageframe = cell.imageView.frame;
//    imageframe.size.height = 20;
//    imageframe.size.width = 20;
//    cell.imageView.frame = imageframe;
    
    cell.imageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    
    cell.textLabel.textColor = [UIColor grayColor];
    
//    if (indexPath.row == 0) {
//        if (_badgeValue == 0) {
//            cell.accessoryView = nil;
//        } else {
//            UILabel *accessoryBadge = [UILabel new];
//            accessoryBadge.backgroundColor = [UIColor redColor];
//            accessoryBadge.text = [@(_badgeValue) stringValue];
//            accessoryBadge.textColor = [UIColor whiteColor];
//            accessoryBadge.textAlignment = NSTextAlignmentCenter;
//            accessoryBadge.layer.cornerRadius = 11;
//            accessoryBadge.clipsToBounds = YES;
//            
//            CGFloat width = [accessoryBadge sizeThatFits:CGSizeMake(MAXFLOAT, 26)].width + 8;
//            width = width > 26? width: 22;
//            accessoryBadge.frame = CGRectMake(0, 0, width, 22);
//            cell.accessoryView = accessoryBadge;
//        }
//    }
    if (indexPath.row == 1) {
        UISwitch *wifiSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
        
        [wifiSwitch addTarget:self action:@selector(updateSwitchAtIndexPath:) forControlEvents:UIControlEventValueChanged];
        
        BOOL wifiMode = [Config getWifiMode];
        
        if (wifiMode) {
            [wifiSwitch setOn:YES];
        }
        else
        {
            [wifiSwitch setOn:NO];
        }
        cell.accessoryView = wifiSwitch;
    }
    if (indexPath.row == 3) { //判断用户是否登录
        if ([Config get_login_status]) {  //已经登录
            cell.textLabel.text = @"退出登录";
        }
        else{ //未登录
            cell.textLabel.text = @"请登录";
        }
    }
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor selectCellColor];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    if ([Config getOwnID] == 0) {
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
//        LoginViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
//        [self.navigationController pushViewController:loginVC animated:YES];
//        return;
//    }
    
    switch (indexPath.row) {
//        case 0:
//        {
////            _badgeValue = 0;
////            dispatch_async(dispatch_get_main_queue(), ^{
////                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
////            });
////            self.navigationController.tabBarItem.badgeValue = nil;
//            
////            MessageCenter *messageCenterVC = [[MessageCenter alloc] initWithNoticeCounts:_noticeCounts];
////            messageCenterVC.hidesBottomBarWhenPushed = NO;
////            [self.navigationController pushViewController:messageCenterVC animated:YES];
//            
//            
////            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ChangePassword" bundle:nil];
////            ChangePasswordViewController *changePasswordVC = [storyboard instantiateViewControllerWithIdentifier:@"ChangePasswordViewController"];
////            //loginVC.hidesBottomBarWhenPushed = YES;
////            [self.navigationController pushViewController:changePasswordVC animated:NO];
//            break;
//        }
        case 0: //清除缓存
        {

            UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"确定清除缓存？" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                    [[NSURLCache sharedURLCache] removeAllCachedResponses];
            }];
            [alertController addAction:okAction];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:cancelAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
            break;
        }
        case 1: {

            
            break;
        }
        case 2: {
            AboutPage *aboutPage = [AboutPage new];
            aboutPage.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:aboutPage animated:NO];
            break;
        }
        case 3: { //注销帐号 or 登录
            if ([Config get_login_status]) {
                [Config save_login_status:NO];
                
                [EZOpenSDK logout:^(id responseObject, NSError *error) {
                    [[GlobalKit shareKit] clearSession];
                }];
                
                UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"注销成功！" message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                    
//                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
//                    LoginViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
//                    //loginVC.hidesBottomBarWhenPushed = YES;
//                    [self presentViewController:loginVC animated:NO completion:nil];
                    
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
                    LoginViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
                    UINavigationController *firstNav = [[UINavigationController alloc]initWithRootViewController:loginVC];
                    
                    RootViewController *rootViewController = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).rootViewController;
                    
                    rootViewController.contentViewController = firstNav;
                    
                    
                        }];
                [alertController addAction:okAction];
                
                [self presentViewController:alertController animated:YES completion:nil];
                [[self tableView] reloadData];
            }
            else{
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
                LoginViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
                //loginVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:loginVC animated:NO];
            }
            
            

        }
        default:
            break;
    }
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - refresh header

- (void)refreshHeaderView
{
    NSArray *usersInformation = [Config getUsersInformation];
    
    if (_myID == 0) {
        _portrait.image = [UIImage imageNamed:@"default-portrait"];
    } else {
        UIImage *portrait = [Config getPortrait];
        if (portrait == nil) {
            [_portrait sd_setImageWithURL:_myInfo.portraitURL
                         placeholderImage:[UIImage imageNamed:@"default-portrait"]
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                    if (!image) {return;}
                                    [Config savePortrait:image];
//                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"userRefresh" object:@(YES)];
                                }];
        } else {
            _portrait.image = portrait;
        }
    }
    
    _nameLabel.text = usersInformation[0];
//    _separator.backgroundColor = [UIColor lineColor];
    
    [self setCoverImage];
    

    
//    if (_myID == 0) {
//        _QRCodeButton.hidden = YES;
//        _creditButton.hidden = YES;
//        _collectionButton.hidden = YES;
//        _followingButton.hidden = YES;
//        _fanButton.hidden = YES;
//        _separator.hidden = YES;
//    } else {
//        _QRCodeButton.hidden = NO;
//        _creditButton.hidden = NO;
//        _collectionButton.hidden = NO;
//        _followingButton.hidden = NO;
//        _fanButton.hidden = NO;
//        _separator.hidden = NO;
//        
//        _QRCodeButton.titleLabel.font = [UIFont fontAwesomeFontOfSize:25];
//        [_QRCodeButton setTitle:[NSString fontAwesomeIconStringForEnum:FAQrcode] forState:UIControlStateNormal];
//        [_QRCodeButton addTarget:self action:@selector(showQRCode) forControlEvents:UIControlEventTouchUpInside];
//        
//        [_creditButton setTitle:[NSString stringWithFormat:@"积分\n%@", usersInformation[1]] forState:UIControlStateNormal];
//        [_collectionButton setTitle:[NSString stringWithFormat:@"收藏\n%@", usersInformation[2]] forState:UIControlStateNormal];
//        [_followingButton setTitle:[NSString stringWithFormat:@"关注\n%@", usersInformation[3]] forState:UIControlStateNormal];
//        [_fanButton setTitle:[NSString stringWithFormat:@"粉丝\n%@", usersInformation[4]] forState:UIControlStateNormal];
//    }
    
    
}

- (void)setCoverImage
{
    NSNumber *screenWidth = @([UIScreen mainScreen].bounds.size.width);
    NSString *imageName = @"user-background";
    if (screenWidth.intValue < 400) {
        imageName = [NSString stringWithFormat:@"%@-%@", imageName, screenWidth];
    }
    
//    if (((AppDelegate *)[UIApplication sharedApplication].delegate).inNightMode) {
//        imageName = [NSString stringWithFormat:@"%@-dark", imageName];
//    }
    
   if (!self.tableView.scalableCover) {
        [self.tableView addScalableCoverWithImage:[UIImage imageNamed:imageName]];
    } else{
        self.tableView.scalableCover.image = [UIImage imageNamed:imageName];
    }
}

- (void)tapPortrait
{
//    UIActionSheet* actionSheet = [[UIActionSheet alloc]
//                                  initWithTitle:@"请选择文件来源"
//                                  delegate:self
//                                  cancelButtonTitle:@"取消"
//                                  destructiveButtonTitle:nil
//                                  otherButtonTitles:@"照相机",@"摄像机",@"本地相簿",@"本地视频",nil];
//    [actionSheet showInView:self.view];
    
    
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"请选择图片来源" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"照相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        //            [self presentModalViewController:imagePicker animated:YES];
        [self presentViewController:imagePicker animated:YES completion:nil];
        
    }];
    [alertController addAction:cameraAction];
    
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"本地相簿" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //            [self presentModalViewController:imagePicker animated:YES];
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    [alertController addAction:albumAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:cancelAction];
    
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

#pragma mark -
#pragma UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeImage]) {
        UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
        [self performSelector:@selector(saveImage:)  withObject:img afterDelay:0.5];
    }
    else if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeMovie]) {
        NSString *videoPath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
        
        self.fileData = [NSData dataWithContentsOfFile:videoPath];
    }
    //    [picker dismissModalViewControllerAnimated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //    [picker dismissModalViewControllerAnimated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveImage:(UIImage *)image {
    //    NSLog(@"保存头像！");
    //    [userPhotoButton setImage:image forState:UIControlStateNormal];
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:@"selfPhoto.jpg"];
    NSLog(@"imageFile->>%@",imageFilePath);
    success = [fileManager fileExistsAtPath:imageFilePath];
    if(success) {
        success = [fileManager removeItemAtPath:imageFilePath error:&error];
    }
    //    UIImage *smallImage=[self scaleFromImage:image toSize:CGSizeMake(80.0f, 80.0f)];//将图片尺寸改为80*80
    UIImage *smallImage = [self thumbnailWithImageWithoutScale:image size:CGSizeMake(200, 200)];
    [UIImageJPEGRepresentation(smallImage, 1.0f) writeToFile:imageFilePath atomically:YES];//写入文件
    UIImage *selfPhoto = [UIImage imageWithContentsOfFile:imageFilePath];//读取图片文件
    //    [userPhotoButton setImage:selfPhoto forState:UIControlStateNormal];
    self.portrait.image = selfPhoto;
}

// 改变图像的尺寸，方便上传服务器
- (UIImage *) scaleFromImage: (UIImage *) image toSize: (CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//2.保持原来的长宽比，生成一个缩略图
- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }
        else{
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}



- (void)userRefreshHandler:(NSNotification *)notification
{
//    _myID = [Config getOwnID];
    
    [self refreshHeaderView];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (IBAction)updateSwitchAtIndexPath:(id)sender
{
    UISwitch *wifiSwitch = (UISwitch *)sender;
    
    if ([wifiSwitch isOn]) {
        [Config save_ON_OFF_WIFI:YES];
    }
    else
    {
        [Config save_ON_OFF_WIFI:FALSE];
    }
}

- (void)LoadUserIcon
{
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:@"selfPhoto.jpg"];
    NSLog(@"imageFile->>%@",imageFilePath);
    success = [fileManager fileExistsAtPath:imageFilePath];
    if(success) {
        UIImage *selfPhoto = [UIImage imageWithContentsOfFile:imageFilePath];//读取图片文件
        self.portrait.image = selfPhoto;
    }
}

@end
