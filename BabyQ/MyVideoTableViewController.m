//
//  MyVideoTableViewController.m
//  BabyQ
//
//  Created by jeremy on 12/7/15.
//  Copyright © 2015 Fuyou. All rights reserved.
//

#import "MyVideoTableViewController.h"
#import "VideoListItem.h"
#import "VideoTableViewCell.h"
#import "GlobalKit.h"
#import "EZOpenSDK.h"
#import "EZAccessToken.h"
#import "MJRefresh.h"
#import "DDKit.h"
#import "EZLivePlayViewController.h"
#import "AppDelegate.h"
#import "Config.h"
#import "LoginViewController.h"
#import <MBProgressHUD.h>
#import "Utils.h"

#import <AFNetworking.h>

#define EZCameraListPageSize 30

@interface MyVideoTableViewController ()

@property (nonatomic, strong) MBProgressHUD *hud;

@property (nonatomic, strong) NSMutableArray *remoteCameraList; //系统摄像头列表

@property (nonatomic, strong) NSMutableArray *localCameraList;  //用户输入的帐号摄像头列表

@property (nonatomic, strong) NSMutableArray *userCameraList;   //数据综合后的列表

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic) NSInteger currentPageIndex;

//@property (nonatomic, copy) NSString *urlString;

@property (nonatomic, copy) NSString *serverTime;

@property (nonatomic, copy) NSString *accessTokenStr;

@property (nonatomic, strong) NSDictionary *userInfoDictionary;

@property (nonatomic, copy) NSString *schoolName;

@property (nonatomic, copy) NSString *userName;


@end

@implementation MyVideoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //_urlString = @"https://open.ys7.com/api/method";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
//    LoginViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
//    //loginVC.hidesBottomBarWhenPushed = YES;
//    //[self.navigationController pushViewController:loginVC animated:NO];
    //[self presentModalViewController:loginVC animated:NO];
    //[self presentViewController:loginVC animated:NO completion:nil];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    CGRect rect = [[self view] bounds];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
    [imageView setImage:[UIImage imageNamed:@"userlogin-background.png" ]];
    
    [self.view setBackgroundColor:[UIColor clearColor]];   //(1)
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    self.tableView.opaque = NO; //(2) (1,2)两行不要也行，背景图片也能显示
    self.tableView.backgroundView = imageView;
    
    if(!_remoteCameraList)
    {
        _remoteCameraList = [NSMutableArray new];
    }
    
    if (!_userCameraList) {
        _userCameraList = [NSMutableArray new];
    }
    
    
    _userInfoDictionary = [Config get_user_info_dictionary];
    

    _localCameraList = _userInfoDictionary[@"result"][@"CameraList"];
    
    
    NSLog(@"Video list json:%@", _userInfoDictionary);
    NSLog(@"Local camera list:%@", _localCameraList);
    
    _schoolName = [Config get_school_name];
    
    self.navigationItem.title = _schoolName;
    
    [Config save_needrefreshAction:NO];
    
    [self GetServerTime];
    
    
//    if([GlobalKit shareKit].accessToken)
//    {
//        [EZOpenSDK setAccessToken:[GlobalKit shareKit].accessToken];
//        [self addRefreshKit];
//    }
//    else
//    {
//        [EZOpenSDK openLoginPage:^(EZAccessToken *accessToken) {
//            [[GlobalKit shareKit] setAccessToken:accessToken.accessToken];
//            [EZOpenSDK setAccessToken:accessToken.accessToken];
//            [self addRefreshKit];
//        }];
//        return;
//    }

//    [[GlobalKit shareKit] setAccessToken:@"at.5j9b2er63ueasm8s5smh567g8aw9qjej-7lgfcqc103-1ollfzi-klnn07z52"];
//    [EZOpenSDK setAccessToken:@"at.5j9b2er63ueasm8s5smh567g8aw9qjej-7lgfcqc103-1ollfzi-klnn07z52"];
//    [self addRefreshKit];
    
//    CGRect rect = [[self view] bounds];
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
//    [imageView setImage:[UIImage imageNamed:@"userlogin-background.png" ]];
//    
//    [self.view setBackgroundColor:[UIColor clearColor]];   //(1)
//    [self.tableView setBackgroundColor:[UIColor clearColor]];
////    self.tableView.opaque = NO; //(2) (1,2)两行不要也行，背景图片也能显示
//    self.tableView.backgroundView = imageView;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if([Config get_needrefreshAction])
    {
        
        if(!_remoteCameraList)
        {
            _remoteCameraList = [NSMutableArray new];
        }
        
        if (!_userCameraList) {
            _userCameraList = [NSMutableArray new];
        }
        
        _userInfoDictionary = [Config get_user_info_dictionary];
        
        _localCameraList = _userInfoDictionary[@"result"][@"CameraList"];
        
        
        NSLog(@"Video list json:%@", _userInfoDictionary);
        NSLog(@"Local camera list:%@", _localCameraList);
        
        _schoolName = [Config get_school_name];
        
       self.navigationItem.title = _schoolName;
        
        [Config save_needrefreshAction:NO];
        
        [self GetServerTime];
    }

    
    
    
