//
//  LoginViewController.m
//  iosapp
//
//  Created by chenhaoxiang on 11/4/14.
//  Copyright (c) 2014 oschina. All rights reserved.
//

#import "LoginViewController.h"
//#import "UserDetailsViewController.h"
//#import "OSCAPI.h"
//#import "OSCUser.h"
#import "Utils.h"
#import "Config.h"
//#import "OSCThread.h"
#import "UIImage+FontAwesome.h"
#import "AppDelegate.h"
#import "UIColor+Util.h"

#import <ReactiveCocoa.h>
#import <MBProgressHUD.h>
#import <RESideMenu.h>
#import "AppDelegate.h"
#import "RootViewController.h"
#import <AFNetworking.h>


static NSString * const kShowAccountOperation = @"ShowAccountOperation";


@interface LoginViewController () <UITextFieldDelegate, UIGestureRecognizerDelegate, UIAlertViewDelegate>

@property (nonatomic, weak) IBOutlet UITextField *accountField;
@property (nonatomic, weak) IBOutlet UITextField *passwordField;
@property (nonatomic, weak) IBOutlet UIButton *loginButton;

//@property (nonatomic, weak) IBOutlet UIButton *qqButton;
//@property (nonatomic, weak) IBOutlet UIButton *wechatButton;
//@property (nonatomic, weak) IBOutlet NSLayoutConstraint *qqButtonRight;
//@property (nonatomic, weak) IBOutlet NSLayoutConstraint *qqButtonWidth;
//@property (nonatomic, weak) IBOutlet NSLayoutConstraint *wechatButtonRight;
//@property (nonatomic, weak) IBOutlet NSLayoutConstraint *wechatButtonWidth;

@property (nonatomic, strong) MBProgressHUD *hud;


@property (nonatomic, copy) NSString *catalog;
@property (nonatomic, copy) NSString *info;

@property (nonatomic, copy) NSString *inputusername;
@property (nonatomic, copy) NSString *inputpassword;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor themeColor];
    
    [self setUpSubviews];
    
//    NSArray *accountAndPassword = [Config getOwnAccountAndPassword];
//    _accountField.text = accountAndPassword? accountAndPassword[0] : @"";
//    _passwordField.text = accountAndPassword? accountAndPassword[1] : @"";
    
    RACSignal *valid = [RACSignal combineLatest:@[_accountField.rac_textSignal, _passwordField.rac_textSignal]
                                         reduce:^(NSString *account, NSString *password) {
                                             return @(account.length > 0 && password.length > 0);
                                         }];
    RAC(_loginButton, enabled) = valid;
    RAC(_loginButton, alpha) = [valid map:^(NSNumber *b) {
        return b.boolValue ? @1: @0.4;
    }];
    
    //AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //appDelegate.loginDelegate = self;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_hud hide:YES];
}



#pragma mark - about subviews

