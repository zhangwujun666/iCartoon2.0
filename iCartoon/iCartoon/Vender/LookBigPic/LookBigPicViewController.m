//
//  PicViewController.m
//  LookBigPic
//
//  Created by apple on 15/10/13.
//  Copyright © 2015年 xincheng. All rights reserved.
//

#import "LookBigPicViewController.h"
#import "PicImgScrollView.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

#define DurationTime 0.3

typedef NS_ENUM(NSInteger,PushType) {
    PushTypeFromVC,
    PushTypeFromView
};


@interface LookBigPicViewController ()<UIScrollViewDelegate>
{
    UIImageView *snapShotView;
    UIView *zhezhaoView;
}


@property(nonatomic,retain)UIScrollView *bigScr;
@property(nonatomic,retain)NSArray *smallImgArr;
@property(nonatomic,retain)NSArray *bigImgArr;


@property (nonatomic,retain)UILabel *pageLabel;
@property (nonatomic,retain)NSArray *titleArr;
@property (nonatomic,retain)NSArray *userNameArr;
@property (nonatomic,retain)NSArray *contentArr;


/**保证当前图片放大（忘记缩小）划出屏幕回到原状*/
@property(nonatomic,assign)CGPoint currentContentOffSet;

/**当前选中的index*/
@property(nonatomic,assign)NSInteger index;

/**上界面传进来的view(UIImageView|UIButton)数组*/
@property(nonatomic,retain)NSArray *smallImgViewArr;

/**push 类型 */
@property(nonatomic,assign)PushType pushType;

@end

@implementation LookBigPicViewController


-(void)bigPicDescribe:(NSArray *)titleArr
{
    self.titleArr = titleArr;
    self.pageLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH-65, 40, 50, 50)];
    self.pageLabel.center = CGPointMake(WIDTH/2, HEIGHT-20);
    self.pageLabel.font = [UIFont systemFontOfSize:12];
    self.pageLabel.text = [NSString stringWithFormat:@"%ld/%lu",(long)_index+1,(unsigned long)_bigImgArr.count];
    self.pageLabel.textColor = [UIColor whiteColor];
    self.pageLabel.textAlignment = NSTextAlignmentCenter;
    
    UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ym.png"]];
    img.center = CGPointMake(self.pageLabel.center.x, self.pageLabel.center.y);
    [self.view addSubview:img];
    [self.view addSubview:self.pageLabel];
    
    
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        
        _bigScr = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH+20, HEIGHT)];
        _bigScr.delegate = self;
        _bigScr.backgroundColor = [UIColor blackColor];

        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    _bigScr.contentSize = CGSizeMake((WIDTH+20)*_bigImgArr.count, HEIGHT);
    _bigScr.pagingEnabled = YES;
    _bigScr.contentOffset = CGPointMake(_index * (WIDTH +20) ,0);
    _currentContentOffSet = CGPointMake(_bigScr.contentOffset.x, _bigScr.contentOffset.y);
   __weak typeof(self)weakSelf = self;
    for (int i = 0; i<_bigImgArr.count;i++) {
        PicImgScrollView *scr = [[PicImgScrollView alloc]initWithFrame:CGRectMake(i*(WIDTH+20),0,WIDTH,HEIGHT)];
        scr.contentSize = CGSizeMake(WIDTH, HEIGHT);
//        scr.topVcImgStr = _bigImgArr[_index];
        [scr initWithBigImgUrl:_bigImgArr[i] smallImageUrl:_smallImgArr[i]];
        scr.singleTapClick = ^(UIImageView *imageView){
            
            [weakSelf popChildViewControllerWithImage:imageView];

        };
       
        [_bigScr addSubview:scr];
    }
    if (self.contentArr) {
        for (int i = 0 ; i < [self.titleArr count]; i++) {
            
            UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(i*(WIDTH+20), 0, WIDTH, 100)];
            topView.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.6];
            [_bigScr addSubview:topView];
            UILabel * worksLabel = [[UILabel alloc]initWithFrame:CGRectMake(i *(WIDTH+20)+10, 40, WIDTH-20,20)];
            NSMutableString * str = [[NSMutableString alloc]initWithFormat:@"%@%@",@"作品：",self.titleArr[i]];
            worksLabel.text = str;
            worksLabel.textAlignment = NSTextAlignmentLeft;
            worksLabel.textColor = [UIColor whiteColor];
            worksLabel.font = [UIFont systemFontOfSize:16];
            [_bigScr addSubview:worksLabel];
            
            UILabel * autherLabel = [[UILabel alloc]initWithFrame:CGRectMake(i *(WIDTH+20)+10, 60, WIDTH-20,20)];
            NSMutableString * autherLabelstr = nil;
            NSString * namestr = self.userNameArr[i];

            if (![namestr isEqualToString:@"null"]) {
                autherLabelstr = [[NSMutableString alloc]initWithFormat:@"%@%@",@"作者：",self.userNameArr[i]];
            }else{
                autherLabelstr = [[NSMutableString alloc]initWithFormat:@"%@%@",@"作者：",@"匿名"];
            }
           
            autherLabel.text = autherLabelstr;
            autherLabel.textAlignment = NSTextAlignmentLeft;
            autherLabel.textColor = [UIColor whiteColor];
            autherLabel.font = [UIFont systemFontOfSize:16];
            [_bigScr addSubview:autherLabel];
            
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(i *(WIDTH+20), HEIGHT-140, WIDTH,130)];
            view.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.6];
            [_bigScr addSubview:view];
            UILabel * contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(i *(WIDTH+20)+10, HEIGHT -140, WIDTH-20,20)];
            contentLabel.text = @"设计说明：";
            contentLabel.textAlignment = NSTextAlignmentLeft;
            contentLabel.textColor = [UIColor whiteColor];
            contentLabel.font = [UIFont systemFontOfSize:16];
            [_bigScr addSubview:contentLabel];
            
            UIScrollView *scroller = [[UIScrollView alloc]initWithFrame:CGRectMake(i *(WIDTH+20)+10, HEIGHT -120, WIDTH-10,90)];
            scroller.showsHorizontalScrollIndicator = NO;
            scroller.showsVerticalScrollIndicator = NO;
            scroller.userInteractionEnabled = YES;
            scroller.scrollEnabled = YES;
            scroller.backgroundColor = [UIColor clearColor];
            scroller.bounces = NO;
            scroller.tag = -i -1;
             [_bigScr addSubview:scroller];
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH-15,80)];
            lable.text = self.contentArr[i];
            lable.numberOfLines = 0;
            lable.textAlignment = NSTextAlignmentLeft;
            lable.textColor = [UIColor whiteColor];
            lable.font = [UIFont systemFontOfSize:TRANS_VALUE(12.0f)];
             NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:TRANS_VALUE(12.0f)],NSFontAttributeName, nil];
            CGSize size = [lable.text boundingRectWithSize:CGSizeMake(lable.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
            lable.frame = CGRectMake(0, 0, size.width, size.height);
              scroller.contentSize = CGSizeMake(0, lable.frame.size.height);
            [scroller addSubview:lable];
        }
    }

    [self.view addSubview:_bigScr];
    
}
- (void)userNameDescribe:(NSArray *)userNameArr{

    self.userNameArr = userNameArr;
}
- (void)contentDescribe:(NSArray *)contentArr{
    self.contentArr = contentArr;
}

