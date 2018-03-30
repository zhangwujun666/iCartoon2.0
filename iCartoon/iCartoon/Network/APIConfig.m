//
//  APIConfig.m
//  GaoZhi
//
//  Created by 寻梦者 on 15/11/3.
//  Copyright © 2015年 GlenN. All rights reserved.
//
#import "APIConfig.h"

@implementation APIConfig
/* http://139.196.84.154/am-test-v24*/
//@"http://139.196.84.154/am-v23";
////服务器地址
//static NSString *SERVER_DEFAULT = @"http://121.40.102.225:6060/am-v25/api";
////图片的base URL
//static NSString *IMAGE_BASE_URL = @"http://121.40.102.225:6060/am-v25/";

//正式环境地址
//服务器地址
//static NSString *SERVER_DEFAULT = @"http://139.196.84.154/am-v26/api";
//////图片的base URL
//static NSString *IMAGE_BASE_URL = @"http://139.196.84.154/am-v26";
//
//
static NSString *SERVER_DEFAULT = @"http://139.196.84.154/am-test-v26/api";
//图片的base URL
static NSString *IMAGE_BASE_URL = @"http://139.196.84.154/am-test-v26";
#pragma mark - 日常相关
static NSString *HOME_BANNERS_URL = @"/GetBanners";                     //主页顶部滚动条
static NSString *HOME_TASKS_URL = @"/GetVotes";                         //主页推荐任务
static NSString *HOME_THEMES_URL = @"/GetIndexThemes";                  //主页推荐主题列表
static NSString *HOME_POSTS_URL = @"/GetIndexTopics";                   //主页帖子列表

static NSString *HOME_POSTS_V2_URL = @"/GetIndexTopics_v2";             //主页帖子列表
static NSString *REFRESH_HOME_POSTS_V2_URL = @"/RefreshIndexTopics_v2"; //主页帖子列表(刷新)

#pragma mark - 关注
static NSString *DESIGNER_POSTS_URL = @"/GetTopicsByFollowThemes";      //设计师
static NSString *BRAINSTORM_POSTS_URL = @"/GetTopicsByFollowThemes";    //脑洞集

#pragma mark - 帖子相关
static NSString *SEARCH_THEMES_URL = @"/SearchTheme";                   //搜索主题
static NSString *SEARCH_THEMES_V2_URL = @"/SearchTheme_v2";             //搜索主题
static NSString *PUBLISH_POST_URL = @"/PublishTopic";                   //发表帖子
static NSString *POST_LIST_URL = @"/GetTopics";                         //帖子列表
static NSString *POST_INFO_URL = @"/GetTopicInfo";//帖子详情

static NSString *COMMENTS_OF_POST_URL = @"/GetTopicComments";           //帖子的评论列表
static NSString *COMMENT_POST_URL = @"/CommentTopic";                   //评价帖子
static NSString *FAVOR_POST_URL = @"/ActTopic";                         //点赞或取消点赞帖子
static NSString *COLLECT_POST_URL = @"/CollectTopic";                   //收藏帖子
static NSString *THEME_POSTS_URL = @"/GetTopicsByTheme";               //主题帖子列表
static NSString *MASK_POST_URL = @"/MaskTopic";                         //屏蔽帖子
static NSString *REPORT_POST_URL = @"/ReportTopic";                     //举报帖子
static NSString *POST_DETAIL_URL = @"/goGetTopicInfo";                  //分享的帖子详情

#pragma mark - 登录注册
static NSString *CHECK_ACCOUNT_EXIST_URL = @"/CheckAccountIsExist";     //检查账户是否存在
static NSString *SEND_MSM_CODE_URL = @"/UserGetCAPTCHA";                //获取手机验证码
static NSString *USER_REGISTER_URL = @"/UserRegister";                  //用户注册
static NSString *USER_LOGIN_URL = @"/UserLogin";                        //用户登录
static NSString *THIRD_LOGIN_URL = @"/ThirdPartyLogin";                 //第三方登录
static NSString *FIND_PASSWORD_URL = @"/FindPassword";                  //找回密码

