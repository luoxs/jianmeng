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
#import "CustomAnnotationView.h"

@interface ViewController ()<HomeMenuViewDelegate,UIGestureRecognizerDelegate,QMapViewDelegate>

@property (nonatomic ,strong)MenuView   * menu;
@property (nonatomic,strong) QMapView *mapView;
@property (nonatomic, strong) NSArray *annotations;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
    LeftMenuView *menuView = [[LeftMenuView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width * 0.7, [[UIScreen mainScreen] bounds].size.height)];
    menuView.customDelegate = self;
    self.menu = [[MenuView alloc]initWithDependencyView:self.view MenuView:menuView isShowCoverView:YES];
    
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
    _mapView.delegate=self;
    
    [self.view addSubview:self.mapView];
    //初始化设置地图中心点坐标需要异步加入到主队列
    /* 原始设置，北京
    dispatch_async(dispatch_get_main_queue(), ^{
        [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(39.963438, 116.316376)
                            zoomLevel:12.01
                             animated:NO];  
    });
     */
    dispatch_async(dispatch_get_main_queue(), ^{
        [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(23.0358064309,113.1419682762)
                            zoomLevel:13.01
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
    
    [self initAnnotations];
    
}
-(void)gestureAction:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint point = [gestureRecognizer locationOfTouch:0 inView:_mapView];
    NSLog(@"Tap at:%f,%f", point.x, point.y);
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

-(IBAction)backFormConfig:(UIStoryboardSegue *)sender{
    [self.menu show];
}

- (void) initAnnotations {
    QPointAnnotation *baoli = [[QPointAnnotation alloc] init];
    baoli.title = @"保利洲际酒店";
    baoli.subtitle=@"广东省佛山市南海区灯湖东路20号";
    baoli.coordinate = CLLocationCoordinate2DMake(23.0569340285,113.1480859018);
    
    QPointAnnotation *xierdun = [[QPointAnnotation alloc] init];
    xierdun.title = @"希尔顿花园酒店";
    xierdun.subtitle=@"广东省佛山市南海区桂澜中路辅路";
    xierdun.coordinate = CLLocationCoordinate2DMake(23.0453936844,113.1563453134);
    
    QPointAnnotation *xilaideng = [[QPointAnnotation alloc] init];
    xilaideng.title = @"喜来登大酒店";
    xilaideng.subtitle = @"广东省佛山市禅城区文华北路77";
    xilaideng.coordinate = CLLocationCoordinate2DMake(23.0453749767,113.1272211450);
    
    _annotations = [NSArray arrayWithObjects:baoli, xierdun, xilaideng, nil];
    
    [_mapView addAnnotations:_annotations];
}

#pragma mark - Life Circle
-(instancetype)init {
    self = [super init];
    if (self) {
        [self initAnnotations];
    }
    return self;
}

#pragma mark - actions
-(void)calloutButtonAction{
    [self performSegueWithIdentifier:@"toOrder" sender:self];
}

#pragma mark - Delegate
-(QAnnotationView *)mapView:(QMapView *)mapView
          viewForAnnotation:(id<QAnnotation>)annotation {
    static NSString *pointReuseIndentifier = @"pointReuseIdentifier";
    static NSString *customReuseIndentifier = @"custReuseIdentifieer";
    
    if ([annotation isKindOfClass:[QPointAnnotation class]]) {
        //添加默认pinAnnotation
        /*
        if ([annotation isEqual:[_annotations objectAtIndex:0]]) {
            
            QPinAnnotationView *annotationView = (QPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
            if (annotationView == nil) {
                annotationView = [[QPinAnnotationView alloc]
                                  initWithAnnotation:annotation
                                  reuseIdentifier:pointReuseIndentifier];
            }
            annotationView.canShowCallout = YES;
            annotationView.pinColor = QPinAnnotationColorRed;
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            annotationView.leftCalloutAccessoryView = btn;
            annotationView.draggable = YES;
           return annotationView;
        }
        //修改pinAnnotation图标
        if ([annotation isEqual:[_annotations objectAtIndex:1]]) {
            QAnnotationView *annotationView = (QAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
            if (annotationView == nil) {
                annotationView = [[QAnnotationView alloc]
                                  initWithAnnotation:annotation
                                  reuseIdentifier:pointReuseIndentifier];
                NSString *path = [[NSBundle mainBundle]
                                  pathForResource:@"tencent"
                                  ofType:@"png"];
                annotationView.canShowCallout = YES;
                //设置自定义的图片作为annotation图标
                annotationView.image = [UIImage imageWithContentsOfFile:path];
                //设置图标的锚点为下边缘中心
                annotationView.centerOffset = CGPointMake(0, -annotationView.image.size.height / 2);
                return annotationView;
            }
        }
        */
        //添加自定义annotation
      //  if ([annotation isEqual:[_annotations objectAtIndex:2]]) {
            CustomAnnotationView *annotationView = (CustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndentifier];
            if (annotationView == nil) {
                annotationView = [[CustomAnnotationView alloc]
                                  initWithAnnotation:annotation
                                  reuseIdentifier:customReuseIndentifier];
                NSString *path = [[NSBundle mainBundle]
                                  pathForResource:@"redflag"
                                  ofType:@"png"];
                UIImage *image = [UIImage imageWithContentsOfFile:path];
                annotationView.image = image;
                annotationView.centerOffset = CGPointMake(image.size.width / 2, - image.size.height / 2);
                NSString *path1 = [[NSBundle mainBundle]
                                   pathForResource:@"hotel"
                                   ofType:@"png"];
                UIImage *image1 = [UIImage imageWithContentsOfFile:path1];
                [annotationView setCalloutImage:image1];
                [annotationView setCalloutBtnTitle:@"预定"
                                          forState:UIControlStateNormal];
                [annotationView addCalloutBtnTarget:self
                                             action:@selector(calloutButtonAction)
                                   forControlEvents:UIControlEventTouchUpInside];
                return annotationView;
            }
        //}
    }
    return nil;
}

@end
