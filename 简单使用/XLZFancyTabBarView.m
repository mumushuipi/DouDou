//
//  XLZFancyTabBarView.m
//  10-导航控制器简单使用
//
//  Created by ap106872 on 16/2/23.
//  Copyright © 2016年 XiaoLinZi. All rights reserved.
//

#import "XLZFancyTabBarView.h"
#import "XLZCustomButton.h"
#import "UIView+XLZAnimation.h"

// 列数
#define kCols 3
// 两边距
#define kPadding 50

#define XLZKeyWindow [UIApplication sharedApplication].keyWindow
#define XLZScreenW   [UIScreen mainScreen].bounds.size.width
#define XLZScreenH   [UIScreen mainScreen].bounds.size.height


typedef NS_ENUM(NSInteger,objClassType ) {
    objNSStringtype,
    objDictionaryType,
    
};

@interface XLZFancyTabBarView ()

@property (nonatomic, strong) NSArray *choices;
@property (nonatomic, strong) NSString *mainButtonImage;

@property (nonatomic, strong) NSMutableArray <UIButton *>*buttonArray;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIButton *mainButton;

@end

@implementation XLZFancyTabBarView
{
    NSTimer *_timer;
    objClassType _ObjClassType;
}

-(NSMutableArray<UIButton *> *)buttonArray
{
    if (_buttonArray == nil) {
        _buttonArray = [NSMutableArray array];
    }
    return  _buttonArray;
}

-(UIView *)maskView
{
    if (_maskView == nil) {
        
        UIView *mask = [[UIView alloc] init];
        mask.frame = [UIScreen mainScreen].bounds;
        mask.backgroundColor = [UIColor blackColor];
        mask.alpha = 0.6;
        mask.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [mask addGestureRecognizer:tap];
        _maskView = mask;
        
        [self.superview insertSubview:mask belowSubview:self];

    }
    return _maskView;
}

-(UIButton *)mainButton
{
    if (_mainButton == nil && _mainButtonImage) {
        
        UIButton *mainButton = [[UIButton alloc] init];
        UIImage *image = [UIImage imageNamed:_mainButtonImage];
        mainButton.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        mainButton.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height - image.size.height / 2 - 10);
        [mainButton setImage:image forState:UIControlStateNormal];
        [mainButton addTarget:self action:@selector(mainButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _mainButton = mainButton;
        [self addSubview:mainButton];
        [self bringSubviewToFront:mainButton];
    }
    return _mainButton;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame] ) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setUpChoices:(NSArray*)choices
{
    [self setUpChoices:choices withMainButtonImage:nil];
}

- (void)setUpChoices:(NSArray*)choices withMainButtonImage:(NSString *)mainButtonImage
{
    _choices = choices;
    _mainButtonImage = mainButtonImage;
    
    [self setupSubViews];
}

-(void)show
{
    if (self.mainButton == nil) {
        
        self.transform = CGAffineTransformMakeTranslation(0, XLZKeyWindow.frame.size.height);
        [UIView animateWithDuration:0.25 animations:^{
            self.transform = CGAffineTransformIdentity;
            
        }];
        self.maskView.hidden = NO;
        [self startAnimation];
    }
}

-(void)hidden
{
    [UIView animateWithDuration:0.5 animations:^{
        if (self.mainButton == nil) {
            self.transform = CGAffineTransformMakeTranslation(0, XLZKeyWindow.frame.size.height);
        
            self.maskView.hidden = YES;
            _count = 0;
        }else{
            
            self.mainButton.transform = CGAffineTransformIdentity;
            self.mainButton.selected = NO;
            [self.buttonArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                obj.transform = CGAffineTransformIdentity;
                obj.alpha = 0;
            }];
        }
        
    } completion:^(BOOL finished) {
        
        if (self.mainButton  == nil) {
            [self.buttonArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                obj.transform = CGAffineTransformMakeTranslation(0, XLZKeyWindow.frame.size.height);
            }];
        }
        
    }];
   

}

-(void)setupSubViews
{

    [self.choices enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
     
        // 图片+文字类型
        if ([obj isKindOfClass:[NSDictionary class]]) {
            
            _ObjClassType  = objDictionaryType;
            [self setUpSubViewWithObj:obj index:idx className:@"XLZCustomButton"];
        // 图片类型
        }else if ([obj isKindOfClass:[NSString class]]){
            _ObjClassType = objNSStringtype;
            [self setUpSubViewWithObj:obj index:idx className:@"UIButton"];
        // 其他类型
        }else{
            return ;
        }
        
    }];
    
    
    
}

