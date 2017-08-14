//
//  AboutUsViewController.m
//  MeiXun
//
//  Created by taotao on 2017/8/14.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *version = [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    version = [NSString stringWithFormat:@"美讯V%@",version];
    self.versionLabel.text = version;
}


@end
