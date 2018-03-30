//
//  APIConfig.h
//  GaoZhi
//
//  Created by 寻梦者 on 15/11/3.
//  Copyright © 2015年 GlenN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIConfig : NSObject

#pragma mark - main URL
+ (NSString *)mainURL;

+ (NSString *)imageBaseURL;

#pragma mark - 用户相关
//检查账号在服务端是否已存在
+ (NSString *)checkAccountExistURL;

//发送手机验证码
+ (NSString *)sendSMSCodeURL;

//用户注册
+ (NSString *)userRegisterURL;

//用户登录
+ (NSString *)userLoginURL;

//第三方登录
+ (NSString *)thirdLoginURL;

//忘记密码
+ (NSString *)findPasswordURL;

//提交反馈意见
+ (NSString *)submitFeedbackURL;

//用户退出登录
+ (NSString *)userLogoutURL;

//用户信息
+ (NSString *)userInfoURL;

//更新用户信息
+ (NSString *)updateUserInfoURL;

//修改密码
+ (NSString *)modifyPasswordURL;

//检查更新
+ (NSString *)checkUpdateURL;

//关于
+ (NSString *)aboutUsURL;

//用户协议
+ (NSString *)agreementURL;

#pragma mark - 我的相关
//我的互动信息
+ (NSString *)myInteractionInfoURL;

//我发布的帖子
+ (NSString *)myReleasedPostsURL;

//我收藏的帖子
+ (NSString *)myCollectedPostsURL;

//我收藏的任务
+ (NSString *)myCollectedTasksURL;

//我关注的主题
+ (NSString *)myConcernedThemesURL;

//我关注的主题
+ (NSString *)myConcernedThemes2URL;

//我关注的帖子
+ (NSString *)myConcernedPostsURL;

//我的任务
+ (NSString *)myTasksURL;

//关注或取消主题
+ (NSString *)concernThemeURL;

//我的消息数量
+ (NSString *)myMessageCountURL;

//我评论过的帖子
+ (NSString *)myReplyAndCommentURL;

//我的消息
+ (NSString *)myMessageURL;

//我的评论
+ (NSString *)myCommentsURL;

#pragma mark - 日常相关
//获取主页顶部滚动条
+ (NSString *)homeBannersURL;

//获取主页任务列表
+ (NSString *)homeTasksURL;

//获取主页(顶部)主题列表
+ (NSString *)homeThemesURL;

//搜索主题列表
+ (NSString *)searchThemes2URL;

//获取主页帖子列表
+ (NSString *)homePostsURL;

//获取主页帖子列表
+ (NSString *)homePostsV2URL;

//获取主页帖子列表
+ (NSString *)refreshHomePostsV2URL;

#pragma mark - 任务相关
//任务列表
+ (NSString *)taskListURL;

//任务详情
+ (NSString *)taskInfoURL;

//为任务投票
+ (NSString *)voteForTaskURL;

//收藏任务
+ (NSString *)collectTaskURL;

//用户投稿
+ (NSString *)userContributeURL;

//评论或回复任务
+ (NSString *)taskCommentURL;

#pragma mark - 关注
//获取关注页设计师帖子列表
+ (NSString *)designerPostsURL;

//获取关注页脑洞集帖子列表
+ (NSString *)brainstormPostsURL;

#pragma mark - 发帖
//查询主题
+ (NSString *)searchThemesURL;

//发布帖子
+ (NSString *)publishPostURL;

#pragma mark - 帖子相关
//获取帖子列表
+ (NSString *)postListURL;
//获取帖子详情
+ (NSString *)postInfoURL;
//分享的帖子详情URL
+ (NSString *)postDetailURL;

//帖子相关的评论
+ (NSString *)commentsOfPostURL;

//评论帖子
+ (NSString *)commentPostURL;

//赞或者踩帖子
+ (NSString *)favorPostURL;

//赞或者踩帖子
+ (NSString *)collectPostURL;

//屏蔽帖子
+ (NSString *)maskPostURL;

//举报帖子
+ (NSString *)reportPostURL;

//获取主题帖子
+ (NSString *)themePostsURL;

#pragma mark - 发现相关
//获取发现帖子主题列表
+ (NSString *)discoveryThemesURL;

#pragma mark - 侧边栏
//分组主题列表
+ (NSString *)themeListURL;

//主题详情
+ (NSString *)themeInfoURL;

//搜索
+ (NSString *)searchURL;

#pragma mark - 孵化箱
//热门围观
+ (NSString *)hotPostsURL;

//热门围观(刷新)
+ (NSString *)refreshHotPostsURL;

//最新脑洞帖子
+ (NSString *)newPostsURL;

//最新脑洞帖子(刷新)
+ (NSString *)refreshNewPostsURL;

//最新脑洞 && 全部帖子
+ (NSString *)allPostsURL;

//最新脑洞 && 全部帖子(刷新)
+ (NSString *)refreshAllPostsURL;

//关注的作者
+ (NSString *)concernedAuthorsURL;

//关注的作者(刷新)
+ (NSString *)refreshConcernedAuthorsURL;

//作者信息
+ (NSString *)authorInfoURL;

//作者相关的帖子
+ (NSString *)authorPostsURL;

//作者相关的帖子(刷新)
+ (NSString *)refreshAuthorPostsURL;

#pragma mark - 我的
//我的粉丝
+ (NSString *)myFunsURL;

//我关注的作者
+ (NSString *)myFollowedAuthorsURL;

//关注或者取消关注作者
+ (NSString *)followAuthorURL;

//消息中心
+ (NSString *)messageURL;

//删除帖子
+ (NSString *)deletePostURL;

//设置消息为已读
+ (NSString *)setMessageReadURL;

//删除消息
+ (NSString *)deleteMessageURL;

#pragma mark - 日常
//搜索帖子
+ (NSString *)searchPostsURL;

//刷新搜索的帖子
+ (NSString *)refreshSearchPostsURL;

//关注主题
+ (NSString *)followThemesURL;

@end
