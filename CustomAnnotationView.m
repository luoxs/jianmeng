//
//  CustomAnnotationView.m
//  Tencent_Map_Demo_Raster
//
//  Created by WangXiaokun on 16/1/14.
//  Copyright © 2016年 WangXiaokun. All rights reserved.
//

#import "CustomAnnotationView.h"
#import "CustomCalloutView.h"

#define kCalloutWidth 200
#define kCalloutHeight 90

@interface CustomAnnotationView()

@property (nonatomic, strong) UIImage *imageCallout;
@property (nonatomic, strong) NSString *btnTitle;
@property (nonatomic, strong) id btnTarget;
@property (nonatomic) UIControlState btnState;
@property (nonatomic) SEL btnAction;
@property (nonatomic) UIControlEvents btnControlEvents;
@property (nonatomic, strong) CustomCalloutView *customCalloutView;

@end

@implementation CustomAnnotationView

-(void)setCalloutImage:(UIImage *)image {
    _imageCallout = image;
}

-(void)setCalloutBtnTitle:(NSString *)title
                 forState:(UIControlState)state {
    _btnTitle = title;
}

-(void)addCalloutBtnTarget:(id)target
                       action:(SEL)action
             forControlEvents:(UIControlEvents)events {
    _btnTarget = target;
    _btnAction = action;
    _btnControlEvents = events;
}

-(void)setSelected:(BOOL)selected {
    [self setSelected:selected animated:NO];
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if (self.selected == selected) {
        return;
    }
    if (selected) {
        if (_customCalloutView == nil) {
            _customCalloutView = [[CustomCalloutView alloc]
                                  initWithFrame:CGRectMake(0,
                                                           0,
                                                           kCalloutWidth,
                                                           kCalloutHeight)];
            _customCalloutView.center =
                    CGPointMake(CGRectGetWidth(self.bounds) / 2,
                                -CGRectGetHeight(self.customCalloutView.bounds)/2);
            [_customCalloutView setTitle:self.annotation.title];
            [_customCalloutView setSubtitle:self.annotation.subtitle];
            [_customCalloutView setImage:_imageCallout];
            [_customCalloutView setBtnTitle:_btnTitle
                                   forState:_btnState];
            [_customCalloutView btnAddTarget:_btnTarget
                                      action:_btnAction
                            forControlEvents:_btnControlEvents];
        }
        [self addSubview:_customCalloutView];
    } else {
        [_customCalloutView removeFromSuperview];
    }
    
    [super setSelected:selected animated:animated];
}



-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL inside = [super pointInside:point withEvent:event];
    
    if (!inside)
    {
        /* Callout existed. */
        if (self.selected && self.customCalloutView.superview)
        {
            CGPoint pointInCallout = [self convertPoint:point toView:self.customCalloutView];
            
            inside = CGRectContainsPoint(self.customCalloutView.bounds, pointInCallout);
        }
    }
    
    return inside;
}


@end