-(void)setUpSubViewWithObj:(id)obj index:(NSInteger)idx className:(NSString *)className
{
    NSString *imageString = nil;
    NSString *title = nil;
    if (_ObjClassType == objDictionaryType) {
        NSDictionary *dict = [NSDictionary dictionary];
        dict = (NSDictionary *)obj;
        imageString = dict.allKeys[0];
        title = dict.allValues[0];
    }else if (_ObjClassType == objNSStringtype){
#warning 待解决高亮状态
        imageString = obj;
    }
    UIImage *image = [UIImage imageNamed:imageString];
    
    int col = 0;
    int row = 0;
    CGFloat x = 0;
    CGFloat y = 0;
#warning 宽高
    CGFloat wh = 100;
    CGFloat margin = (self.frame.size.width - kCols * wh) / (kCols + 1);
    CGFloat oriY = self.bounds.origin.y + 10;
    
    col = (int)idx % kCols;
    row = (int)idx / kCols;
    
    x = margin + col * (margin + wh);
    y = row * (margin + wh) + oriY;
    
    Class class = NSClassFromString(className);
    UIButton *btn = [class buttonWithType:UIButtonTypeCustom];
    if (self.mainButton) {
        btn.frame = CGRectMake(0, 0, wh, wh);
        btn.center = self.mainButton.center;
        btn.alpha = 0;
    }else{
        btn.frame = CGRectMake(x, y, wh, wh);
        btn.transform = CGAffineTransformMakeTranslation(0, XLZKeyWindow.frame.size.height);
    }
    
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setAdjustsImageWhenHighlighted:NO];
    btn.tag = idx;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    [self.buttonArray addObject:btn];

}


-(void)tap:(UITapGestureRecognizer *)tap
{
    [self hidden];
}

-(void)startAnimation
{
    _timer  = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(seekTime) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}

static int _count = 0;
-(void)seekTime
{
    if (_count == self.choices.count && ((self.mainButton && self.mainButton.selected) || self.mainButton == nil)) {
        [_timer invalidate];
        _timer = nil;
        XLZLog(@"时间到");
        return;
    }else if(_count == -1 && (self.mainButton  && self.mainButton.selected == NO)){
        [_timer invalidate];
        _timer = nil;
        XLZLog(@"时间到");
        return;
    }
    UIButton *btn = self.buttonArray[_count];
    [self oneButtonAnimation:btn];
    ((self.mainButton.selected && self.mainButton) || self.mainButton == nil) ? _count ++ : _count--;
    
}

-(void)oneButtonAnimation:(UIButton *)btn
{
    [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        if (self.mainButton == nil) {
            btn.transform = CGAffineTransformIdentity;
        }else if(self.mainButton && self.mainButton.selected ){
            btn.alpha = 1;
            CGFloat degress = M_PI / (self.buttonArray.count - 1);
            CGFloat radio = (self.frame.size.width - 2 * kPadding) / 2;
            
            CGFloat buttonX =  cosf(degress * btn.tag)* radio;
            CGFloat buttonY =  -sinf(degress * btn.tag)* radio;
            // transform也是虚假值，并没有改变frame
            btn.transform = CGAffineTransformMakeTranslation(buttonX, buttonY);
    
        }else if (self.mainButton && !self.mainButton.selected){

            btn.transform = CGAffineTransformIdentity;
            btn.alpha = 0;
        }
        
    } completion:^(BOOL finished) {
     
        if ( self.mainButton == nil) {

            // 不知道为什么真机上就会出bug
            [btn setUpAniamtionLikeGameCenterBubble];
            
        }
    }];
}

-(void)btnClick:(UIButton *)btn
{
    if (_selectedButtonIndex) {
        _selectedButtonIndex(btn,btn.tag);
    }

    XLZLog(@"%zd",btn.tag);
    
    [self hidden];
    
}

-(void)mainButtonClick:(UIButton *)btn
{
    XLZLog(@"主按钮点击");
    btn.selected = !btn.selected;
    
    if (btn.selected) {
        
        [UIView animateWithDuration:0.25 animations:^{
            
            self.mainButton.transform = CGAffineTransformMakeRotation(M_PI_4);
            
        }];
        
        [self startAnimation];
        _count = 0;
        
    }else{
        [UIView animateWithDuration:0.25 animations:^{
            
            self.mainButton.transform = CGAffineTransformIdentity;
        }];
        _count = (int)self.buttonArray.count - 1;
        [self startAnimation];
        
    }
}



@end