//
//    
//    if([GlobalKit shareKit].accessToken)
//    {
//        [EZOpenSDK setAccessToken:[GlobalKit shareKit].accessToken];
//        [self addRefreshKit];
//    }
//    else
//    {
//        [EZOpenSDK openLoginPage:^(EZAccessToken *accessToken) {
//            [[GlobalKit shareKit] setAccessToken:accessToken.accessToken];
//            [EZOpenSDK setAccessToken:accessToken.accessToken];
//            [self addRefreshKit];
//        }];
//        return;
//    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_userCameraList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   // UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
 
    VideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyVideoCellIdentifier" forIndexPath:indexPath];
    
    //[cell setVideoListItem:[_dataArray objectAtIndex:indexPath.row]];
    
    [cell setCameraInfo:[_userCameraList objectAtIndexCheck:indexPath.row]];
    cell.parentViewController = self;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell setBackgroundColor:[UIColor clearColor]];

    
    return cell;
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

#pragma mark - Custom Methods

- (void)addRefreshKit
{
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.currentPageIndex = 0;
        //获取设备列表接口
        [EZOpenSDK getCameraList:weakSelf.currentPageIndex++
                        pageSize:EZCameraListPageSize
                      completion:^(NSArray *cameraList, NSError *error) {
                          [weakSelf.remoteCameraList removeAllObjects];
                          [weakSelf.remoteCameraList addObjectsFromArray:cameraList];
                          [weakSelf.userCameraList removeAllObjects];
                          ///
                          for (int i = 0; i < [_localCameraList count]; i++) {
                              
                              NSString * localCameraId = [[_localCameraList objectAtIndexCheck:i] objectForKey:@"CameraId"];
                              
                              for (int j = 0; j < [_remoteCameraList count]; j++) {
                                  
                                  NSString * remoteCameraId = [[_remoteCameraList objectAtIndexCheck:j] cameraId];
                                  if ([localCameraId isEqualToString:remoteCameraId]) {
                                      [_userCameraList addObject:[_remoteCameraList objectAtIndexCheck:j]];
                                      break;
                                  }
                              }
                          }

                          NSLog(@"userCameraList ADD = %@", _userCameraList);
                          ///
                          [weakSelf.tableView reloadData];
                          [weakSelf.tableView.mj_header endRefreshing];
                          [weakSelf addFooter];
                          
                          dispatch_async(dispatch_get_main_queue(), ^{
                              [Config save_needrefreshAction:NO];
                              [_hud hide:YES];
                          });
                      }];
    }];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    
}

- (void)addFooter
{
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_footer  = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [EZOpenSDK getCameraList:weakSelf.currentPageIndex++
                        pageSize:EZCameraListPageSize
                      completion:^(NSArray *cameraList, NSError *error) {
                          if(cameraList.count == 0)
                          {
                              weakSelf.tableView.mj_footer.hidden = YES;
                              return;
                          }
                          
                          [weakSelf.remoteCameraList addObjectsFromArray:cameraList];
                          [weakSelf.userCameraList removeAllObjects];
                          ///
                          for (int i = 0; i < [_localCameraList count]; i++) {
                              
                              NSString * localCameraId = [[_localCameraList objectAtIndexCheck:i] objectForKey:@"CameraId"];
                              
                              for (int j = 0; j < [_remoteCameraList count]; j++) {
                                  
                                  NSString * remoteCameraId = [[_remoteCameraList objectAtIndexCheck:j] cameraId];
                                  if ([localCameraId isEqualToString:remoteCameraId]) {
                                      [_userCameraList addObject:[_remoteCameraList objectAtIndexCheck:j]];
                                  }
                              }
                          }
                          
                          NSLog(@"userCameraList ADD = %@", _userCameraList);
                          
                          [weakSelf.tableView reloadData];
                          [weakSelf.tableView.mj_footer endRefreshing];
                      }];
    }];
}

