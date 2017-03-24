//
//  BRSActionSheet.m
//  BRSACtionSheet
//
//  Created by Bill Bai on 2017/3/24.
//  Copyright © 2017年 Bill Bai. All rights reserved.
//

#import "BRSActionSheet.h"

@interface BRSActionSheet ()

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *buttonView;
@property (nonatomic, strong) UIButton *cancleButton;
@property (nonatomic, strong) NSArray *actionItems;
@property (nonatomic, strong) NSMutableArray *actionButtons;

@end


@implementation BRSActionSheet

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupActionItems];
        [self setupViews];
    }
    return self;
}

- (void)setupActionItems
{
    _actionItems = @[
                    @[@"使用AirPrint打印", @"通过AirPrint连接打印机"],
                    @[@"使用电脑打印机打印", @"通过登陆QQ电脑版连接打印机"]
                     ];
}

- (void)setupViews
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    self.frame = window.bounds;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.frame = self.bounds;
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0.0;
    backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(backgroundTapped)];
    [backgroundView addGestureRecognizer:gesture];
    
    [self addSubview:backgroundView];
    self.backgroundView = backgroundView;
    
    const CGFloat width = CGRectGetWidth(self.bounds);
    const CGFloat height = CGRectGetHeight(self.bounds);
    const CGFloat buttonHeight = 66.0;
    const CGFloat titleFontSize = 18.0;
    const CGFloat subtitleFontSize = 12.0;
    const CGFloat cancleButtonHeight = 50.0;
    const CGFloat sepratorHeigtht = 0.5;
    const CGFloat buttonCancleGapHeight = 10.0;
    
    const NSUInteger buttonCount = [self.actionItems count];
    const NSUInteger sepratorCount = buttonCount > 0 ? buttonCount - 1 : 0;
    
    const CGFloat buttonViewHeight = buttonHeight * buttonCount +
                                sepratorCount * sepratorHeigtht +
                                buttonCancleGapHeight +
                                cancleButtonHeight;
    const CGFloat gapY = buttonViewHeight - cancleButtonHeight - buttonCancleGapHeight;
    const CGFloat cancleButtonY = buttonViewHeight - cancleButtonHeight;
    
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0.0, height, width, buttonViewHeight)];
    buttonView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self addSubview:buttonView];
    self.buttonView = buttonView;
    
    self.actionButtons = [[NSMutableArray alloc] initWithCapacity:buttonCount];
    for (NSUInteger i = 0; i < buttonCount; ++i) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0.0, i * (buttonHeight + sepratorHeigtht), width, buttonHeight+sepratorHeigtht);
        button.backgroundColor = [UIColor whiteColor];
        button.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [buttonView addSubview:button];
        
        NSString *title = self.actionItems[i][0];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 16, width, titleFontSize+2)];
        titleLabel.font = [UIFont systemFontOfSize:titleFontSize];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = title;
        titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [button addSubview:titleLabel];
        
        NSString *subtitle = self.actionItems[i][1];
        UILabel *subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 36, width, titleFontSize+2)];
        subtitleLabel.font = [UIFont systemFontOfSize:subtitleFontSize];
        subtitleLabel.textColor = [UIColor colorWithWhite:153.0/255.0 alpha:1.0];
        subtitleLabel.textAlignment = NSTextAlignmentCenter;
        subtitleLabel.text = subtitle;
        subtitleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [button addSubview:subtitleLabel];

        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        if (i != buttonCount - 1) {
            UIView *seprator = [[UIView alloc] initWithFrame:CGRectMake(0.0, buttonHeight, width, sepratorHeigtht)];
            seprator.backgroundColor = [UIColor colorWithWhite:222.0/255.0 alpha:1.0];
            seprator.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            [button addSubview:seprator];
        }
        [button setBackgroundImage:[self imageWithColor:[UIColor colorWithWhite:0.8 alpha:0.3]]
                        forState:UIControlStateHighlighted];
        [self.actionButtons addObject:button];
    }
    
    UIView *gapView = [[UIView alloc] initWithFrame:CGRectMake(0.0, gapY, width, buttonCancleGapHeight)];
    gapView.backgroundColor = [UIColor whiteColor];
    gapView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    gapView.alpha = 0.7;
    [buttonView addSubview:gapView];
    
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    cancleButton.titleLabel.font = [UIFont systemFontOfSize:titleFontSize];
    cancleButton.backgroundColor = [UIColor whiteColor];
    cancleButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    cancleButton.frame = CGRectMake(0.0, cancleButtonY, width, cancleButtonHeight);
    [cancleButton addTarget:self action:@selector(cancleButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [cancleButton setBackgroundImage:[self imageWithColor:[UIColor colorWithWhite:0.8 alpha:0.3]]
                            forState:UIControlStateHighlighted];
    [buttonView addSubview:cancleButton];
    self.cancleButton = cancleButton;
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)show
{
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3f animations:^{
        weakSelf.backgroundView.alpha = 0.4;
        weakSelf.backgroundView.userInteractionEnabled = YES;
        CGRect frame = weakSelf.buttonView.frame;
        frame.origin.y -= CGRectGetHeight(weakSelf.buttonView.frame);
        weakSelf.buttonView.frame = frame;
    } completion:^(BOOL finished) {
    }];
}

#pragma button target
- (void)buttonTapped:(UIButton *)button
{
    [self hideWithButtonTapped:button.tag];
}

- (void)cancleButtonTapped:(UIButton *)cancleButton
{
    [self hideWithButtonTapped:-1];
}

- (void)hideWithButtonTapped:(NSInteger)buttonIndex
{
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.3f animations:^{
        weakSelf.backgroundView.alpha = 0.0;
        weakSelf.backgroundView.userInteractionEnabled = NO;
        CGRect frame = weakSelf.buttonView.frame;
        frame.origin.y = CGRectGetHeight(weakSelf.bounds);
        weakSelf.buttonView.frame = frame;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

- (void)backgroundTapped
{
    [self hideWithButtonTapped:-1];
}

@end
