//
//  ReadWriteData.m
//  CZJSJOA
//
//  Created by 虞海飞 on 16/10/11.
//  Copyright © 2016年 薛伟俊. All rights reserved.
//

#import "ReadWriteData.h"

@implementation ReadWriteData

-(NSArray *) stringFen:(NSString *)file{

    NSArray *fileParts  = [file componentsSeparatedByString:@"."];
    return fileParts;
}


/**
 获取Documents目录

 @return <#return value description#>
 */
-(NSString *)dirDoc{
    //[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSLog(@"app_home_doc: %@",documentsDirectory);
    return documentsDirectory;
}


/**
 创建文件夹
 */
-(void)createDirFileName :(NSString *) fileName{
    NSString *documentsPath =[self dirDoc];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *array = [self stringFen:fileName];
    NSString *testDirectory = [documentsPath stringByAppendingPathComponent:array[1]];
    // 创建目录
    [fileManager createDirectoryAtPath:testDirectory withIntermediateDirectories:YES attributes:nil error:nil];
//    if (res) {
//        NSLog(@"文件夹创建成功");
//    }else{
//        NSLog(@"文件夹创建失败");
//    }
}

/**
 创建文件
 */
-(void)createFileFileName :(NSString *) fileName{
    
    NSString *documentsPath =[self dirDoc];
    NSArray *array = [self stringFen:fileName];
    NSString *testDirectory = [documentsPath stringByAppendingPathComponent:array[1]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *testPath = [testDirectory stringByAppendingPathComponent:fileName];
    [fileManager createFileAtPath:testPath contents:nil attributes:nil];
//    if (res) {
//        NSLog(@"文件创建成功: %@" ,testPath);
//    }else
//        NSLog(@"文件创建失败");
}


/**
 得到文件的路径

 @param fileName <#fileName description#>

 @return <#return value description#>
 */
-(NSString *) textPathFileName:(NSString *)fileName{
    NSString *documentsPath =[self dirDoc];
    NSArray *array = [self stringFen:fileName];
    NSString *testDirectory = [documentsPath stringByAppendingPathComponent:array[1]];
    NSString *testPath = [testDirectory stringByAppendingPathComponent:fileName];

    return testPath;
}

/**
 写文件
 */
-(void)writeFileFileName :(NSString *) fileName Data:(NSMutableData *)data{
    NSString *documentsPath =[self dirDoc];
    NSArray *array = [self stringFen:fileName];
    NSString *testDirectory = [documentsPath stringByAppendingPathComponent:array[1]];
    NSString *testPath = [testDirectory stringByAppendingPathComponent:fileName];

    [data writeToFile:testPath atomically:YES];
//    if (res) {
//        NSLog(@"文件写入成功");
//    }else
//        NSLog(@"文件写入失败");
}

/**
 读文件
 */
-(void)readFileFileName :(NSString *) fileName{
    NSString *documentsPath =[self dirDoc];
      NSArray *array = [self stringFen:fileName];
    NSString *testDirectory = [documentsPath stringByAppendingPathComponent:array[1]];
    NSString *testPath = [testDirectory stringByAppendingPathComponent:fileName];

   NSMutableData *content = [NSMutableData dataWithContentsOfFile:testPath];
   // NSLog(@"文件读取成功: %@",content);
}
@end
