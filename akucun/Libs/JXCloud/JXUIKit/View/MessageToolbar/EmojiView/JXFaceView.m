//
// JXFaceView.m
//

#import "JXFaceView.h"

#import "JXEmotion.h"
#import "JXSDKHelper.h"

#define kButtomNum 5

@interface JXFaceView () {
    JXFacialView *_facialView;
    UIScrollView *_bottomScrollView;
    NSInteger _currentSelectIndex;
    NSArray *_emotionPackages;
}

@end

@implementation JXFaceView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = JXColorWithRGB(250, 250, 250);
        _facialView = [[JXFacialView alloc] initWithFrame:CGRectMake(0, 5, frame.size.width, 160)];
        //        [_facialView loadFacialView:1 size:CGSizeMake(30, 30)];
        _facialView.delegate = self;
        [self addSubview:_facialView];
        [self _setupButtom];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview) {
        [self reloadEmotionData];
    }
}

#pragma mark - private

- (void)_setupButtom {
    _currentSelectIndex = 1000;

    _bottomScrollView = [[UIScrollView alloc]
            initWithFrame:CGRectMake(0, CGRectGetMaxY(_facialView.frame),
                                     4 * CGRectGetWidth(_facialView.frame) / 5,
                                     self.frame.size.height - CGRectGetHeight(_facialView.frame))];
    _bottomScrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_bottomScrollView];
    [self _setupButtonScrollView];

    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.frame = CGRectMake((kButtomNum - 1) * CGRectGetWidth(_facialView.frame) / kButtomNum,
                                  CGRectGetMaxY(_facialView.frame),
                                  CGRectGetWidth(_facialView.frame) / kButtomNum,
                                  CGRectGetHeight(_bottomScrollView.frame));
    [sendButton setBackgroundColor:[UIColor colorWithRed:30 / 255.0
                                                   green:167 / 255.0
                                                    blue:252 / 255.0
                                                   alpha:1.0]];
    [sendButton setTitle:JXUIString(@"send") forState:UIControlStateNormal];
    [sendButton addTarget:self
                      action:@selector(sendFace)
            forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sendButton];
}

- (void)_setupButtonScrollView {
    [_bottomScrollView removeAllSubviews];
    NSInteger number = [_emotionPackages count];
    if (number <= 0) {
        return;
    }
    for (int i = 0; i < number; i++) {
        UIButton *defaultButton = [UIButton buttonWithType:UIButtonTypeCustom];
        defaultButton.frame =
                CGRectMake(i * CGRectGetWidth(_bottomScrollView.frame) / (kButtomNum - 1), 0,
                           CGRectGetWidth(_bottomScrollView.frame) / (kButtomNum - 1),
                           CGRectGetHeight(_bottomScrollView.frame));
        JXEmotionPackage *package = [_emotionPackages objectAtIndex:i];
        if (package.type == JXEmotionTypeEmoji) {
            [defaultButton setTitle:[package.emotions objectAtIndex:0].emoji
                           forState:UIControlStateNormal];
        } else {
            if ([package.emotions count] > 0) {
                UIImage *image = JXChatImage([package.emotions objectAtIndex:0].png);
                [defaultButton
                        setImage:image
                        forState:UIControlStateNormal];
                [defaultButton setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
                defaultButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
            }
        }
        [defaultButton setBackgroundColor:[UIColor clearColor]];
        defaultButton.layer.borderWidth = 0.5;
        defaultButton.layer.borderColor = [UIColor whiteColor].CGColor;
        [defaultButton addTarget:self
                          action:@selector(didSelect:)
                forControlEvents:UIControlEventTouchUpInside];
        defaultButton.tag = 1000 + i;
        [_bottomScrollView addSubview:defaultButton];
    }
    [_bottomScrollView setContentSize:CGSizeMake(number * CGRectGetWidth(_bottomScrollView.frame) /
                                                         (kButtomNum - 1),
                                                 CGRectGetHeight(_bottomScrollView.frame))];
}

- (void)_clearupButtomScrollView {
    for (UIView *view in [_bottomScrollView subviews]) {
        [view removeFromSuperview];
    }
}

#pragma mark - action

- (void)didSelect:(id)sender {
    UIButton *btn = (UIButton *)sender;
    NSInteger index = btn.tag - 1000;
    if (index < [_emotionPackages count]) {
        [_facialView loadFacialView:[_emotionPackages objectAtIndex:index] size:CGSizeMake(30, 30)];
    }
}

- (void)reloadEmotionData {
    NSInteger index = _currentSelectIndex - 1000;
    if (index < [_emotionPackages count]) {
        [_facialView loadFacialView:[_emotionPackages objectAtIndex:index] size:CGSizeMake(30, 30)];
    }
}

#pragma mark - FacialViewDelegate

- (void)selectedFacialView:(NSString *)str {
    if (_delegate) {
        [_delegate selectedFacialView:str isDelete:NO];
    }
}

- (void)deleteSelected:(NSString *)str {
    if (_delegate) {
        [_delegate selectedFacialView:str isDelete:YES];
    }
}

- (void)sendFace {
    if (_delegate) {
        [_delegate sendFace];
    }
}

- (void)sendFace:(NSString *)str {
    if (_delegate) {
        [_delegate sendFaceWithEmotion:str];
    }
}

#pragma mark - public

- (BOOL)stringIsFace:(NSString *)string {
    if ([_facialView.faces containsObject:string]) {
        return YES;
    }

    return NO;
}

- (void)setEmotionPackages:(NSArray *)emotionPackages {
    _emotionPackages = emotionPackages.copy;
    [self _setupButtonScrollView];
}

@end