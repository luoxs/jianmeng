//
//  ViewController.m
//  jianmeng
//
//  Created by 罗 显松 on 2017/2/20.
//  Copyright © 2017年 luoxs. All rights reserved.
//

#import "ViewController.h"
#import "MenuView.h"
#import "LeftMenuView.h"
#import "configTableViewController.h"

@interface ViewController ()<HomeMenuViewDelegate>

@property (nonatomic ,strong)MenuView   * menu;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
    
    
    LeftMenuView *demo = [[LeftMenuView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width * 0.8, [[UIScreen mainScreen] bounds].size.height)];
    demo.customDelegate = self;
    
    self.menu = [[MenuView alloc]initWithDependencyView:self.view MenuView:demo isShowCoverView:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)LeftMenuViewClick:(NSInteger)tag{
    [self.menu hidenWithAnimation];
    
    NSLog(@"tag = %lu",tag);
    
    if (tag == 3) {
        [self performSegueWithIdentifier:@"toConfig" sender:self];
    }
}

- (IBAction)leftNavAction:(id)sender {
    [self.menu show];
}

@end