-(void)initWithAllImageUrlArray:(NSArray *)imageArray andTargets:(id)targert andIndex:(NSInteger)index
{
    [self initWithAllBigUrlArray:imageArray andSmallUrlArray:imageArray andTargets:targert andIndex:index];
}


-(void)initWithAllBigUrlArray:(NSArray *)bigUrlArray andSmallUrlArray:(NSArray*)smallUrlArr andTargets:(id)targert andIndex:(NSInteger)index
{
    _bigImgArr = bigUrlArray;
    _smallImgArr = smallUrlArr;
    _index = index;
    
    snapShotView = [[UIImageView alloc]init];
    snapShotView.contentMode = UIViewContentModeScaleAspectFill;
    snapShotView.clipsToBounds = YES;
    zhezhaoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    zhezhaoView.backgroundColor = [UIColor blackColor];
    zhezhaoView.alpha = 0.0;
    
}


#pragma mark ------------- scrollViewDelegate --------------
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger pages = scrollView.contentOffset.x / scrollView.frame.size.width;
    _index = pages;
    
     self.pageLabel.text = [NSString stringWithFormat:@"%ld/%lu",_index+1,(unsigned long)_bigImgArr.count];
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    if (scrollView.contentOffset.x==_currentContentOffSet.x ) {
        return;
    }
    _currentContentOffSet.x = scrollView.contentOffset.x;
    for (id scr in scrollView.subviews) {
        if ([[scr class] isSubclassOfClass:[UIScrollView class]]) {
            UIScrollView * scro = scr;
            if (scro.tag>=0) {
                 [scr resetZoom];
            }
           
        }
    }
}

#pragma mark -------------- 从上界面点击位置转场pop -------------------------

