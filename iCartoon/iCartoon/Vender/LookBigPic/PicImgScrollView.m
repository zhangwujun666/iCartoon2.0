//
//  MyScrollView.m
//  LookBigPic
//
//  Created by apple on 15/10/13.
//  Copyright © 2015年 xincheng. All rights reserved.
//

#import "PicImgScrollView.h"
#import "UIImageView+WebCache.h"
#import "UIImage+JSH.h"
#import "PercentView.h"
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height



@interface PicImgScrollView ()<UIGestureRecognizerDelegate>
{
    NSString *_bigImgStr;
    
//    BOOL isAllowReset; //是否允许设置 zoomScale;
    
    BOOL isAnimate; //是否在做动画.
    
    UIImageView *_smallView;
}


/** imageView的单击 */
@property (nonatomic,strong) UITapGestureRecognizer *tap_single_imageViewGesture;
/** imageView的双击 */
@property (nonatomic,strong) UITapGestureRecognizer *tap_double_imageViewGesture;
/** 加载进度 */
@property(nonatomic,retain)UILabel *loadProgressView;
/** loading view */
@property(nonatomic,retain)UIView *loadingView;

@property(nonatomic,assign)BOOL isDoubleClickZoom;


@end


@implementation PicImgScrollView

-(void)resetZoom
{
    self.zoomScale = 1.0;
}

-(id)initWithFrame:(CGRect)frame
{
   self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.maximumZoomScale = 2.0;
        self.minimumZoomScale = 0.1;
        isAnimate = NO;
    }
    return self;
}


-(void)initWithBigImgUrl:(NSString *)bigImgStr smallImageUrl:(NSString *)smallImgStr
{
    _bigImgStr = bigImgStr;
    _bigImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0,200,self.frame.size.width,300)];
    _bigImgView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    [self addSubview:_bigImgView];


    [self addSmallView:smallImgStr andBigImgStr:bigImgStr];
    [self startLoading];
    
  __weak  typeof(self)weakSelf = self;
    
    
    //读取进度问题
 //   NSInteger totalSize = [self getTotalImageFileSizeFromImgStr:bigImgStr];
    [_bigImgView sd_setImageWithURL:[NSURL URLWithString:bigImgStr] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    }  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
        ;
        [weakSelf endLoading];
        if (!image) {
            isAnimate = NO;
            return ;
        }
        CGFloat scale = image.size.width/image.size.height;
//        UIImage *imageScale = [UIImage imageWithImageSimple:image scaledToSize:CGSizeMake(WIDTH,WIDTH/scale)];
        _bigImgView.image = image;
        _bigImgView.bounds = CGRectMake(0,0, WIDTH, WIDTH/scale);
        [self setContentSize:CGSizeMake(_bigImgView.frame.size.width, _bigImgView.frame.size.height)];
        
        //判断图片是不是超出屏幕
//        NSLog(@"HEIGHT =========== %f",HEIGHT);
        if (_bigImgView.bounds.size.height>HEIGHT) {
            _bigImgView.center = CGPointMake(self.contentSize.width/2,self.contentSize.height/2);
//            _bigImgView.center = CGPointMake(WIDTH/2, HEIGHT/2);
        }else
        {
            _bigImgView.center = CGPointMake(WIDTH/2, HEIGHT/2);
        }
        
        //大图加载完图片之后 执行小图变大图操作（如果小图存在的情况下）
        
        [self smallToDoScaleAnimation:image];
    
    }];
    //图片loading完成之后才加双击手势。
    [self addGestureRecognizer:self.tap_double_imageViewGesture];
    [self addGestureRecognizer:self.tap_single_imageViewGesture];

    //这行很关键，意思是只有当没有检测到doubleTapGestureRecognizer 或者 检测doubleTapGestureRecognizer失败，singleTapGestureRecognizer才有效
    
    [self.tap_single_imageViewGesture requireGestureRecognizerToFail:self.tap_double_imageViewGesture];
    
}


/*
//此处同步方法有问题。 待优化（以后解决）
-(NSInteger)getTotalImageFileSizeFromImgStr:(NSString*)imgStr
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:imgStr]];
    request.HTTPMethod = @"HEAD";
    NSURLResponse *response = nil;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    return  response.expectedContentLength;
    
}

*/
/** 小图执行变大图的动画 */
-(void)smallToDoScaleAnimation:(UIImage *)bigImg
{
    if (_smallView) {
        
        //将小图的图转换成大图高清的Img
        _smallView.image = bigImg;
        
        //做动画之前先将大图隐藏掉  （保证动画的衔接性）
        
        self.bigImgView.hidden = YES;
        [UIView animateWithDuration:0.3 animations:^{
            
            _smallView.frame = self.bigImgView.frame;

        } completion:^(BOOL finished) {
            self.bigImgView.hidden = NO;
            isAnimate = NO;
            [_smallView removeFromSuperview];
        }];
        
    }else
    {
        isAnimate = NO;
    }
}



