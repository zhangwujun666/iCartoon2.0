//
//  RegexKit.m
//  iCartoon
//
//  Created by 寻梦者 on 15/9/30.
//  Copyright (c) 2015年 W3. All rights reserved.
//

#import "RegexKit.h"

@implementation RegexKit
//邮箱
+ (BOOL)validateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//手机号码验证
+ (BOOL)validateMobile:(NSString *)mobile {
    //手机号以13， 15，18开头，八个 \d 数字字符
//    NSString *phoneRegex = @"^0?(17[07]|13[0-9]|15[012356789]|18[0-9]|14[57])[0-9]{8}$";
//    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
//    return [phoneTest evaluateWithObject:mobile];
    if(!mobile || mobile.length != 11 ) {
        return NO;
    }
    NSString *isChinaMobileRegex = @"^134[0-8][0-9]{7}$|^0?(13[5-9]|147|15[0-27-9]|178|18[2-478])[0-9]{8}$";
    NSString *isChinaUnionRegex = @"^0?(13[0-2]|145|15[56]|176|18[56])[0-9]{8}$";
    NSString *isChinaTelComRegex = @"^0?(133|153|177|18[019])[0-9]{8}$";
    NSString *isOtherTelphoneRegex = @"^0?((170|177)[059])[0-9]{7}$";
    NSPredicate *mobilePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",isChinaMobileRegex];
    NSPredicate *unionPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",isChinaUnionRegex];
    NSPredicate *telComPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",isChinaTelComRegex];
    NSPredicate *otherPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",isOtherTelphoneRegex];
    if([mobilePredicate evaluateWithObject:mobile]) {
        return YES;
    } else if([unionPredicate evaluateWithObject:mobile]) {
        return YES;
    } else if([telComPredicate evaluateWithObject:mobile]) {
        return YES;
    } else if([otherPredicate evaluateWithObject:mobile]) {
        return YES;
    } else {
        return NO;
    }
    
}

//用户名
+ (BOOL)validateUserName:(NSString *)name {
    NSString *userNameRegex = @"^[A-Za-z0-9]{6,20}+$";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    BOOL B = [userNamePredicate evaluateWithObject:name];
    return B;
}

//密码
+ (BOOL)validatePassword:(NSString *)passWord {
    NSString *passWordRegex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[A-Za-z0-9]{6,12}$";
//    NSString *passWordRegex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[A-Za-z0-9(!@#$%&_)]{6,12}$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:passWord];
}


//身份证号
+ (BOOL)validateIdentityCard: (NSString *)identityCard {
    NSMutableString *iden =[NSMutableString stringWithFormat:@"%@",identityCard];
    [iden replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:NSMakeRange(0, iden.length)];
    BOOL flag;
    if (iden.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:iden];
}

//真实姓名
+ (BOOL)validateRealname: (NSString *)realname {
    BOOL flag;
    if (realname.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 =@"[\u4e00-\u9fa5]+";
    NSPredicate *realnamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [realnamePredicate evaluateWithObject:realname];
}
//身份证号码验证
+ (BOOL)validateIDCardNumber:(NSString *)value {
    
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    int length =0;
    
    if (!value) {
        
        return NO;
        
    }else {
        
        length = (int)value.length;
        if (length !=15 && length !=18) {
            return NO;
        }
    }
    
    // 省份代码
    NSArray *areasArray =@[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    NSString *valueStart2 = [value substringToIndex:2];
    BOOL areaFlag =NO;
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag =YES;
            break;
        }
    }
    if (!areaFlag) {
        return NO;
    }
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    int year =0;
    switch (length) {
        case 15:
            year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value options:NSMatchingReportProgress range:NSMakeRange(0, value.length)];
            //            [regularExpression release];
            if(numberofMatch >0) {
                return YES;
            }else {
                return NO;
            }
        case 18:
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
                
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$" options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value options:NSMatchingReportProgress range:NSMakeRange(0, value.length)];
            //            [regularExpression release];
            
            if(numberofMatch >0) {
                
                int S = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
                
                int Y = S %11;
                
                NSString *M =@"F";
                
                NSString *JYM =@"10X98765432";
                
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 判断校验位
                
                if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
                    return YES;// 检测ID的校验位
                    
                }else {
                    return NO;
                }
            }else {
                return NO;
            }
        default:
            return NO;
    }
    
}
@end
