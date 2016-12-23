//
//  DataAccess.m
//  Demo4GT
//
//  Created   on 13-6-4.
//  Copyright ©[Insert Year of First Publication] - 2014 Tencent.All Rights Reserved. This software is licensed under the terms in the LICENSE.TXT file that accompanies this software.
//

#import "DataAccess.h"
#import "DataInfo.h"
@implementation DataAccess
+(NSDictionary *)getDicByPlist{
    NSString *path=[[NSBundle mainBundle] pathForResource:@"dataList" ofType:@"plist"];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithContentsOfFile:path];
    return [dic autorelease];
}
//获取基础联系列表
+(NSMutableArray *)getDateArray{

    NSMutableArray *imageList = [[[NSMutableArray alloc] init] autorelease];

    DataInfo *data = nil;
    
    data = [[[DataInfo alloc] init] autorelease];
    data.width  = 351;
    data.height = 228;
    data.url    = @"http://111.161.48.64/sosopic/0/9869660902850290294/320";
    data.title  = @"风景1";
    data.mess   = @"风景1";
    [imageList addObject:data];
    
    data = [[[DataInfo alloc] init] autorelease];
    data.width  = 351;
    data.height = 228;
    data.url    = @"http://111.161.48.64/sosopic/0/7906532888606229180/320";
    data.title  = @"风景2";
    data.mess   = @"风景2";
    [imageList addObject:data];
    
    data = [[[DataInfo alloc] init] autorelease];
    data.width  = 351;
    data.height = 228;
    data.url    = @"http://111.161.48.64/sosopic/0/9416045979901772820/320";
    data.title  = @"风景3";
    data.mess   = @"风景3";
    [imageList addObject:data];
    
    data = [[[DataInfo alloc] init] autorelease];
    data.width  = 351;
    data.height = 228;
    data.url    = @"http://111.161.48.64/sosopic/0/10614843762795705578/320";
    data.title  = @"风景4";
    data.mess   = @"风景4";
    [imageList addObject:data];
    
    data = [[[DataInfo alloc] init] autorelease];
    data.width  = 351;
    data.height = 228;
    data.url    = @"http://111.161.48.64/sosopic/0/8025199124411859454/320";
    data.title  = @"风景5";
    data.mess   = @"风景5";
    [imageList addObject:data];
    
    data = [[[DataInfo alloc] init] autorelease];
    data.width  = 351;
    data.height = 228;
    data.url    = @"http://111.161.48.64/sosopic/0/5054744870201991274/320";
    data.title  = @"风景6";
    data.mess   = @"风景6";
    [imageList addObject:data];
    
    data = [[[DataInfo alloc] init] autorelease];
    data.width  = 351;
    data.height = 228;
    data.url    = @"http://111.161.48.64/sosopic/0/12417944983283013250/320";
    data.title  = @"风景7";
    data.mess   = @"风景7";
    [imageList addObject:data];
    
    data = [[[DataInfo alloc] init] autorelease];
    data.width  = 351;
    data.height = 228;
    data.url    = @"http://111.161.48.64/sosopic/0/14359830428608672234/320";
    data.title  = @"风景8";
    data.mess   = @"风景8";
    [imageList addObject:data];
    
    data = [[[DataInfo alloc] init] autorelease];
    data.width  = 351;
    data.height = 228;
    data.url    = @"http://111.161.48.64/sosopic/0/5476654313994007188/320";
    data.title  = @"风景9";
    data.mess   = @"风景9";
    [imageList addObject:data];

    return imageList;
}
@end
