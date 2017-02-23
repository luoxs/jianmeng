//
//  CustomAnnotationView.h
//  Tencent_Map_Demo_Raster
//
//  Created by WangXiaokun on 16/1/14.
//  Copyright © 2016年 WangXiaokun. All rights reserved.
//

#import <QMapKit/QMapKit.h>

@interface CustomAnnotationView : QAnnotationView

-(void)setCalloutImage:(UIImage *)image;

-(void)setCalloutBtnTitle:(NSString *)title
                 forState:(UIControlState)state;

-(void)addCalloutBtnTarget:(id)target
                       action:(SEL)action
             forControlEvents:(UIControlEvents)events;

@end