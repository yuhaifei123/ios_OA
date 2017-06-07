//
//  DownloadData.m
//  CZJSJOA
//
//  Created by 虞海飞 on 16/10/11.
//  Copyright © 2016年 薛伟俊. All rights reserved.
//

#import "DownloadData.h"
#import "ReadWriteData.h"
#import "QuickLookVC.h"

@interface DownloadData()

@property (nonatomic,copy) NSString *filename;
@property (nonatomic,strong) NSMutableData *receivedData;
@property (nonatomic,strong) UIViewController * vc;

//读写数据
@property (nonatomic,strong) ReadWriteData *readWriteData;
@end

@implementation DownloadData

-(ReadWriteData *) readWriteData{

    if (_readWriteData == false) {

        _readWriteData = [[ReadWriteData alloc] init];
    }
    return  _readWriteData;
}


/**
 下载文件

 @param filePath <#filePath description#>
 @param vc       <#vc description#>
 */
-(void) downloadDataFilePath:(NSString *)filePath VC:(UIViewController *)vc{

    _vc = vc;
    //拼接下载路径
    NSURL *url = [NSURL URLWithString:filePath];
    NSString *str1 = [url absoluteString];
    NSRange range = [str1 rangeOfString:@"downname="];
    int location = range.location;
    NSString *filename = [str1 substringFromIndex:location+9];

    range = [filename rangeOfString:@"&path"];
    location = range.location;
    filename = [filename substringToIndex:location];
    range = [filename rangeOfString:@"."];
    filename = [filename substringFromIndex:range.location];
    self.filename =[NSString stringWithFormat:@"%@%@",@"temp",filename];
    [MBProgressHUD showMessage:@"正在努力加载中...."];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:5.0f];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    if (connection)
    {
        self.receivedData = [NSMutableData data];//初始化接收数据的缓存
    }else{

        NSLog(@"Bad Connection!");
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{

    [_receivedData setLength:0];//置空数据
    long long mp3Size = [response expectedContentLength];//获取要下载的文件的长度
    NSLog(@"%@",response.MIMEType) ;
    NSLog(@"%lld",mp3Size);

}

/**
 异步接受回来的数据，判断类型

 @param connection <#connection description#>
 @param data       <#data description#>
 */
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{

    NSRange range = [self.filename  rangeOfString:@".txt"];
    int bz = (int)range.length;

    if (bz>0) {

        //判断是UNICODE编码
        NSString *isUNICODE = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

        //还是ANSI编码
        NSString *isANSI = [[NSString alloc] initWithData:data encoding:-2147482062];

        if (isUNICODE) {

            NSString *retStr = [[NSString alloc]initWithCString:[isUNICODE UTF8String] encoding:NSUTF8StringEncoding];

            NSData *data1 = [retStr dataUsingEncoding:NSUTF16StringEncoding];
            [_receivedData appendData:data1];
        }else if(isANSI){

            NSData *data1 = [isANSI dataUsingEncoding:NSUTF16StringEncoding];
            [_receivedData appendData:data1];
        }

    }else{

        [_receivedData appendData:data];
    }
}

/**
 接收完毕

 @param connection <#connection description#>
 */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{

    [connection cancel];
    [MBProgressHUD hideHUD];

    [self.readWriteData createDirFileName:self.filename];
    [self.readWriteData createFileFileName:self.filename];
    [self.readWriteData writeFileFileName:self.filename Data:_receivedData];

    if ([self.delegate respondsToSelector:@selector(getData:)]) {

        //判断是不是，要展示数据
        BOOL a  = [self.delegate getData:self.receivedData];
        if(a == true){

            [self openfile:[self.readWriteData textPathFileName:self.filename]];
        }
    }

}

/**
 QuickLookVC  查看doc文件
 */
-(void)openfile:(NSString *)filePath {

    QuickLookVC *qu = [[QuickLookVC alloc] initWithNibName:@"QuickLookVC" bundle:nil];

    qu.path = filePath;
    self.vc.navigationController.navigationBarHidden = NO;
    [self.vc.navigationController pushViewController:qu animated:YES];
}


@end
