//
//  CustomImagePickerController.m
//  iCartoon
//
//  Created by 许成雄 on 16/4/23.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "CustomImagePickerController.h"
#import "PictureCollectionViewCell.h"
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import "CommonUtils.h"

#import <TSMessages/TSMessage.h>
#import "AttentionView.h"
#define kPictureMargin TRANS_VALUE(4.0f)

@interface CustomImagePickerController () <UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) UIBarButtonItem *selectButton;
@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) NSMutableArray *pictureArray;

@property (strong, nonatomic) NSMutableArray *selectedItemArray;
@property (strong, nonatomic) NSMutableArray *selectedImageArray;


@end

@implementation CustomImagePickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = I_COLOR_WHITE;
    self.title = @"图片选择";
    
    [self setBackNavgationItem];
    
    self.selectButton = [[UIBarButtonItem alloc] initWithTitle:@"选择" style:UIBarButtonItemStylePlain target:self action:@selector(selectAction)];
    self.navigationItem.rightBarButtonItem = self.selectButton;
    
    if(!self.maxNumOfPictures) {
        self.maxNumOfPictures = 9;
    }
    
    [self createUI];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(self.selectedPictureArray.count > 0 && self.selectedPictureArray.count <= 9) {
        NSString *titleStr = [NSString stringWithFormat:@"选择 (%ld)", (unsigned long)self.selectedPictureArray.count];
        self.selectButton = [[UIBarButtonItem alloc] initWithTitle:titleStr style:UIBarButtonItemStylePlain target:self action:@selector(selectAction)];
        self.navigationItem.rightBarButtonItem = self.selectButton;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



#pragma mark - Private Method
- (void)selectAction {
    if([self.delegate respondsToSelector:@selector(imagePickerController:selectedImages:soureType:)]) {
        [self.delegate imagePickerController:self selectedImages:self.selectedPictureArray soureType:CustomImagePickerControllerSourceTypePhotoLibrary];
        [self.navigationController popViewControllerAnimated:NO];
    }
}

#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = self.pictureArray != nil ? [self.pictureArray count] : 0;
    return count + 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (SCREEN_WIDTH - 4 * kPictureMargin) / 3;
    CGFloat height = width;
    return CGSizeMake(width, height);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PictureCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PictureCollectionViewCell" forIndexPath:indexPath];
    if(!cell) {
        CGFloat width = (SCREEN_WIDTH - 4 * kPictureMargin) / 3;
        CGFloat height = width;
        cell = [[PictureCollectionViewCell alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    }
    NSString *imageUrl = nil;
    if(indexPath.row > 0 && indexPath.row <= self.pictureArray.count) {
        imageUrl = (NSString *)[self.pictureArray objectAtIndex:(indexPath.row - 1)];
        if([self hasSelected:imageUrl]) {
            cell.hasSelected = YES;
        } else {
            cell.hasSelected = NO;
        }
        //TODO －－ 选中状态
        BOOL selected = cell.hasSelected;
        if(selected) {
            [self.selectedItemArray replaceObjectAtIndex:(indexPath.row - 1) withObject:[NSNumber numberWithBool:YES]];
        } else {
            [self.selectedItemArray replaceObjectAtIndex:(indexPath.row - 1) withObject:[NSNumber numberWithBool:NO]];
        }
    } else {
        imageUrl = nil;
    }
    cell.imageUrl = imageUrl;
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    UIEdgeInsets inset = UIEdgeInsetsMake(kPictureMargin, kPictureMargin, kPictureMargin, kPictureMargin);
    return inset;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return kPictureMargin;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    CGFloat space = kPictureMargin;
    return space;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row > 0) {
        PictureCollectionViewCell *cell = (PictureCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        BOOL selected = cell.hasSelected;
        if(!selected) {
            if([self getSelectPictures] <= self.maxNumOfPictures - 1) {
                cell.hasSelected =  !cell.hasSelected;
            } else {
                if (self.maxNumOfPictures == 1) {
                    NSString *titleStr = [NSString stringWithFormat:@"每次最多可投递一张作品"];
                    AttentionView * attention = [[AttentionView alloc]initTitle:titleStr andtitle2:@""];
                    attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
                    attention.label1.frame=CGRectMake(5, 15, 220, 40);
                    [self.view addSubview:attention];
                    return;
                }else{
                    NSString *titleStr = [NSString stringWithFormat:@"最多只能选择%ld张！", (long)self.maxNumOfPictures];
                    AttentionView * attention = [[AttentionView alloc]initTitle:titleStr andtitle2:@""];
                    attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
                    attention.label1.frame=CGRectMake(5, 15, 220, 40);
                    [self.view addSubview:attention];
                    return;
                }
            }
        } else {
            cell.hasSelected =  !cell.hasSelected;
        }
        selected = cell.hasSelected;
        if(selected) {
            [self.selectedItemArray replaceObjectAtIndex:(indexPath.row - 1) withObject:[NSNumber numberWithBool:YES]];
        } else {
            [self.selectedItemArray replaceObjectAtIndex:(indexPath.row - 1) withObject:[NSNumber numberWithBool:NO]];
        }
        NSInteger count = [self getSelectPictures];
        NSString *titleStr = [NSString stringWithFormat:@"选择 (%ld)", (long)count];
        self.selectButton = [[UIBarButtonItem alloc] initWithTitle:titleStr style:UIBarButtonItemStylePlain target:self action:@selector(selectAction)];
        self.navigationItem.rightBarButtonItem = self.selectButton;
    } else {
        //相机拍
        if([self getSelectPictures] >= self.maxNumOfPictures){
            NSString *titleStr = [NSString stringWithFormat:@"最多只能选择%ld张！", (long)self.maxNumOfPictures];
            AttentionView * attention = [[AttentionView alloc]initTitle:titleStr andtitle2:@""];
            attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
            attention.label1.frame=CGRectMake(5, 15, 220, 40);
            [self.view addSubview:attention];
            return;
        }
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"系统相机不可用!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
            return;
        }
        imagePickerController.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:imagePickerController.sourceType];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = NO;
        //TODO -- fixed bug 有问题需要解决
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
}

- (NSInteger)getSelectPictures {
    if(!self.selectedImageArray) {
        self.selectedImageArray = [NSMutableArray arrayWithCapacity:0];
    }
    [self.selectedImageArray removeAllObjects];
    for(int i = 0, n = (int)self.selectedItemArray.count; i < n; i++) {
        NSNumber *number = [self.selectedItemArray objectAtIndex:i];
        if([number boolValue]) {
            [self.selectedImageArray addObject:[self.pictureArray objectAtIndex:i]];
        }
    }
    
    for(NSString *imgUrl in self.selectedImageArray) {
        if(![self hasInSelectedPictures:imgUrl]) {
            [self.selectedPictureArray addObject:imgUrl];
        }
    }
    
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:0];
    for(id item in self.selectedPictureArray) {
        if([item isKindOfClass:[NSString class]]) {
            if(![self hasInSelectedImages:(NSString *)item]) {
                [tempArray addObject:(NSString *)item];
            }
        }
    }
    for(NSString *item in tempArray) {
        [self.selectedPictureArray removeObject:item];
    }
    //NSLog(@"你选中了%ld张照片", self.selectedPictureArray.count);
    return self.selectedPictureArray.count;
}