- (void)setUpSubviews
{
    _accountField.delegate = self;
    _passwordField.delegate = self;
    
    [_accountField addTarget:self action:@selector(returnOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [_passwordField addTarget:self action:@selector(returnOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    gesture.delegate = self;
    [self.view addGestureRecognizer:gesture];
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (![_accountField isFirstResponder] && ![_passwordField isFirstResponder]) {
        return NO;
    }
    return YES;
}


#pragma mark - 键盘操作

- (void)hidenKeyboard
{
    [_accountField resignFirstResponder];
    [_passwordField resignFirstResponder];
}

- (void)returnOnKeyboard:(UITextField *)sender
{
    if (sender == _accountField) {
        [_passwordField becomeFirstResponder];
    } else if (sender == _passwordField) {
        [self hidenKeyboard];
        if (_loginButton.enabled) {
            [self login];
        }
    }
}

- (IBAction)login
{
    _inputusername = _accountField.text;
    _inputpassword = _passwordField.text;
    
    _hud = [Utils createHUD];
    _hud.labelText = @"登录中";
    _hud.userInteractionEnabled = NO;
    
    [Config save_needrefreshAction:YES];
    
    [self LoginRequest];
    

//    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"user" ofType:@"plist"];
//    
//    NSDictionary *user = nil;
//    
//    //获取应用程序沙盒的Documents目录
//    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
//    NSString *plistPath1 = [paths objectAtIndex:0];
//    
//    
//    //得到完整的文件名
//    NSString *filename=[plistPath1 stringByAppendingPathComponent:@"userinfo.plist"];
//    
//    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
//    
//    NSFileManager *fileMgr = [NSFileManager defaultManager];
//    
//    if ([fileMgr fileExistsAtPath:filename]) {
//    
//        user = [data objectForKey:_inputusername];
//        
//    }
//    else
//    {
//        NSMutableDictionary *data2 = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
//        
//        user = [data2 objectForKey:_inputusername];
//        
//        [data2 writeToFile:filename atomically:YES];
//        
//    }
//    
//    if (user) { //用户存在，核对密码
//        NSString *storePassword = [user objectForKey:@"password1"];
//        
//        if ([_inputpassword isEqualToString:storePassword]) { //密码正确
//            
//            [Config save_login_status:YES];
//            _hud = [Utils createHUD];
//            _hud.labelText = @"登录成功";
//            _hud.userInteractionEnabled = NO;
//            
//            [_hud hide:YES afterDelay:0.5];
//            
//            dispatch_time_t when=dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
//            
//            dispatch_after(when, dispatch_get_main_queue(), ^{
//            
//                 //[self.navigationController popViewControllerAnimated:NO];
//               RootViewController *rootViewController = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).rootViewController;
//                
//                if (rootViewController.originalContentViewController) {
//                    rootViewController.contentViewController = rootViewController.originalContentViewController;
//                }
//                else
//                {
//                    rootViewController.originalContentViewController = [rootViewController.storyboard instantiateViewControllerWithIdentifier:@"contentViewController"];
//                    rootViewController.contentViewController = rootViewController.originalContentViewController;
//                }
//
//             });
//            
//        }
//        else{     //密码错误
//            [Config save_login_status:false];
//            _hud = [Utils createHUD];
//            _hud.labelText = @"密码错误";
//            _hud.userInteractionEnabled = NO;
//            
//            [_hud hide:YES afterDelay:1];
//        }
//        
//    }
//    else{ //用户不存在
//        [Config save_login_status:FALSE];
//        _hud = [Utils createHUD];
//        _hud.labelText = @"用户名错误";
//        _hud.userInteractionEnabled = NO;
//        
//        [_hud hide:YES afterDelay:1];
//    }
    
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager OSCManager];
//    
//    [manager POST:[NSString stringWithFormat:@"%@%@", OSCAPI_HTTPS_PREFIX, OSCAPI_LOGIN_VALIDATE]
//       parameters:@{@"username" : _accountField.text, @"pwd" : _passwordField.text, @"keep_login" : @(1)}
//          success:^(AFHTTPRequestOperation *operation, ONOXMLDocument *responseObject) {
//              ONOXMLElement *result = [responseObject.rootElement firstChildWithTag:@"result"];
//              
//              NSInteger errorCode = [[[result firstChildWithTag:@"errorCode"] numberValue] integerValue];
//              if (!errorCode) {
//                  NSString *errorMessage = [[result firstChildWithTag:@"errorMessage"] stringValue];
//                  
//                  _hud.mode = MBProgressHUDModeCustomView;
//                  _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
//                  _hud.labelText = [NSString stringWithFormat:@"错误：%@", errorMessage];
//                  [_hud hide:YES afterDelay:1];
//                  
//                  return;
//              }
//              
//              [Config saveOwnAccount:_accountField.text andPassword:_passwordField.text];
//              ONOXMLElement *userXML = [responseObject.rootElement firstChildWithTag:@"user"];
//              
//              [self renewUserWithXML:userXML];
//          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//              _hud.mode = MBProgressHUDModeCustomView;
//              _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
//              _hud.labelText = [@(operation.response.statusCode) stringValue];
//              _hud.detailsLabelText = error.userInfo[NSLocalizedDescriptionKey];
//              
//              [_hud hide:YES afterDelay:1];
//          }
//     ];
}



/*** 不知为何有时退出应用后，cookie不保存，所以这里手动保存cookie ***/

- (void)saveCookies
{
    NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject: [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject: cookiesData forKey: @"sessionCookies"];
    [defaults synchronize];
    
}



//#pragma mark - 第三方登录
//#pragma mark QQ登录
//
//- (IBAction)loginFromQQ:(id)sender
//{
//    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"100942993" andDelegate:self];
//    [_tencentOAuth authorize:@[kOPEN_PERMISSION_GET_INFO, kOPEN_PERMISSION_GET_USER_INFO, kOPEN_PERMISSION_GET_SIMPLE_USER_INFO]];
//}
//
//- (void)tencentDidNotLogin:(BOOL)cancelled
//{
//    NSLog(@"登录失败");
//}
//
//- (void)tencentDidLogin
//{
//    if (_tencentOAuth.accessToken && [_tencentOAuth.accessToken length]) {
//        NSString *userInfo = [NSString stringWithFormat:@"{"
//                                                        @"\"openid\": \"%@\", "
//                                                        @"\"access_token\": \"%@\""
//                                                        @"}",
//                                                        _tencentOAuth.openId, _tencentOAuth.accessToken];
//        
//        [self loginWithCatalog:@"qq" andAccountInfo:userInfo];
//    }
//}
//
//- (void)tencentDidNotNetWork
//{
//    NSLog(@"请检查网络");
//}


//#pragma mark 微信登录
//
//- (IBAction)loginFromWechat:(id)sender
//{
//    SendAuthReq *req = [SendAuthReq new];
//    req.scope = @"snsapi_userinfo" ;
//    req.state = @"osc_wechat_login" ;
//    //第三方向微信终端发送一个SendAuthReq消息结构
//    [WXApi sendReq:req];
//}


//- (void)onResp:(BaseResp *)resp
//{
//    if ([resp isKindOfClass:[SendAuthResp class]]) {
//        if (resp.errCode != 0) {return;}
//        
//        SendAuthResp *temp = (SendAuthResp *)resp;
//        
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
//        [manager GET:[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token"]
//          parameters:@{
//                       @"appid": @"wxa8213dc827399101",
//                       @"secret": @"5c716417ce72ff69d8cf0c43572c9284",
//                       @"code": temp.code,
//                       @"grant_type": @"authorization_code",
//                       }
//             success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                 [self loginWithCatalog:@"wechat" andAccountInfo:operation.responseString];
//             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                 NSLog(@"error: %@", error);
//             }];
//    }
//}


//#pragma mark 微博登录
//
//- (IBAction)loginFromWeibo:(id)sender
//{
//    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
//    request.redirectURI = @"http://sns.whalecloud.com/sina2/callback";
//    request.scope = @"all";
//    
//    [WeiboSDK sendRequest:request];
//}
//
//- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
//{
//    if ([response isKindOfClass:WBAuthorizeResponse.class]) {
//        WBAuthorizeResponse *authResponse = (WBAuthorizeResponse *)response;
//        
//        if (!authResponse.userID) {return;}
//        NSString *info = [NSString stringWithFormat:@"{"
//                                                    @"\"openid\": %@,\n"
//                                                    @"\"access_token\": \"%@\",\n"
//                                                    @"\"refresh_token\": \"%@\",\n"
//                                                    @"\"expires_in\": \"%@\""
//                                                    @"}",
//                                                    authResponse.userID,
//                                                    authResponse.accessToken,
//                                                    authResponse.refreshToken,
//                                                    authResponse.expirationDate];
//        
//        [self loginWithCatalog:@"weibo" andAccountInfo:info];
//    }
//}
//
//- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
//{
//    
//}


//#pragma mark 处理第三方账号
//
//- (void)loginWithCatalog:(NSString *)catalog andAccountInfo:(NSString *)info
//{
//    _catalog = [catalog copy];
//    _info = [info copy];
//    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager OSCManager];
//    
//    [manager POST:[NSString stringWithFormat:@"%@%@", OSCAPI_HTTPS_PREFIX, OSCAPI_OPENID_LOGIN]
//       parameters:@{
//                    @"catalog": catalog,
//                    @"openid_info": info,
//                    }
//          success:^(AFHTTPRequestOperation *operation, ONOXMLDocument *responseObject) {
//              ONOXMLElement *result = [responseObject.rootElement firstChildWithTag:@"result"];
//              int errorCode = [result firstChildWithTag:@"errorCode"].numberValue.intValue;
//              
//              if (errorCode == 1) {
//                  ONOXMLElement *userXML = [responseObject.rootElement firstChildWithTag:@"user"];
//                  
//                  [self renewUserWithXML:userXML];
//              } else {
//                  [self showOperationAlertView];
//              }
//          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//              MBProgressHUD *hud = [Utils createHUD];
//              hud.mode = MBProgressHUDModeCustomView;
//              hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
//              hud.labelText = [@(operation.response.statusCode) stringValue];
//              hud.detailsLabelText = error.userInfo[NSLocalizedDescriptionKey];
//              
//              [hud hide:YES afterDelay:1];
//          }];
//}


//- (void)registerAcount
//{
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager OSCManager];
//    [manager POST:[NSString stringWithFormat:@"%@%@", OSCAPI_HTTPS_PREFIX, OSCAPI_OPENID_REGISTER]
//       parameters:@{
//                    @"catalog": _catalog,
//                    @"openid_info": _info,
//                    }
//          success:^(AFHTTPRequestOperation *operation, ONOXMLDocument *responseObject) {
//              ONOXMLElement *result = [responseObject.rootElement firstChildWithTag:@"result"];
//              int errorCode = [result firstChildWithTag:@"errorCode"].numberValue.intValue;
//              NSString *errorMessage = [result firstChildWithTag:@"errorMessage"].stringValue;
//              
//              if (errorCode == 1) {
//                  ONOXMLElement *userXML = [responseObject.rootElement firstChildWithTag:@"user"];
//                  
//                  [self renewUserWithXML:userXML];
//              } else {
//                  MBProgressHUD *hud = [Utils createHUD];
//                  hud.mode = MBProgressHUDModeCustomView;
//                  hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
//                  hud.detailsLabelText = errorMessage;
//                  
//                  [hud hide:YES afterDelay:1];
//              }
//          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//              MBProgressHUD *hud = [Utils createHUD];
//              hud.mode = MBProgressHUDModeCustomView;
//              hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
//              hud.labelText = [@(operation.response.statusCode) stringValue];
//              hud.detailsLabelText = error.userInfo[NSLocalizedDescriptionKey];
//              
//              [hud hide:YES afterDelay:1];
//          }];
//}


//- (void)accountBinding
//{
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager OSCManager];
//    [manager POST:[NSString stringWithFormat:@"%@%@", OSCAPI_HTTPS_PREFIX, OSCAPI_OPENID_BINDING]
//       parameters:@{
//                    @"catalog": _catalog,
//                    @"openid_info": _info,
//                    @"username": _account,
//                    @"pwd": _password,
//                    }
//          success:^(AFHTTPRequestOperation *operation, ONOXMLDocument *responseObject) {
//              ONOXMLElement *result = [responseObject.rootElement firstChildWithTag:@"result"];
//              int errorCode = [result firstChildWithTag:@"errorCode"].numberValue.intValue;
//              NSString *errorMessage = [result firstChildWithTag:@"errorMessage"].stringValue;
//              
//              if (errorCode == 1) {
//                  ONOXMLElement *userXML = [responseObject.rootElement firstChildWithTag:@"user"];
//                  
//                  [self renewUserWithXML:userXML];
//              } else {
//                  MBProgressHUD *hud = [Utils createHUD];
//                  hud.mode = MBProgressHUDModeCustomView;
//                  hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
//                  hud.detailsLabelText = errorMessage;
//                  
//                  [hud hide:YES afterDelay:1];
//              }
//              
//          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//              MBProgressHUD *hud = [Utils createHUD];
//              hud.mode = MBProgressHUDModeCustomView;
//              hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
//              hud.labelText = [@(operation.response.statusCode) stringValue];
//              hud.detailsLabelText = error.userInfo[NSLocalizedDescriptionKey];
//              
//              [hud hide:YES afterDelay:1];
//          }];
//}


//- (void)renewUserWithXML:(ONOXMLElement *)xml
//{    
//    [Config saveProfile:[[OSCUser alloc] initWithXML:xml]];
//    
//    [OSCThread startPollingNotice];
//    
//    [self saveCookies];
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"userRefresh" object:@(YES)];
//    [self.navigationController popViewControllerAnimated:YES];
//}


