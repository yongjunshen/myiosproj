//
//  RelatedSMSAlert.m
//  akucun
//
//  Created by Jarry Z on 2018/4/5.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "RelatedSMSAlert.h"
#import "RequestRelatedGetCode.h"

@interface RelatedSMSAlert ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UITextField *codeField;
@property (nonatomic, strong) UIButton *sendButton;

@end

@implementation RelatedSMSAlert

- (void) show
{
    [super show];
    [SVProgressHUD setContainerView:nil];
}

- (instancetype) init
{
    self = [super init];
    if ( self ) {
        [self setupViews];
    }
    return self;
}

- (void) setupViews
{
    self.type = MMPopupTypeAlert;
    self.withKeyboard = YES;
    
//    self.mobile = mobile;
    
    MMAlertViewConfig *config = [MMAlertViewConfig globalConfig];
    self.layer.cornerRadius = config.cornerRadius;
    self.clipsToBounds = YES;
    self.backgroundColor = config.backgroundColor;
    self.layer.borderWidth = MM_SPLIT_WIDTH;
    self.layer.borderColor = config.splitColor.CGColor;
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(315);
    }];
    [self setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];
    
    MASViewAttribute *lastAttribute = self.mas_top;
    
    UIView *titleView = [UIView new];
    titleView.backgroundColor = RED_COLOR;
    [self addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastAttribute);
        make.left.right.equalTo(self);
    }];
    
    UILabel *iconLabel = [UILabel new];
    iconLabel.layer.backgroundColor = WHITE_COLOR.CGColor;
    iconLabel.textColor = RED_COLOR;
    iconLabel.font = FA_ICONFONTSIZE(25);
    iconLabel.text = FA_ICONFONT_ALERT;
    iconLabel.textAlignment = NSTextAlignmentCenter;
    iconLabel.layer.masksToBounds = YES;
    iconLabel.layer.cornerRadius = 20;
    [titleView addSubview:iconLabel];
    [iconLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleView).offset(10);
        make.centerX.equalTo(titleView);
        make.width.height.equalTo(@(40));
    }];
    
    [titleView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(iconLabel.mas_bottom).offset(10);
    }];
    lastAttribute = titleView.mas_bottom;
    
    [self addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastAttribute).offset(20);
        make.left.right.equalTo(self).insets(UIEdgeInsetsMake(0, 20, 0, 20));
        make.height.mas_equalTo(40);
    }];
    lastAttribute = self.textField.mas_bottom;
    
    [self addSubview:self.sendButton];
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastAttribute).offset(10);
        make.right.equalTo(self).offset(-20);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(100);
    }];
    
    [self addSubview:self.codeField];
    [self.codeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastAttribute).offset(10);
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self.sendButton.mas_left).offset(-10);
        make.height.mas_equalTo(40);
    }];
    lastAttribute = self.codeField.mas_bottom;
    
    UILabel *tipLabel = [UILabel new];
    tipLabel.font = BOLDSYSTEMFONT(13);
    tipLabel.textColor = RED_COLOR;
    tipLabel.text = @"* 验证码将发送至主账号绑定的手机号";
    [self addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastAttribute).offset(10);
        make.left.right.equalTo(self.textField);
    }];
    lastAttribute = tipLabel.mas_bottom;

    UIView *buttonView = [UIView new];
    [self addSubview:buttonView];
    [buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastAttribute).offset(config.innerMargin);
        make.left.right.equalTo(self);
    }];
    
    UIButton *cancelButton = [UIButton mm_buttonWithTarget:self action:@selector(cancelAction:)];
    [cancelButton setBackgroundImage:[UIImage mm_imageWithColor:self.backgroundColor] forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:[UIImage mm_imageWithColor:config.itemPressedColor] forState:UIControlStateHighlighted];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:config.itemNormalColor forState:UIControlStateNormal];
    cancelButton.layer.borderWidth = MM_SPLIT_WIDTH;
    cancelButton.layer.borderColor = config.splitColor.CGColor;
    cancelButton.titleLabel.font = [FontUtils buttonFont];
    [buttonView addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(buttonView);
        make.height.mas_equalTo(config.buttonHeight);
        make.left.equalTo(buttonView.mas_left).offset(-MM_SPLIT_WIDTH);
        make.right.equalTo(buttonView.mas_centerX);
    }];
    
    UIButton *okButton = [UIButton mm_buttonWithTarget:self action:@selector(okAction:)];
    [okButton setBackgroundImage:[UIImage mm_imageWithColor:self.backgroundColor] forState:UIControlStateNormal];
    [okButton setBackgroundImage:[UIImage mm_imageWithColor:config.itemPressedColor] forState:UIControlStateHighlighted];
    [okButton setTitle:@"确定" forState:UIControlStateNormal];
    [okButton setTitleColor:RED_COLOR forState:UIControlStateNormal];
    [okButton setTitleColor:COLOR_TEXT_LIGHT forState:UIControlStateDisabled];
    okButton.layer.borderWidth = MM_SPLIT_WIDTH;
    okButton.layer.borderColor = config.splitColor.CGColor;
    okButton.titleLabel.font = [FontUtils buttonFont];
    [buttonView addSubview:okButton];
    [okButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(buttonView);
        make.height.mas_equalTo(config.buttonHeight);
        make.left.equalTo(cancelButton.mas_right).offset(-MM_SPLIT_WIDTH);
        make.right.equalTo(buttonView.mas_right).offset(MM_SPLIT_WIDTH);
    }];
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(buttonView.mas_bottom);
    }];
}