- (void)go2Play:(EZCameraInfo *)camera
{
    
    //判断当前网络状态
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    if(![camera isOnline])
    {
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"当前摄像头不在线，请观看其他摄像头" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    
    }
    else
    {
    
    if ([Config getWifiMode]) {
        if ([appDelegate isWifi])
        {
            if ([Config get_login_status]) {
                UIStoryboard *mineSB = [UIStoryboard storyboardWithName:@"MyVideoTableViewController" bundle:nil];
                EZLivePlayViewController *playController = [mineSB instantiateViewControllerWithIdentifier:@"PlayerController"];
                
                
                playController.hidesBottomBarWhenPushed = YES;
                [playController setCameraId:camera.cameraId];
                [playController setCameraName:camera.cameraName];
                [self.navigationController pushViewController:playController animated:NO];
            }
            else{
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
                LoginViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
                //loginVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:loginVC animated:NO];
            }

        }
        else{
            UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"当前不在WIFI网络下" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:okAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
    else
    {
        if ([Config get_login_status]) {
            UIStoryboard *mineSB = [UIStoryboard storyboardWithName:@"MyVideoTableViewController" bundle:nil];
            EZLivePlayViewController *playController = [mineSB instantiateViewControllerWithIdentifier:@"PlayerController"];
            
            
            playController.hidesBottomBarWhenPushed = YES;
            [playController setCameraId:camera.cameraId];
            [playController setCameraName:camera.cameraName];
            [self.navigationController pushViewController:playController animated:NO];
        }
        else{
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
            LoginViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            //loginVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:loginVC animated:NO];
            
        }

    }
    }

}

-(NSString*)DataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

- (void)GetServerTime
{
    dispatch_async(dispatch_get_main_queue(), ^{
         _hud = [Utils createHUD];
         _hud.labelText = @"数据加载中";
         _hud.userInteractionEnabled = NO;
    });

    
    //获取服务器时间
    NSString *url=@"https://open.ys7.com/api/time/get";
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *postBody=[NSMutableData data];
    [postBody appendData:[@"appKey=2fb8b1891e154de6996f637266bbc16d" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [request setHTTPBody:postBody];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(!error)
        {
            NSHTTPURLResponse* resPonse = (NSHTTPURLResponse*)response;
            NSLog(@"reponse1 code %ld", (long)[resPonse statusCode]);
            
            NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"Post1 dataStr = %@", dataStr);
            
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            
            //NSDictionary *result = [dict objectForKey:@"result"];
            _serverTime = dict[@"result"][@"data"][@"serverTime"];
            
            NSString *error=dict[@"result"][@"code"];
            
            NSLog(@"dict = %@", dict);
            NSLog(@"error = %@", error);
            NSLog(@"serverTime = %@", _serverTime);
            [self AFHttpRequestAccessToken];
            
        }
        else
        {
            NSLog(@"post1 error is :%@",error.localizedDescription);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [Config save_needrefreshAction:YES];
                [_hud hide:YES];
                _hud = [Utils createHUD];
                _hud.labelText = @"数据获取出错";
                _hud.userInteractionEnabled = NO;
                
                [_hud hide:YES afterDelay:1];
            });
        }
        
    }];
    
    [dataTask resume];
}

- (void)AFHttpRequestAccessToken
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //申明返回的结果是json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //如果报接受类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    //传入的参数

    NSString *phoneStr = @"phone:18990895233";
    NSString *methodStr = @"method:token/getAccessToken";
    NSString *serverTimeStr = [NSString stringWithFormat:@"time:%@", _serverTime];
    NSString *secretStr = [NSString stringWithFormat:@"secret:%@", SecretKey];
    
    NSString *signStr = [[NSString stringWithFormat:@"%@,%@,%@,%@", phoneStr,methodStr,serverTimeStr,secretStr] md5];
    
    
    NSDictionary *systemDic = @{@"key":AppKey, @"sign":signStr, @"time":_serverTime, @"ver":@"1.0"};
    
    
    NSDictionary *parameters4 = @{@"phone":@"18990895233"};
    
    //    NSDictionary *params = @{@"params":parameters4};
    
    NSDictionary *temp = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"123456",@"id",
                          systemDic,@"system",
                          @"token/getAccessToken", @"method",
                          parameters4, @"params",
                          nil];
    
    
    
    //你的接口地址
     NSString *url=@"https://open.ys7.com/api/method";
    //发送请求
        [manager POST:url parameters:temp success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            NSDictionary *responseDic = [NSDictionary dictionaryWithDictionary:responseObject];
            
            _accessTokenStr = responseDic[@"result"][@"data"][@"accessToken"];
            NSLog(@"AccessToken=%@", _accessTokenStr);
            [EZOpenSDK initLibWithAppKey:AppKey];
            [[GlobalKit shareKit] setAccessToken:_accessTokenStr];
            [EZOpenSDK setAccessToken:_accessTokenStr];
            [self addRefreshKit];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            dispatch_async(dispatch_get_main_queue(), ^{
                [Config save_needrefreshAction:YES];
                [_hud hide:YES];
                _hud = [Utils createHUD];
                _hud.labelText = @"数据获取出错";
                _hud.userInteractionEnabled = NO;
                
                [_hud hide:YES afterDelay:1];
            });
        }];
    
}

@end