#pragma mark - 用户相关
static NSString *SUBMIT_FEEDBACK_URL = @"/UploadUserOpinion";           //用户反馈
static NSString *USER_LOGOUT_URL = @"/Logout";                          //退出登录
static NSString *USER_INFO_URL = @"/GetAccountInfo";                    //获取用户信息
static NSString *UPDATE_USER_INFO_URL = @"/UpdateUser";                 //更新用户信息
static NSString *MODIFY_PASSWORD_URL = @"/UpdatePassword";              //修改密码
static NSString *CHECK_UPDATE_URL = @"/IsNeedUpdate";                   //检查版本更新
static NSString *ABOUT_US_URL = @"/GetAboutUs";                         //关于我们
static NSString *AGREEMENT_URL = @"/GetUserProtocol";                   //用户协议

#pragma mark - 我的相关
static NSString *MY_RELEASED_POSTS_URL = @"/MyPublishTopics";           //我发布的帖子
static NSString *MY_COLLECTED_POSTS_URL = @"/GetCollectedTopics";       //我收藏的帖子
static NSString *MY_CONCERNED_THEMES_V2_URL = @"/MyFollowThemes_v2";    //我关注的所有主题
static NSString *MY_CONCERNED_THEMES_URL = @"/MyFollowThemes";          //我关注的所有主题
static NSString *MY_CONCERNED_POSTS_URL = @"/GetTopicsByFollowThemes";  //我关注的所有帖子
static NSString *CONCERN_THEME_URL = @"/FollowThemes_v2";                //关注或者取消关注
static NSString *MY_INTERACTION_INFO_URL = @"/MyActionCounts_v2";        //我的互动信息
static NSString *MY_MESSAGE_COUNT_URL = @"/MyMessageCounts";            //我的消息、收藏、评论信息
static NSString *REPLY_AND_COMMENT_URL = @"/MyCommentMessages_v2";         //回复评论
static NSString *FOLLOW_THEME_URL = @"/FollowTheme";                    //关注或者取消关注主题
static NSString *MY_MESSAGE_URL = @"/MyCommentMessages_v2";             //我的消息
static NSString *MY_COMMENTS_URL = @"/MyComment_v2";                    //我的评论
static NSString *MY_FUNS_URL = @"/MyFans_v2";                           //我的粉丝

#pragma mark - 任务相关
static NSString *TASK_LIST_URL = @"/GetVotes";                          //任务列表
static NSString *TASK_INFO_URL = @"/GetVoteInfo";                       //任务详情
static NSString *VOTE_FOR_TASK_URL = @"/Vote";                          //为任务投票
static NSString *COLLECT_TASK_URL = @"/CollectVote";                    //收藏任务
static NSString *MY_COLLECTED_TASKS_URL = @"/GetCollectedVotes";        //我收藏的任务
static NSString *MY_TASKS_URL = @"/MyJoinedVotes";                      //我的任务
static NSString *USER_CONTRIBUTE_URL = @"/AddVoteItem_v2";              //用户投稿
static NSString *TASK_COMMENT_URL = @"/CommentVote_v2";                 //评论任务

#pragma mark - 发现
static NSString *DISCOVERY_THEMES_URL = @"/GetThemeType";               //发现主题列表
static NSString *DISCOVERY_POSTS_URL = @"/GetTopics";                   //发现帖子列表

#pragma mark - 侧边栏
static NSString *THEME_LIST_URL = @"/GetThemes_v2";                        //所有的主题列表
static NSString *THEME_INFO_URL = @"/GetThemeInfo_v2";                     //主题详情
static NSString *SEARCH_URL = @"/Search";                                  //搜索