/** 如果小图存在添加小图 */
-(void)addSmallView:(NSString *)smallImgStr andBigImgStr:(NSString *)bigImgStr
{
    /*如果小图加载到内存中了就创建小图  站位 */ //TODO 做动画用
    BOOL isSmallImgExit = [[SDWebImageManager sharedManager] cachedImageExistsForURL:[NSURL URLWithString:smallImgStr]];
    
    /** 只有 小图存在内存中 且 大图不存在内存中  的时候才能执行小图变大图的操作 */
    /** 小图和大图不能共存 */
    
    BOOL isBigImgExit = [[SDWebImageManager sharedManager] cachedImageExistsForURL:[NSURL URLWithString:bigImgStr]];
    
    if (isSmallImgExit&&!isBigImgExit) {
        
        _smallView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        [self addSubview:_smallView];
        
        [_smallView sd_setImageWithURL:[NSURL URLWithString:smallImgStr] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (!image) {
                return ;
            }
            float scale = image.size.width/image.size.height;
            _smallView.bounds = CGRectMake(0, 0,WIDTH/2 ,(WIDTH/2)/scale);
            _smallView.center = CGPointMake(WIDTH/2, HEIGHT/2);
            
        }];
    }
}




#pragma mark ---------------- 单击手势 --------------------------
-(UITapGestureRecognizer *)tap_single_imageViewGesture{
    
    if(_tap_single_imageViewGesture == nil){
        
        _tap_single_imageViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap_single_imageViewTap:)];
        _tap_single_imageViewGesture.numberOfTapsRequired = 1;
    }
    
    return _tap_single_imageViewGesture;
}

-(void)tap_single_imageViewTap:(UITapGestureRecognizer *)tap{
    
    self.singleTapClick(self.bigImgView);

}


#pragma mark -------------------- 双击手势 ---------------------
-(UITapGestureRecognizer *)tap_double_imageViewGesture{
    
    if(_tap_double_imageViewGesture == nil){
        
        _tap_double_imageViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap_double_imageViewTap:)];
        _tap_double_imageViewGesture.numberOfTapsRequired = 2;
        
    }
    
    return _tap_double_imageViewGesture;
}


-(void)tap_double_imageViewTap:(UITapGestureRecognizer *)tap{
    
    //如果是在  animating   不响应双击手势
    if (isAnimate ) {
        return;
    }
    
    //标记
    self.isDoubleClickZoom = YES;
    
    CGFloat zoomScale = self.zoomScale;
    
    if(zoomScale<=1.0f){
        CGPoint loc = [tap locationInView:tap.view];
        
        CGFloat wh =1;
        
        CGRect rect = [self frameWithW:wh h:wh center:loc];
        [self zoomToRect:rect animated:YES];
    }else{
        [self setZoomScale:1.0f animated:YES];
    }
}


-(CGRect)frameWithW:(CGFloat)w h:(CGFloat)h center:(CGPoint)center{
    
    CGFloat x = center.x - w *.5f;
    CGFloat y = center.y - h * .5f;
    CGRect frame = (CGRect){CGPointMake(x, y),CGSizeMake(w, h)};
    
    return frame;
}


/*
 *  代理方法区
 */
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    return self.bigImgView;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    
    
    CGFloat xcenter = scrollView.frame.size.width/2 , ycenter = scrollView.frame.size.height/2;
    
    xcenter = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width/2 : xcenter;
    
    ycenter = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height/2 : ycenter;
    
    [self.bigImgView setCenter:CGPointMake(xcenter, ycenter)];
    
}

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{

    if(scrollView.zoomScale <=1)
       [scrollView setZoomScale:1 animated:YES];

}



-(void)startLoading
{
    
    isAnimate = YES;
    
    _loadingView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
//    _loadingView.backgroundColor = [UIColor redColor];
    _loadingView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    [self addSubview:_loadingView];
    
//    UIImageView *loadingImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
//    loadingImgView.image = [UIImage imageNamed:@"loading.png"];
//    [_loadingView addSubview:loadingImgView];

    PercentView *loadingImgView = [[PercentView alloc]initInView:_loadingView];
    [_loadingView addSubview:loadingImgView];
    
//    _loadProgressView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
//    _loadProgressView.text = @"";
//    _loadProgressView.font = [UIFont systemFontOfSize:13];
//    _loadProgressView.textColor = [UIColor whiteColor];
//    _loadProgressView.textAlignment = NSTextAlignmentCenter;
//    [_loadingView addSubview:_loadProgressView];
    
//    NSLog(@"%@",NSHomeDirectory());
}

-(void)endLoading
{
    [_loadingView removeFromSuperview];
    _loadingView = nil;
    _loadProgressView = nil;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
