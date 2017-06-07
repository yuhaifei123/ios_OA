//
//  ReadWriteData.h
//  CZJSJOA
//
//  Created by 虞海飞 on 16/10/11.
//  Copyright © 2016年 薛伟俊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReadWriteData : NSObject

/**
 创建文件夹
 */
-(void)createDirFileName :(NSString *) fileName;

/**
 创建文件
 */
-(void)createFileFileName :(NSString *) fileName;

/**
 写文件
 */
-(void)writeFileFileName :(NSString *) fileName Data:(NSMutableData *)data;

/**
 读文件
 */
-(void)readFileFileName :(NSString *) fileName;

/**
 得到文件的路径

 @param fileName <#fileName description#>

 @return <#return value description#>
 */
-(NSString *) textPathFileName:(NSString *)fileName;
@end
