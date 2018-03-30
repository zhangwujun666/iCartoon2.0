//
//  CommentTableViewCell.m
//  GaoZhi
//
//  Created by 寻梦者 on 15/10/27.
//  Copyright © 2015年 GlenN. All rights reserved.
//

#import "CommentTableViewCell.h"
#import <UIImageView+WebCache.h>
#import "PostActionButton.h"

#import "LookBigPicViewController.h"

@interface CommentTableViewCell ()
@property (nonatomic,strong)UIImageView * imageV;
@property (strong, nonatomic) PostActionButton *replyButton;
@property(nonatomic, strong) NSArray* matches;

@end
@implementation CommentTableViewCell
static NSString * commentstr;
- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(TRANS_VALUE(10.0f), TRANS_VALUE(11.5f), TRANS_VALUE(27.5f), TRANS_VALUE(27.5f))];
        self.avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.avatarImageView];
        self.avatarImageView.clipsToBounds = YES;
        self.avatarImageView.layer.borderColor = UIColorFromRGB(0xcccccc).CGColor;
        self.avatarImageView.layer.borderWidth = 0.5f;
        self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width / 2;
        self.avatarImageView.image = [UIImage imageNamed:@"ic_avatar_default"];
        self.nicknameLabel = [[UILabel alloc] initWithFrame:CGRectMake(TRANS_VALUE(46.0f), TRANS_VALUE(11.5f), TRANS_VALUE(264.0f), TRANS_VALUE(20.0f))];
        self.nicknameLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(12.0f)];
        self.nicknameLabel.textColor = I_COLOR_33BLACK;
        self.nicknameLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.nicknameLabel];
        self.nicknameLabel.text = @"笑颜如花";
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(TRANS_VALUE(46.0f), TRANS_VALUE(25.0f), TRANS_VALUE(160.0f), TRANS_VALUE(16.0f))];
        self.timeLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(10.0f)];
        self.timeLabel.textColor = UIColorFromRGB(0xcccccc);
        self.timeLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.timeLabel];
        self.timeLabel.text = @"2016-01-23 23:02:00";
        
        //self.commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(TRANS_VALUE(46.0f), TRANS_VALUE(37.0f), TRANS_VALUE(214.0f), TRANS_VALUE(30.0f))];
        self.commentLabel = [[PPLabel alloc] initWithFrame:CGRectMake(TRANS_VALUE(46.0f), CGRectGetMaxY(self.timeLabel.frame), SCREEN_WIDTH-TRANS_VALUE(62.0f) , TRANS_VALUE(25.0f))];
        self.commentLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(11.0f)];
        self.commentLabel.textColor = I_COLOR_DARKGRAY;
        self.commentLabel.textAlignment = NSTextAlignmentLeft;
        self.commentLabel.numberOfLines = 0;
        [self.contentView addSubview:self.commentLabel];
        self.commentLabel.delegate = self;
