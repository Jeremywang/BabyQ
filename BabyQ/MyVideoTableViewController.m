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

#define EZCameraListPageSize 10

@interface MyVideoTableViewController ()

@property (nonatomic, strong) NSMutableArray *cameraList;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic) NSInteger currentPageIndex;


@end

@implementation MyVideoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    if(!_cameraList)
        _cameraList = [NSMutableArray new];
    
    if([GlobalKit shareKit].accessToken)
    {
        [EZOpenSDK setAccessToken:[GlobalKit shareKit].accessToken];
        [self addRefreshKit];
    }
    else
    {
        [EZOpenSDK openLoginPage:^(EZAccessToken *accessToken) {
            [[GlobalKit shareKit] setAccessToken:accessToken.accessToken];
            [EZOpenSDK setAccessToken:accessToken.accessToken];
            [self addRefreshKit];
        }];
        return;
    }

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
    if(_needRefresh)
    {
        _needRefresh = NO;
        [self.tableView.mj_header beginRefreshing];
    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    CGRect rect = [[self view] bounds];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
    [imageView setImage:[UIImage imageNamed:@"userlogin-background.png" ]];
    
    [self.view setBackgroundColor:[UIColor clearColor]];   //(1)
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    self.tableView.opaque = NO; //(2) (1,2)两行不要也行，背景图片也能显示
    self.tableView.backgroundView = imageView;
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
    return [_cameraList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   // UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
 
    VideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyVideoCellIdentifier" forIndexPath:indexPath];
    
    //[cell setVideoListItem:[_dataArray objectAtIndex:indexPath.row]];
    
    [cell setCameraInfo:[_cameraList dd_objectAtIndex:indexPath.row]];
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
                          [weakSelf.cameraList removeAllObjects];
                          [weakSelf.cameraList addObjectsFromArray:cameraList];
                          [weakSelf.tableView reloadData];
                          [weakSelf.tableView.mj_header endRefreshing];
                          [weakSelf addFooter];
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
                          [weakSelf.cameraList addObjectsFromArray:cameraList];
                          [weakSelf.tableView reloadData];
                          [weakSelf.tableView.mj_footer endRefreshing];
                      }];
    }];
}

- (void)go2Play:(EZCameraInfo *)camera
{
    //判断当前网络状态
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    
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

@end