- (void) okAction:(UIButton*)btn
{
    NSString *userNo = self.textField.text;
    if ([NSString isEmpty:userNo]) {
        [SVProgressHUD showInfoWithStatus:@"请输入主账号的代购编号"];
        return;
    }
    if ([userNo isEqualToString:[UserManager instance].userInfo.yonghubianhao]) {
        [SVProgressHUD showInfoWithStatus:@"不能关联自己的账号"];
        return;
    }
    NSString *code = self.codeField.text;
    if ([NSString isEmpty:code] || code.length < 4) {
        [SVProgressHUD showInfoWithStatus:@"请输入有效的验证码"];
        return;
    }
    
    [self hide];
    [SVProgressHUD dismiss];
    
    if (self.confirmBlock) {
        self.confirmBlock(userNo,code);
    }
}

- (void) cancelAction:(UIButton*)btn
{
    [self hide];
    [SVProgressHUD dismiss];
}

- (void) sendAction:(UIButton*)btn
{
    NSString *userNo = self.textField.text;
    if ([NSString isEmpty:userNo]) {
        [SVProgressHUD showInfoWithStatus:@"请输入主账号的代购编号"];
        return;
    }
    if ([userNo isEqualToString:[UserManager instance].userInfo.yonghubianhao]) {
        [SVProgressHUD showInfoWithStatus:@"不能关联自己的账号"];
        return;
    }
    
    [self requestSmsCode:userNo];
}

- (void) showKeyboard
{
    [self.textField becomeFirstResponder];
}

- (void) hideKeyboard
{
    [self.textField resignFirstResponder];
}

-(void) startTimer
{
    __block int timeout = 59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.sendButton setTitle:@"重新发送" forState:UIControlStateNormal];
                self.sendButton.enabled = YES;
                self.sendButton.backgroundColor = COLOR_MAIN;
            });
        }
        else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.sendButton setTitle:[NSString stringWithFormat:@"重新发送(%@s)",strTime] forState:UIControlStateNormal];
                self.sendButton.enabled = NO;
                self.sendButton.backgroundColor = RGBCOLOR(0xF0, 0xF0, 0xF0);
            });
            timeout--;
        }
    });
    
    dispatch_resume(_timer);
}

- (void) requestSmsCode:(NSString *)userNo
{
    RequestRelatedGetCode *request = [RequestRelatedGetCode new];
    request.userno = userNo;
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         [SVProgressHUD showSuccessWithStatus:@"验证码已发送"];
         [self.codeField becomeFirstResponder];
         [self startTimer];
     } onFailed:nil];
}


#pragma mark -

- (UITextField *) textField
{
    if (!_textField) {
        _textField = [UITextField new];
        _textField.backgroundColor = self.backgroundColor;
        _textField.layer.cornerRadius = 5;
        _textField.layer.borderWidth = MM_SPLIT_WIDTH;
        _textField.layer.borderColor = COLOR_TEXT_LIGHT.CGColor;
        _textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        _textField.leftViewMode = UITextFieldViewModeAlways;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.placeholder = @"请输入主账号的代购编号";
        _textField.font = [FontUtils normalFont];
        _textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _textField;
}

- (UITextField *) codeField
{
    if (!_codeField) {
        _codeField = [UITextField new];
        _codeField.backgroundColor = self.backgroundColor;
        _codeField.layer.cornerRadius = 5;
        _codeField.layer.borderWidth = MM_SPLIT_WIDTH;
        _codeField.layer.borderColor = COLOR_TEXT_LIGHT.CGColor;
        _codeField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        _codeField.leftViewMode = UITextFieldViewModeAlways;
        _codeField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _codeField.placeholder = @"请输入验证码";
        _codeField.font = [FontUtils normalFont];
        _codeField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _codeField;
}

- (UIButton *) sendButton
{
    if (!_sendButton) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendButton.backgroundColor = COLOR_MAIN;
        _sendButton.clipsToBounds = YES;
        _sendButton.layer.cornerRadius = 5;
        
        _sendButton.titleLabel.font = BOLDSYSTEMFONT(13);
        
        [_sendButton setNormalColor:WHITE_COLOR highlighted:LIGHTGRAY_COLOR selected:nil];
        [_sendButton setNormalTitleColor:nil disableColor:COLOR_TEXT_LIGHT];
        [_sendButton setNormalTitle:@"获取验证码"];
        
        [_sendButton addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}

@end