-(void)pushChildViewControllerWithArray:(NSArray *)viewArray
{
    self.pushType = PushTypeFromView;
    
    self.smallImgViewArr = viewArray;
    
    //转场之前 判断内存中是否有小图和大图  只要是其中一个不满足就从中心push
    BOOL isExitSmallImg = [[SDWebImageManager sharedManager] cachedImageExistsForURL:[NSURL URLWithString:_smallImgArr[_index]]];
    BOOL isExitBigImg = [[SDWebImageManager sharedManager] cachedImageExistsForURL:[NSURL URLWithString:_bigImgArr[_index]]];
    
    if (isExitSmallImg && isExitBigImg) {
        
        [self pushAnimation];

    }else
    {
        [self pushChildViewControllerFromCenter];
    }

}

-(void)pushAnimation
{
    UIView *touchView = self.smallImgViewArr[_index];
    CGRect rect = [touchView convertRect:touchView.bounds toView:[[UIApplication sharedApplication].delegate window]];
    self.view.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    [self.view setClipsToBounds:YES];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [delegate.window.rootViewController addChildViewController:self];
    
    snapShotView.frame = rect;
    [snapShotView sd_setImageWithURL:[NSURL URLWithString:_smallImgArr[_index]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
//    if (snapShotView.image == nil) {
//        [delegate.window addSubview:self.view];
//        
//        return;
//    }
    [delegate.window addSubview:zhezhaoView];
    [delegate.window addSubview:snapShotView];
    
    CGFloat scale = snapShotView.image.size.width/snapShotView.image.size.height;
    
    [UIView animateWithDuration:DurationTime delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        zhezhaoView.alpha = 1.0;
        snapShotView.bounds = CGRectMake(0, 0, WIDTH,WIDTH/scale);
        
        //如果是长图
        if (snapShotView.bounds.size.height>HEIGHT) {
            snapShotView.center = CGPointMake(WIDTH/2,snapShotView.bounds.size.height/2);
        }else
        {
            snapShotView.center = CGPointMake(WIDTH/2,HEIGHT/2);
        }
        
        
    } completion:^(BOOL finished) {
        [delegate.window addSubview:self.view];
        [snapShotView removeFromSuperview];
        [zhezhaoView removeFromSuperview];
        
    }];
        
          }];
    
    
    
}



#pragma mark -------------- 从上界面点击位置转场pop -------------------------

-(void)popChildViewControllerWithImage:(UIImageView *)imageView
{
    //如果push方式是viewControllerPush的话 单击 功能将失去。
    if (self.pushType != PushTypeFromView) {
     
        [self doNavAnimation];
        return;
    }
    
    
    //如果是从中心进场的 也只能从中心退出
    if (self.smallImgViewArr == nil) {
        [self popChildViewControllerFromCenter];
        return;
    }
    
    //判断大图是否被加载到了内存中
    BOOL isBigImgExit = [[SDWebImageManager sharedManager] cachedImageExistsForURL:[NSURL URLWithString:_bigImgArr[_index]]];
    BOOL isSmallImgExit = [[SDWebImageManager sharedManager] cachedImageExistsForURL:[NSURL URLWithString:_smallImgArr[_index]]];
    
    if (isBigImgExit&&isSmallImgExit) {
        [self popAnimation:imageView];
    }else
    {
        [self popChildViewControllerFromCenter];

    }
    
}

-(void)doNavAnimation
{

    
    /*如果用系统导航的话*/ //TODO
    /*
    if (self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }else
    {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }*/
    
    /** 否则用自己定义的导航 */ // TODO
    
    
    
}


-(void)popAnimation:(UIImageView *)imageView
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    snapShotView.image = imageView.image;
    
    UIView *view = (UIView *)[_smallImgViewArr objectAtIndex:_index];
    CGRect rect = [view convertRect:view.bounds toView:[[UIApplication sharedApplication].delegate window]];
    
    CGRect rect1 = [imageView convertRect:imageView.bounds toView:[delegate window]];
    snapShotView.frame = rect1;
    
    
    [delegate.window addSubview:zhezhaoView];
    [delegate.window addSubview:snapShotView];
    [self.view removeFromSuperview];
    
    
    [UIView animateWithDuration:DurationTime delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        zhezhaoView.alpha = 0.0;
        snapShotView.frame = rect;
        
    } completion:^(BOOL finished) {
        
        [snapShotView removeFromSuperview];
        [zhezhaoView removeFromSuperview];
        [self removeFromParentViewController];
    }];
}

#pragma mark -------------- 从中心转场push -------------------------

-(void)pushChildViewControllerFromCenter
{
    self.pushType = PushTypeFromView;
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.window addSubview:self.view];
    [delegate.window.rootViewController addChildViewController:self];
    self.view.alpha = 0.0;
    [UIView animateWithDuration:DurationTime animations:^{
        self.view.alpha = 1.0;
    }];
}
#pragma mark -------------- 从中心转场pop -------------------------


-(void)popChildViewControllerFromCenter
{
    
    [UIView animateWithDuration:DurationTime animations:^{
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
    
    
    
}



-(void)dealloc
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
