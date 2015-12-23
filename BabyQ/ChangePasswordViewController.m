//
//  ChangePasswordViewController.m
//  BabyQ
//
//  Created by jeremy on 12/15/15.
//  Copyright © 2015 Fuyou. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "UIColor+Util.h"
#import <ReactiveCocoa.h>
#import <MBProgressHUD.h>
#import "Utils.h"

@interface ChangePasswordViewController ()<UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, weak) IBOutlet UITextField *accountField;
@property (nonatomic, weak) IBOutlet UITextField *oldPasswordField;
@property (nonatomic, weak) IBOutlet UITextField *changePasswordField;
@property (nonatomic, weak) IBOutlet UITextField *surePasswordField;


@property (nonatomic, weak) IBOutlet UIButton *sureButton;

@property (nonatomic, strong) MBProgressHUD *hud;


@end

@implementation ChangePasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor themeColor];
    
    [self setUpSubviews];
    
    
    RACSignal *valid = [RACSignal combineLatest:@[_accountField.rac_textSignal, _oldPasswordField.rac_textSignal, _changePasswordField.rac_textSignal, _surePasswordField.rac_textSignal]
                                         reduce:^(NSString *account, NSString *oldpassword, NSString *changePassword, NSString *surePassword) {
                                             return @(account.length > 0 && changePassword.length > 0 && oldpassword.length > 0 && surePassword.length > 0 );
                                         }];
    RAC(_sureButton, enabled) = valid;
    RAC(_sureButton, alpha) = [valid map:^(NSNumber *b) {
        return b.boolValue ? @1: @0.4;
    }];
    
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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //[_hud hide:YES];
}



#pragma mark - about subviews

- (void)setUpSubviews
{
    _accountField.delegate = self;
    _oldPasswordField.delegate = self;
    _changePasswordField.delegate = self;
    _surePasswordField.delegate = self;
    
    [_accountField addTarget:self action:@selector(returnOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [_oldPasswordField addTarget:self action:@selector(returnOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [_changePasswordField addTarget:self action:@selector(returnOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [_surePasswordField addTarget:self action:@selector(returnOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    gesture.delegate = self;
    [self.view addGestureRecognizer:gesture];
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (![_accountField isFirstResponder] && ![_oldPasswordField isFirstResponder] && ![_changePasswordField isFirstResponder] && ![_surePasswordField isFirstResponder]) {
        return NO;
    }
    return YES;
}


#pragma mark - 键盘操作

- (void)hidenKeyboard
{
    [_accountField resignFirstResponder];
    [_oldPasswordField resignFirstResponder];
    [_changePasswordField resignFirstResponder];
    [_surePasswordField resignFirstResponder];
}

- (void)returnOnKeyboard:(UITextField *)sender
{
    if (sender == _accountField) {
        [_oldPasswordField becomeFirstResponder];
    } else if (sender == _oldPasswordField) {
        [_changePasswordField becomeFirstResponder];
    } else if (sender == _changePasswordField) {
        [_surePasswordField becomeFirstResponder];
    } else if (sender == _surePasswordField) {
        [self hidenKeyboard];
        if (_sureButton.enabled) {
            [self changeThePassword];
        }
        
    }
}

- (void)changeThePassword{
    
    NSString *inputusername = _accountField.text;
    NSString *inputOldPassword = _oldPasswordField.text;
    NSString *inputChangePassword = _changePasswordField.text;
    NSString *inputSurePassword = _surePasswordField.text;
    
    //
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"user" ofType:@"plist"];
    
    
    NSDictionary *user = nil;
    NSDictionary *data = nil;
    
    
    //获取应用程序沙盒的Documents目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    
    
    //得到完整的文件名
    NSString *filename=[plistPath1 stringByAppendingPathComponent:@"userinfo.plist"];
    
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    if ([fileMgr fileExistsAtPath:filename]) {
        
        data = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
    }
    else
    {
        data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        
        [data writeToFile:filename atomically:YES];
    }
    
    user = [data objectForKey:inputusername];
    
    
    if (user) { //用户存在，核对密码
        NSString *storePassword = [user objectForKey:@"password1"];
        
        if ([inputOldPassword isEqualToString:storePassword]) { //原始密码正确
            
            if ([inputChangePassword isEqualToString:inputSurePassword]) {
                
                //[data removeObjectForKey:inputusername];
                //[data writeToFile:plistPath atomically:YES];
                [user setValue:inputChangePassword forKey:@"password1"];
                //[data writeToFile:plistPath atomically:YES];
                
//                NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"user" ofType:@"plist"];
//                NSMutableDictionary *data2 = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
//               // NSDictionary *user1 = [data objectForKey:@"username1"];
//                NSLog(@"%@", data2);//直接打印数据。
                
                //获取应用程序沙盒的Documents目录
                NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
                NSString *plistPath1 = [paths objectAtIndex:0];
                
                
                //得到完整的文件名
                NSString *filename=[plistPath1 stringByAppendingPathComponent:@"userinfo.plist"];
                
                NSFileManager *fileMgr = [NSFileManager defaultManager];
                
                if (![fileMgr fileExistsAtPath:filename]) {
                    //测试数据
                    
                    //   NSDictionary *user1 = [data objectForKey:@"username1"];
                    NSLog(@"data＝＝＝%@", data);//直接打印数据。
                    //输入写入
                    [data writeToFile:filename atomically:YES];
                }
                else{
                    NSLog(@"data＝＝＝%@", data);//直接打印数据。
                    //输入写入
                    [data writeToFile:filename atomically:YES];
                    
                }
                
                _hud = [Utils createHUD];
                _hud.labelText = @"修改密码成功";
                _hud.userInteractionEnabled = NO;
                
                [_hud hide:YES afterDelay:2];
                
                //那怎么证明我的数据写入了呢？读出来看看
                NSMutableDictionary *data1 = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
                NSLog(@"data1====%@", data1);
                
               // [NSThread sleepForTimeInterval:2.0];
                
                dispatch_time_t when=dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC));
                
                dispatch_after(when, dispatch_get_main_queue(), ^{
                    
                [self.navigationController popViewControllerAnimated:NO];
                    
                });
                
                
            }
            else
            {
                _hud = [Utils createHUD];
                _hud.labelText = @"两次输入密码不一致,请重新输入";
                _hud.userInteractionEnabled = NO;
                
                [_hud hide:YES afterDelay:2];
            }
            
        }
        else{     //原始密码错误
            _hud = [Utils createHUD];
            _hud.labelText = @"原始密码错误";
            _hud.userInteractionEnabled = NO;
            
            [_hud hide:YES afterDelay:1];
        }
        
    }
    else{ //用户不存在
        _hud = [Utils createHUD];
        _hud.labelText = @"用户名错误";
        _hud.userInteractionEnabled = NO;
        
        [_hud hide:YES afterDelay:1];
    }
}

@end