//- (void)showOperationAlertView
//{
//    UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"第三方登录"
//                                                                message:nil
//                                                               delegate:self
//                                                      cancelButtonTitle:@"取消"
//                                                      otherButtonTitles:@"绑定已有账号", @"快速创建新账号", nil];
//    alerView.tag = 1;
//    alerView.delegate = self;
//    [alerView show];
//}
//
//
//#pragma mark - UIAlertViewDelegate
//
//#warning From ios 8.0 onward UIAlertView is deprecated, 以后应改用UIAlertController
//
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == alertView.cancelButtonIndex) {return;}
//    
//    if (alertView.tag == 1) {
//        if (buttonIndex == 2) {
//            [self registerAcount];
//        } else {
//            return;
//        }
//    } else if (alertView.tag == 2) {
//        _account = [alertView textFieldAtIndex:0].text;
//        _password = [alertView textFieldAtIndex:1].text;
//        
//        [self accountBinding];
//    }
//}

//- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
//{
//    if (alertView.tag != 2) {return YES;}
//    
//    return ([alertView textFieldAtIndex:0].text.length && [alertView textFieldAtIndex:1].text.length);
//}
//
//- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
//{
//    if (alertView.tag == 1 && buttonIndex == 1) {
//        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"绑定已有账号"
//                                                           message:@""
//                                                          delegate:self
//                                                 cancelButtonTitle:@"取消"
//                                                 otherButtonTitles:@"确认", nil];
//        
//        alerView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
//        alerView.tag = 2;
//        alerView.delegate = self;
//        [alerView show];
//    }
//}