//        self.commentLabel.text = @"回复笑颜如花现在科学这么发达, 岂止是用于高考, 更多的科学领域都可以收益。";
        UIImageView * imageV = [[UIImageView alloc]init];
        imageV.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
        [imageV addGestureRecognizer:tap];
       [UIColor colorWithRed:240/250.f green:240/250.f blue:240/250.f alpha:1.0f];
        self.imageV = imageV;
        [self.contentView addSubview:self.imageV];
        
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = I_COLOR_WHITE;
    self.accessoryType = UITableViewCellAccessoryNone;
    
    UITapGestureRecognizer *avatarTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(authorTapAction:)];
    self.avatarImageView.userInteractionEnabled = YES;
    [self.avatarImageView addGestureRecognizer:avatarTap];
    
    UITapGestureRecognizer *nameTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(authorTapAction:)];
    self.nicknameLabel.userInteractionEnabled = YES;
    [self.nicknameLabel addGestureRecognizer:nameTap];
    
    [self.replyButton addTarget:self action:@selector(replyButtonAction) forControlEvents:UIControlEventTouchUpInside];
    return self;
}
- (void)tapClick:(UITapGestureRecognizer *)sender{
    LookBigPicViewController *picVC = [[LookBigPicViewController alloc] init];
    NSMutableArray *thumbnailArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *pictureArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *titleArray = [NSMutableArray arrayWithCapacity:0];
        [thumbnailArray addObject:_commentInfo.image];
        [pictureArray addObject:_commentInfo.image];
        [titleArray addObject:@""];
    [picVC initWithAllBigUrlArray:pictureArray andSmallUrlArray:thumbnailArray andTargets:self andIndex:sender.view.tag];
    [picVC bigPicDescribe:titleArray];
    [picVC pushChildViewControllerFromCenter];
}
- (void)setCommentInfo:(PostCommentInfo *)commentInfo {
    _commentInfo = commentInfo;
    if(_commentInfo) {
        self.nicknameLabel.text = _commentInfo.author.nickname != nil ? _commentInfo.author.nickname : @"";
        [self.nicknameLabel sizeToFit];
        [self  showNickname:self.nicknameLabel.text];
        
        NSString *timeStr = _commentInfo.createTime != nil ? _commentInfo.createTime : @"";
        if([timeStr isEqualToString:@""]) {
            timeStr = @"未知时间";
        } else if(timeStr.length >= 19){
            timeStr = [timeStr substringWithRange:NSMakeRange(5, 11)];
        } else {
            timeStr = timeStr;
        }
        self.timeLabel.text = timeStr;
        NSString *comment = _commentInfo.content != nil ? _commentInfo.content : @"";
         NSString *dataGBKtitle = [comment stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        NSLog(@"dataGBKtitle ====== %@",comment);
        NSString * mstrq = [self filterHTML:dataGBKtitle];
        mstrq = [mstrq stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
        mstrq = [mstrq stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
        if(!_commentInfo.replier) {
            self.commentLabel.text = mstrq;
            NSError *error = NULL;
            NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:&error];
//            NSString * str = [NSString stringWithFormat:@"%@",self.commentLabel.attributedText] ;
            if (mstrq) {
                self.matches = [detector matchesInString:mstrq options:0 range:NSMakeRange(0, mstrq.length)];
                [self highlightLinksWithIndex:NSNotFound];
            }
            
        } else {
            NSString *relierName = _commentInfo.replier.nickname;
            NSMutableString *mStr = [NSMutableString stringWithString:@"回复 @"];
            [mStr appendFormat:@"%@:", relierName];
            [mStr appendFormat:@"%@", mstrq];
         self.commentLabel.text = mStr;
//            NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:mStr];
//            [attriStr addAttribute:NSForegroundColorAttributeName value:I_COLOR_DARKGRAY range:NSMakeRange(0, attriStr.length)];
//            [attriStr addAttribute:NSForegroundColorAttributeName value:I_COLOR_YELLOW range:NSMakeRange(3, relierName.length + 1)];
//            self.commentLabel.attributedText = attriStr;
            NSError *error = NULL;
            NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:&error];
            self.matches = [detector matchesInString:mStr options:0 range:NSMakeRange(0, mStr.length)];
            [self highlightLinksWithIndex:NSNotFound];
            
        }
        commentstr = self.commentLabel.text;
        if(_commentInfo.author.avatar && _commentInfo.author.avatar.length > 0) {
            [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:_commentInfo.author.avatar] placeholderImage:[UIImage imageNamed:@"ic_avatar_default"] completed:nil];
        }
        if (_commentInfo.imageWidth) {
//            self.imageV.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_commentInfo.image] options:NSDataReadingMappedIfSafe error:nil]];
            [self.imageV sd_setImageWithURL:[NSURL URLWithString:_commentInfo.image] placeholderImage:nil];
            imageHeight = (_commentInfo.imageHeight*self.commentLabel.frame.size.width/_commentInfo.imageWidth)*0.6;
        }else{
            imageHeight = 0;
        }
    }
}

#pragma mark -

- (void)label:(PPLabel *)label didBeginTouch:(UITouch *)touch onCharacterAtIndex:(CFIndex)charIndex {
//    self.userInteractionEnabled = NO;
    [self highlightLinksWithIndex:charIndex];
}

- (void)label:(PPLabel *)label didMoveTouch:(UITouch *)touch onCharacterAtIndex:(CFIndex)charIndex {
    
    [self highlightLinksWithIndex:charIndex];
}

- (void)label:(PPLabel *)label didEndTouch:(UITouch *)touch onCharacterAtIndex:(CFIndex)charIndex {
    self.userInteractionEnabled = YES;
    [self highlightLinksWithIndex:NSNotFound];
    
    for (NSTextCheckingResult *match in self.matches) {
        
        if ([match resultType] == NSTextCheckingTypeLink) {
            
            NSRange matchRange = [match range];
            
            if ([self isIndex:charIndex inRange:matchRange]) {
                
                [[UIApplication sharedApplication] openURL:match.URL];
                break;
            }
        }
    }
    
}

- (void)label:(PPLabel *)label didCancelTouch:(UITouch *)touch {
    
    [self highlightLinksWithIndex:NSNotFound];
}

#pragma mark -

- (BOOL)isIndex:(CFIndex)index inRange:(NSRange)range {
   return index > range.location && index < range.location+range.length;
}

