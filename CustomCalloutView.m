//
//  CustomCalloutView.m
//  Tencent_Map_Demo_Raster
//
//  Created by WangXiaokun on 16/1/14.
//  Copyright © 2016年 WangXiaokun. All rights reserved.
//

#import "CustomCalloutView.h"

#define kArrowHeight 10

#define kPortraitMargin 5
#define kPortraitWidth 50
#define kPortraitHeight 70

#define kTitleWidth 120
#define kTitleHeight 20

#define kBtnWidth 50
#define kBtnHeight 30

@interface CustomCalloutView()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UILabel *labelTitle;
@property (nonatomic, strong) UILabel *labelSubtitle;
@property (nonatomic, strong) UIStackView *stackView;

@end

@implementation CustomCalloutView

#pragma mark - setData

-(void)setTitle:(NSString *)title {
    _labelTitle.text = title;
}

-(void)setSubtitle:(NSString *)subtitle {
    _labelSubtitle.text = subtitle;
}

-(void)setImage:(UIImage *)image {
    _imageView.image = image;
}

-(void)setBtnTitle:(NSString *)text forState:(UIControlState)state {
    if (text == nil) {
        return;
    }
    text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (text.length == 0) {
        return;
    }
    [_btn setTitle:text forState:state];
}

-(void)btnAddTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    if (_btn != nil) {
        [_btn addTarget:target action:action forControlEvents:controlEvents];
    }
}

#pragma mark - initFrame

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    _imageView = [[UIImageView alloc]
                  initWithFrame:CGRectMake(kPortraitMargin,
                                           kPortraitMargin,
                                           kPortraitWidth,
                                           kPortraitHeight)];
    [self addSubview:_imageView];
    //stackview用于放置title、subtitle及button
    _stackView = [[UIStackView alloc]
                  initWithFrame:CGRectMake(kPortraitMargin *2 + kPortraitWidth,
                                           kPortraitMargin,
                                           kTitleWidth + kPortraitMargin * 2,
                                           kPortraitHeight + kPortraitMargin)];
    _stackView.axis = UILayoutConstraintAxisVertical;
    _stackView.alignment = UIStackViewAlignmentLeading;
    [self addSubview:_stackView];
    //添加title
    _labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                            0,
                                                            kTitleWidth,
                                                            kTitleHeight)];
    [_stackView addArrangedSubview:_labelTitle];
    //添加subtitle
    _labelSubtitle = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                               0,
                                                               kTitleWidth,
                                                               kTitleHeight)];
    [_stackView addArrangedSubview:_labelSubtitle];
    //添加button
    _btn = [UIButton buttonWithType:UIButtonTypeSystem];
    _btn.frame = CGRectMake(0, 0, kBtnWidth, kBtnHeight);
    [_stackView addArrangedSubview:_btn];
}

#pragma mark - draw view path
- (void)drawRect:(CGRect)rect {
    [self drawInContext:UIGraphicsGetCurrentContext()];
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 1.0;
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
}

- (void)drawInContext:(CGContextRef) context {
    CGContextSetLineWidth(context, 2.0);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    [self getDarwPath:context];
    CGContextFillPath(context);
}

- (void)getDarwPath:(CGContextRef) context {
    CGRect rect = self.bounds;
    CGFloat radius = 6.0;
    CGFloat minx = CGRectGetMinX(rect),
    midx = CGRectGetMidX(rect),
    maxx = CGRectGetMaxX(rect);
    CGFloat miny = CGRectGetMinY(rect),
    maxy = CGRectGetMaxY(rect) - kArrowHeight;
    //绘制三角形
    CGContextMoveToPoint(context, midx + kArrowHeight, maxy);
    CGContextAddLineToPoint(context, midx, maxy + kArrowHeight);
    CGContextAddLineToPoint(context, midx - kArrowHeight, maxy);
    //绘制圆角矩形
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, miny, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxy, radius);
    CGContextAddArcToPoint(context, maxx, maxy, minx, maxy, radius);
    
    CGContextClosePath(context);
}

@end
