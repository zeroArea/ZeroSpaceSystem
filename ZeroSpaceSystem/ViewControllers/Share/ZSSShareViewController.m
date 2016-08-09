//
//  ZSSShareViewController.m
//  ZeroSpaceSystem
//
//  Created by NEO on 16/7/27.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "ZSSShareViewController.h"

#import "ZSSUIButton.h"

#import "ZSSHTTPServer.h"
#import "ZSSIPAddress.h"

#import <CocoaLumberjack/DDLog.h>
#import <CocoaLumberjack/DDTTYLogger.h>

// Log levels: off, error, warn, info, verbose
static const int ddLogLevel = LOG_LEVEL_VERBOSE;

@interface ZSSShareViewController ()

@end

@implementation ZSSShareViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"主页";
    
    [[ZSSHTTPServer shareInstance] startSuccess:^{
        
        DDLogInfo(@"http://%@:%hu", [ZSSIPAddress getIPAddress], [[ZSSHTTPServer shareInstance] getServerPort]);
        
    } failure:^(id error) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"警告"
                                                                                 message:@"服务启动失败,请稍后再试!"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定"
                                                         style:UIAlertActionStyleCancel
                                                       handler:nil];
        
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }];
}

- (void)didReceiveMemoryWarning
{
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

@end