#pragma mark - 孵化箱
static NSString *HOT_POSTS_URL = @"/GetHotTopics_v2";                      //热门帖子(热门围观)
static NSString *REFRESH_HOT_POSTS_URL = @"/GetHotTopics_v2";         //热门帖子(热门围观)(刷新)
static NSString *NEW_POSTS_URL = @"/GetNewOrHotTopics_v2";                      //热门帖子(热门围观)
static NSString *REFRESH_NEW_POSTS_URL = @"/FreshGetNewTopics_v2";         //热门帖子(热门围观)(刷新)
static NSString *ALL_POSTS_URL = @"/GetTopics_v2";                         //(最新脑洞/全部)帖子
static NSString *REFRESH_ALL_POSTS_URL = @"/FreshTopics_v2";               //(最新脑洞/全部)帖子(刷新)
static NSString *CONCERNED_AUTHORS_URL = @"/GetUserTopics_v2";                 //(关注的作者)帖子
static NSString *REFRESH_CONCERNED_AUTHORS_URL = @"/FreshGetUserTopics_v2";    //(关注的作者)帖子(刷新)
static NSString *AUTHOR_POSTS_URL = @"/UserDetailsTopics_v2";              //(作者相关的)帖子(刷新)
static NSString *REFRESH_AUTHOR_POSTS_URL = @"/FreshUserDetailsTopics_v2"; //(作者相关的)帖子(刷新)

static NSString *AUTHOR_INFO_URL = @"/GetAuthorInfo";                      //作者信息
static NSString *MY_FOLLOWED_AUTHORS_URL = @"/MyFollowUsers_v2";           //我关注的作者
static NSString *FOLLOW_AUTHOR_URL = @"/FollowUser_v2";                    //关注或取消关注作者

static NSString *MESSAGE_CENTER_URL = @"/MessageCenter_v2";                //消息中心
static NSString *DELETE_POST_URL = @"/DeleteMyTopics_v2";                  //删除帖子
static NSString *SET_MESSAGE_READ_URL = @"/MessageRead_v2";                //设置消息为已读
static NSString *DELETE_MESSAGE_URL = @"/MessageCenterDelete_v2";          //删除消息

static NSString *SEARCH_POST_URL = @"/SearchTopics_v2";                    //搜索帖子
static NSString *REFRESH_SEARCH_POST_URL = @"/RefreshSearchTopics_v2";     //刷新搜索帖子

static NSString *FOLLOW_THEMES_V2_URL = @"/FollowThemes_v2";                    //关注或者取消关注主题

#pragma mark - main URL
+ (NSString *)mainURL {
    return [NSString stringWithFormat:@"%@", SERVER_DEFAULT];
}

+ (NSString *)imageBaseURL {
    return [NSString stringWithFormat:@"%@", IMAGE_BASE_URL];
}

#pragma mark - 主页相关
//获取主页顶部滚动条
+ (NSString *)homeBannersURL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], HOME_BANNERS_URL];
}

//获取主页任务列表
+ (NSString *)homeTasksURL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], HOME_TASKS_URL];
}

//获取主页(顶部)主题列表
+ (NSString *)homeThemesURL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], HOME_THEMES_URL];
}

//搜索主题列表
+ (NSString *)searchThemes2URL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], SEARCH_THEMES_V2_URL];
}

//获取主页帖子列表
+ (NSString *)homePostsURL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], HOME_POSTS_URL];
}

//获取主页帖子列表
+ (NSString *)homePostsV2URL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], HOME_POSTS_V2_URL];
}

//获取主页帖子列表
+ (NSString *)refreshHomePostsV2URL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], REFRESH_HOME_POSTS_V2_URL];
}

#pragma mark - 任务相关
//任务列表
+ (NSString *)taskListURL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], TASK_LIST_URL];
}

//任务详情
+ (NSString *)taskInfoURL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], TASK_INFO_URL];
}

//为任务投票
+ (NSString *)voteForTaskURL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], VOTE_FOR_TASK_URL];
}

//收藏任务
+ (NSString *)collectTaskURL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], COLLECT_TASK_URL];
}

//用户投稿
+ (NSString *)userContributeURL {
     return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], USER_CONTRIBUTE_URL];
}

//评论或回复任务
+ (NSString *)taskCommentURL {
     return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], TASK_COMMENT_URL];
}