- (void)highlightLinksWithIndex:(CFIndex)index {
    NSMutableAttributedString* attributedString = [self.commentLabel.attributedText mutableCopy];
    for (NSTextCheckingResult *match in self.matches) {
        
        if ([match resultType] == NSTextCheckingTypeLink) {
            
            NSRange matchRange = [match range];
            
            if ([self isIndex:index inRange:matchRange]) {
                [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:matchRange];
            }
            else {
                [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:matchRange];
            }
            
            [attributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:matchRange];
        }
    }
    if (_commentInfo.replier) {
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(3, _commentInfo.replier.nickname.length+1)];
    }
    self.commentLabel.attributedText = attributedString;
}
-(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    //        NSString * regEx = @"<([^>]*)>";
    //        html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
static float imageHeight;
- (void)layoutSubviews {
    [super layoutSubviews];
    //TODO -- 重新布局
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:TRANS_VALUE(12.0f)],NSFontAttributeName, nil];
    CGRect rect = [self.commentLabel.text boundingRectWithSize:CGSizeMake(self.commentLabel.frame.size.width , MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    CGFloat labelHeight = floor(rect.size.height + 1);
    if(labelHeight < TRANS_VALUE(30.0f)) {
        labelHeight = TRANS_VALUE(30.0f);
    } else {
        labelHeight += TRANS_VALUE(5.0f);
    }
    self.commentLabel.frame = CGRectMake(self.commentLabel.frame.origin.x, self.commentLabel.frame.origin.y,self.commentLabel.frame.size.width, labelHeight);
    
    if (_commentInfo.imageWidth) {
        float scarl = _commentInfo.imageWidth/self.commentLabel.frame.size.width;
        self.imageV.frame = CGRectMake(self.commentLabel.frame.origin.x, CGRectGetMaxY(self.commentLabel.frame)+5, self.commentLabel.frame.size.width*0.6, (_commentInfo.imageHeight/scarl)*0.6);
        
    }else{
        self.imageV.frame =  CGRectMake(0, 0, 0, 0);
    }
    CGFloat buttonY = TRANS_VALUE(36.0f) + labelHeight - self.replyButton.frame.size.height;
    self.replyButton.frame = CGRectMake(self.replyButton.frame.origin.x, buttonY, self.replyButton.frame.size.width, self.replyButton.frame.size.height);
    self.contentView.frame = CGRectMake(self.contentView.frame.origin.x, self.contentView.frame.origin.y, self.contentView.frame.size.width,self.avatarImageView.frame.size.height+TRANS_VALUE(11.5f)+ self.commentLabel.frame.size.height + self.replyButton.frame.size.height+self.imageV.frame.size.height+5);
}

#pragma mark - Action
- (void)authorTapAction:(id)sender {
    if([self.delegate respondsToSelector:@selector(clickAuthorAtIndexPath:)]) {
        [self.delegate clickAuthorAtIndexPath:self.selectIndexPath];
    }
}

- (void)atAuthorTapAction:(id)sender {
    if([self.delegate respondsToSelector:@selector(clickAtAuthorAtIndexPath:)]) {
        [self.delegate clickAtAuthorAtIndexPath:self.selectIndexPath];
    }
}

- (void)replyButtonAction {
    //回复按钮点击事件
    if([self.delegate respondsToSelector:@selector(replyCommentAtIndexPath:)]) {
        [self.delegate replyCommentAtIndexPath:self.selectIndexPath];
    }
}

//
+ (CGFloat)heightForCell:(NSIndexPath *)indexPath withCommentInfo:(PostCommentInfo *)commentInfo {
    CGFloat height = TRANS_VALUE(40.0f);
    if(commentInfo.content) {
         NSString *dataGBKtitle = [commentInfo.content stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:TRANS_VALUE(12.0f)],NSFontAttributeName, nil];
        NSString *relierName = commentInfo.author.nickname;
        NSMutableString *mStr = [NSMutableString stringWithString:@"@"];
        [mStr appendFormat:@"%@:", relierName];
        [mStr appendFormat:@"%@",dataGBKtitle];
        NSString *comment =mStr;
        CGRect rect = [comment boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - TRANS_VALUE(64.0f), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        CGFloat labelHeight = floor(rect.size.height + 1);
        if(labelHeight < TRANS_VALUE(20.0f)) {
            labelHeight = TRANS_VALUE(35.0f);
        } else {
            labelHeight += TRANS_VALUE(12.0f);
        }
        height += labelHeight;
    } else {
        height += TRANS_VALUE(30.0f);
    }
    if (commentInfo.image) {
        height += imageHeight+ TRANS_VALUE(12.0f);
    }
    return height;
}


-(void)showNickname:(NSString*)nickName{
    
    if (nickName.length > 15) {
        
        nickName = [nickName substringToIndex:15];
        NSString *nickNameStr = nickName;
        self.nicknameLabel.text = [NSString  stringWithFormat:@"%@",nickNameStr];
        
    }else{
        
        
    }
    
    
}

@end