- (void)LoginRequest
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //申明返回的结果是json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //如果报接受类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    //传入的参数
    
    
    NSString *dataString = [NSString stringWithFormat:@"{accountId:%@,pwd:%@}", _inputusername, _inputpassword];
    
    
    NSDictionary *requestDic =@{ @"sessionId":@"test",
                                 @"token":@"test",
                                 @"type":@"ios",
                                 @"data": dataString
                                 };
    
    //你的接口地址
    //NSString *url=@"http://61.188.188.54:8923/web_api/Account/UserLogin";
    NSString *url=@"http://101.200.165.91:8923/web_api/Account/UserLogin";
    //发送请求
    [manager POST:url parameters:requestDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [_hud hide:YES];
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *responseDic = [NSDictionary dictionaryWithDictionary:responseObject];
        
        NSLog(@"responseDic: %@", responseDic);
        
        NSInteger errorCode = [[responseDic objectForKey:@"code"] integerValue];
        
        if (errorCode == 200) {
            [Config save_user_info_dictionary:responseDic];
            [Config save_login_status:YES];

            
            NSString * userName = responseDic[@"result"][@"name"];
            [Config save_user_name:userName];
            
            NSString * schoolName = responseDic[@"result"][@"Schoolname"];
            [Config save_school_name:schoolName];
            
            _hud = [Utils createHUD];
            _hud.labelText = @"登录成功";
            _hud.userInteractionEnabled = NO;
            [_hud hide:YES afterDelay:0.8];
            
            
            
            
            dispatch_time_t when=dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC));
            
            dispatch_after(when, dispatch_get_main_queue(), ^{
                RootViewController *rootViewController = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).rootViewController;
                
                if (rootViewController.originalContentViewController) {
                    rootViewController.contentViewController = rootViewController.originalContentViewController;
                }
                else{
                    rootViewController.originalContentViewController = [rootViewController.storyboard instantiateViewControllerWithIdentifier:@"contentViewController"];
                    rootViewController.contentViewController = rootViewController.originalContentViewController;
                }
                
            });
        } else if (errorCode == 101){
            _hud = [Utils createHUD];
            _hud.labelText = @"密码错误";
            _hud.userInteractionEnabled = NO;
            
            [_hud hide:YES afterDelay:1];
            
        } else if (errorCode == 102){
            _hud = [Utils createHUD];
            _hud.labelText = @"用户名错误";
            _hud.userInteractionEnabled = NO;
            
            [_hud hide:YES afterDelay:1];
        } else if (errorCode == 103) {
            _hud = [Utils createHUD];
            _hud.labelText = @"用户名权限过期";
            _hud.userInteractionEnabled = NO;
            
            [_hud hide:YES afterDelay:1];
        } else if (errorCode == 104) {
            _hud = [Utils createHUD];
            _hud.labelText = @"你还没有摄像头权限,请联系系统管理员";
            _hud.userInteractionEnabled = NO;
            
            [_hud hide:YES afterDelay:1];
        
        } else {
            _hud = [Utils createHUD];
            _hud.labelText = @"请联系系统管理员";
            _hud.userInteractionEnabled = NO;
            
            [_hud hide:YES afterDelay:1];
        }
        

        
//        _accessTokenStr = responseDic[@"result"][@"data"][@"accessToken"];
//        NSLog(@"AccessToken=%@", _accessTokenStr);
//        [EZOpenSDK initLibWithAppKey:AppKey];
//        [[GlobalKit shareKit] setAccessToken:_accessTokenStr];
//        [EZOpenSDK setAccessToken:_accessTokenStr];
//        [self addRefreshKit];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        [_hud hide:YES];
        _hud = [Utils createHUD];
        _hud.labelText = @"服务器链接超时";
        _hud.userInteractionEnabled = NO;
        
        [_hud hide:YES afterDelay:1];
        
//        dispatch_time_t when=dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC));
//        
//        dispatch_after(when, dispatch_get_main_queue(), ^{
//
//
//        });
    }];
    
}



@end