#pragma mark - 用户相关
//检查账号在服务端是否已存在
+ (NSString *)checkAccountExistURL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], CHECK_ACCOUNT_EXIST_URL];
}

//发送手机验证码
+ (NSString *)sendSMSCodeURL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], SEND_MSM_CODE_URL];
}

//用户注册
+ (NSString *)userRegisterURL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], USER_REGISTER_URL];
}

//用户登录
+ (NSString *)userLoginURL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], USER_LOGIN_URL];
}

//第三方登录
+ (NSString *)thirdLoginURL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], THIRD_LOGIN_URL];
}

//忘记密码
+ (NSString *)findPasswordURL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], FIND_PASSWORD_URL];
}

//提交反馈意见
+ (NSString *)submitFeedbackURL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], SUBMIT_FEEDBACK_URL];
}

//用户退出登录
+ (NSString *)userLogoutURL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], USER_LOGOUT_URL];
}

//用户信息
+ (NSString *)userInfoURL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], USER_INFO_URL];
}

//更新用户信息
+ (NSString *)updateUserInfoURL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], UPDATE_USER_INFO_URL];
}

//修改密码
+ (NSString *)modifyPasswordURL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], MODIFY_PASSWORD_URL];
}

//检查更新
+ (NSString *)checkUpdateURL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], CHECK_UPDATE_URL];
}

//关于
+ (NSString *)aboutUsURL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], ABOUT_US_URL];
}

//用户协议
+ (NSString *)agreementURL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], AGREEMENT_URL];
}

#pragma mark - 我的相关
//我的互动信息
+ (NSString *)myInteractionInfoURL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], MY_INTERACTION_INFO_URL];
}

//我发布的帖子
+ (NSString *)myReleasedPostsURL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], MY_RELEASED_POSTS_URL];
}

//我收藏的帖子
+ (NSString *)myCollectedPostsURL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], MY_COLLECTED_POSTS_URL];
}

//我收藏的任务
+ (NSString *)myCollectedTasksURL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], MY_COLLECTED_TASKS_URL];
}

//我的消息数量
+ (NSString *)myMessageCountURL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], MY_MESSAGE_COUNT_URL];
}

//我关注的主题
+ (NSString *)myConcernedThemesURL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], MY_CONCERNED_THEMES_URL];
}

//我关注的主题
+ (NSString *)myConcernedThemes2URL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], MY_CONCERNED_THEMES_V2_URL];
}

//我关注的帖子
+ (NSString *)myConcernedPostsURL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], MY_CONCERNED_POSTS_URL];
}

//我的任务
+ (NSString *)myTasksURL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], MY_TASKS_URL];
}

//关注或取消主题
+ (NSString *)concernThemeURL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], CONCERN_THEME_URL];
}

//我评论过的帖子
+ (NSString *)myReplyAndCommentURL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], REPLY_AND_COMMENT_URL];
}

//我的消息
+ (NSString *)myMessageURL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], MY_MESSAGE_URL];
}

//我的评论
+ (NSString *)myCommentsURL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], MY_COMMENTS_URL];
}

#pragma mark - 关注相关
//获取关注(设计师)帖子列表
+ (NSString *)designerPostsURL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], DESIGNER_POSTS_URL];
}

//获取关注(脑洞集)帖子列表
+ (NSString *)brainstormPostsURL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], BRAINSTORM_POSTS_URL];
}

#pragma mark - 发帖
//查询主题
+ (NSString *)searchThemesURL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], SEARCH_THEMES_V2_URL];
}

//发布帖子
+ (NSString *)publishPostURL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], PUBLISH_POST_URL];
}

#pragma mark - 帖子相关
//获取帖子详情
+ (NSString *)postInfoURL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], POST_INFO_URL];
}
//举报
static NSString *report_DETAIL_URL = @"/ReportTopic";
+ (NSString *)reportURL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], report_DETAIL_URL];
}
//分享的帖子详情URL
+ (NSString *)postDetailURL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], POST_DETAIL_URL];
}

//帖子相关的评论
+ (NSString *)commentsOfPostURL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], COMMENTS_OF_POST_URL];
}