- (BOOL)hasSelected:(NSString *)urlStr {
    BOOL selected = NO;
    for(id item in self.selectedPictureArray) {
        if([item isKindOfClass:[NSString class]]) {
            if([((NSString *)item) isEqualToString:urlStr]) {
                selected = YES;
                break;
            }
        }
    }
    return selected;
}

- (BOOL)hasInSelectedPictures:(NSString *)urlStr {
    BOOL hasIn = NO;
    for(id item in self.selectedPictureArray) {
        if([item isKindOfClass:[NSString class]]) {
            if([((NSString *)item) isEqualToString:urlStr]) {
                hasIn = YES;
                break;
            }
        }
    }
    return hasIn;
}

- (BOOL)hasInSelectedImages:(NSString *)urlStr {
    BOOL hasIn = NO;
    for(NSString *item in self.selectedImageArray) {
        if([item isEqualToString:urlStr]) {
            hasIn = YES;
            break;
        }
    }
    return hasIn;
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    UIImage *fixedImage = nil;
    if(image) {
        fixedImage = [CommonUtils fixedOrientationImage:image];
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        if(fixedImage) {
            [self getSelectPictures];
            [self.selectedPictureArray addObject:fixedImage];
        }
        if([self.delegate respondsToSelector:@selector(imagePickerController:selectedImages:soureType:)]) {
            [self.delegate imagePickerController:self selectedImages:self.selectedPictureArray soureType:CustomImagePickerControllerSourceTypeCamera];
        }
        [self.navigationController popViewControllerAnimated:NO];
    }];
}

