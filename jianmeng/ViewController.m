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
#import <QMapKit/QMapKit.h>

@interface ViewController ()<HomeMenuViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic ,strong)MenuView   * menu;
@property (nonatomic,strong) QMapView *mapView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
    LeftMenuView *demo = [[LeftMenuView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width * 0.8, [[UIScreen mainScreen] bounds].size.height)];
    demo.customDelegate = self;
    self.menu = [[MenuView alloc]initWithDependencyView:self.view MenuView:demo isShowCoverView:YES];
    
    [self initMap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)LeftMenuViewClick:(NSInteger)tag{
    [self.menu hidenWithAnimation];
    
    //NSLog(@"tag = %lu",tag);
    
    if (tag == 3) {
        [self performSegueWithIdentifier:@"toConfig" sender:self];
    }
}

- (IBAction)leftNavAction:(id)sender {
    [self.menu show];
}

- (void)initMap {
    _mapView = [[QMapView alloc]
                initWithFrame: CGRectMake(0,
                                          CGRectGetMaxY(self.navigationController.navigationBar.frame),
                                          CGRectGetWidth(self.view.frame),
                                          CGRectGetHeight(self.view.frame) - CGRectGetMaxY(self.navigationController.navigationBar.frame))];
    [self.view addSubview:self.mapView];
    //初始化设置地图中心点坐标需要异步加入到主队列
    dispatch_async(dispatch_get_main_queue(), ^{
        [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(39.963438, 116.316376)
                            zoomLevel:12.01
                             animated:NO];
    });
    //由于zoomLevel的调用区间是左闭右开的，在调用某一级别的图片时，
    //实际调用的是上级的最大缩放级别，底图有可能会看到锯齿，
    //此时可以在缩放级别上加上0.01使用高级别底图
    [_mapView setZoomLevel:12.01];
    
    //添加手势识别
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc]
                                                 initWithTarget:self
                                                 action:@selector(gestureAction:)];
    [gestureRecognizer setDelegate:self];
    [_mapView addGestureRecognizer:gestureRecognizer];
}
-(void)gestureAction:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint point = [gestureRecognizer locationOfTouch:0 inView:_mapView];
    NSLog(@"Tap at:%f,%f", point.x, point.y);
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