//评论帖子
+ (NSString *)commentPostURL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], COMMENT_POST_URL];
}

//赞或者踩帖子
+ (NSString *)favorPostURL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], FAVOR_POST_URL];
}

//收藏帖子
+ (NSString *)collectPostURL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], COLLECT_POST_URL];
}

//屏蔽帖子
+ (NSString *)maskPostURL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], MASK_POST_URL];
}

//举报帖子
+ (NSString *)reportPostURL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], REPORT_POST_URL];
}

#pragma mark - 发现相关
//获取发现帖子主题列表
+ (NSString *)discoveryThemesURL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], DISCOVERY_THEMES_URL];
}

//获取帖子列表
+ (NSString *)postListURL {
//    NSLog(@"================%@",[NSString stringWithFormat:@"%@%@", [APIConfig mainURL], POST_LIST_URL]);
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], POST_LIST_URL];
}

#pragma mark - 侧边栏
//分组主题列表
+ (NSString *)themeListURL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], THEME_LIST_URL];
}

//主题详情
+ (NSString *)themeInfoURL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], THEME_INFO_URL];
}

//获取主题帖子
+ (NSString *)themePostsURL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], THEME_POSTS_URL];
}

//搜索
+ (NSString *)searchURL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], SEARCH_URL];
}

#pragma mark - 孵化箱
//热门围观
+ (NSString *)hotPostsURL {
   
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], HOT_POSTS_URL];
}

//热门围观(刷新)
+ (NSString *)refreshHotPostsURL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], REFRESH_HOT_POSTS_URL];
}

//最新脑洞帖子
+ (NSString *)newPostsURL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], NEW_POSTS_URL];
}

//最新脑洞帖子(刷新)
+ (NSString *)refreshNewPostsURL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], REFRESH_NEW_POSTS_URL];
}

//全部帖子
+ (NSString *)allPostsURL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], ALL_POSTS_URL];
}

//全部帖子(刷新)
+ (NSString *)refreshAllPostsURL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], REFRESH_ALL_POSTS_URL];
}

#pragma mark - 作者相关
//关注的作者
+ (NSString *)concernedAuthorsURL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], CONCERNED_AUTHORS_URL];
}

//关注的作者(刷新)
+ (NSString *)refreshConcernedAuthorsURL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], REFRESH_CONCERNED_AUTHORS_URL];
}

//作者信息
+ (NSString *)authorInfoURL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], AUTHOR_INFO_URL];
}

//作者相关的帖子
+ (NSString *)authorPostsURL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], AUTHOR_POSTS_URL];
}

//作者相关的帖子(刷新)
+ (NSString *)refreshAuthorPostsURL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], REFRESH_AUTHOR_POSTS_URL];
}

//我关注的作者
+ (NSString *)myFollowedAuthorsURL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], MY_FOLLOWED_AUTHORS_URL];
}

//关注或者取消关注作者
+ (NSString *)followAuthorURL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], FOLLOW_AUTHOR_URL];
}

#pragma mark - 我的
//我的粉丝
+ (NSString *)myFunsURL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], MY_FUNS_URL];
}

//消息中心
+ (NSString *)messageURL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], MESSAGE_CENTER_URL];
}

//删除帖子
+ (NSString *)deletePostURL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], DELETE_POST_URL];
}

//设置消息为已读
+ (NSString *)setMessageReadURL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], SET_MESSAGE_READ_URL];
}

//删除消息
+ (NSString *)deleteMessageURL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], DELETE_MESSAGE_URL];
}

#pragma mark - 日常
//搜索帖子
+ (NSString *)searchPostsURL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], SEARCH_POST_URL];
}

//刷新搜索的帖子
+ (NSString *)refreshSearchPostsURL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], REFRESH_SEARCH_POST_URL];
}

//关注主题
+ (NSString *)followThemesURL {
    return [NSString stringWithFormat:@"%@%@", [APIConfig mainURL], FOLLOW_THEMES_V2_URL];
}

@end