#pragma mark - Private Method
- (void)loadData {
    if(!self.pictureArray) {
        self.pictureArray = [NSMutableArray arrayWithCapacity:0];
    }
    [self.pictureArray removeAllObjects];
    if(!self.selectedItemArray) {
        self.selectedItemArray = [NSMutableArray arrayWithCapacity:0];
    }
    [self.selectedItemArray removeAllObjects];
    //TODO -- 加载图片
    [self reloadImagesFromLibrary];
//    [self.collectionView reloadData];
}

- (void)createUI {
    CGFloat collectionHeight = SCREEN_HEIGHT - 64.0f;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, collectionHeight) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.collectionView];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[PictureCollectionViewCell class] forCellWithReuseIdentifier:@"PictureCollectionViewCell"];
    self.collectionView.showsVerticalScrollIndicator = NO;
    
}

//获取相册的所有图片
- (void)reloadImagesFromLibrary {
    self.pictureArray = [[NSMutableArray alloc] init];
    dispatch_async(dispatch_get_main_queue(), ^{
        @autoreleasepool {
            ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *myerror){
            //NSLog(@"相册访问失败 =%@", [myerror localizedDescription]);
            if([myerror.localizedDescription rangeOfString:@"Global denied access"].location != NSNotFound) {
                //NSLog(@"无法访问相册.请在'设置->定位服务'设置为打开状态.");
            } else {
               // NSLog(@"相册访问失败.");
            }
        };
        
            
        ALAssetsGroupEnumerationResultsBlock groupEnumerAtion = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if(result != NULL) {
                if([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                    NSString *urlstr = [NSString stringWithFormat:@"%@",result.defaultRepresentation.url];//图片的url
                    [self.pictureArray addObject:urlstr];
                    [self.selectedItemArray addObject:[NSNumber numberWithBool:NO]];
                    [self.collectionView reloadData];
                }
            }
        };
            
        ALAssetsLibraryGroupsEnumerationResultsBlock libraryGroupsEnumeration = ^(ALAssetsGroup* group, BOOL* stop) {
            if(group == nil) {
            }
                
            if(group!=nil) {
                NSString *g=[NSString stringWithFormat:@"%@",group];//获取相簿的组
               // NSLog(@"gg:%@",g);//gg:ALAssetsGroup - Name:Camera Roll, Type:Saved Photos, Assets count:71
                    
                NSString *g1=[g substringFromIndex:16] ;
                NSArray *arr=[[NSArray alloc] init];
                arr=[g1 componentsSeparatedByString:@","];
                NSString *g2=[[arr objectAtIndex:0] substringFromIndex:5];
                if ([g2 isEqualToString:@"Camera Roll"]) {
                    g2=@"相机胶卷";
                }
                
                [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:groupEnumerAtion];
            }
                
        };
            
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library enumerateGroupsWithTypes:ALAssetsGroupAll
                               usingBlock:libraryGroupsEnumeration
                             failureBlock:failureblock
         ];
    
        }
        
    });
}

@end
