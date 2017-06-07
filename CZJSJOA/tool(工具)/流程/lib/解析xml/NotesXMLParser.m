//
//  NotesXMLParser.m
//  MyNotes
//  Created by 关东升 on 2015-3-18.
//  本书网站：http://www.51work6.com
//  智捷iOS课堂在线课堂：http://v.51work6.com
//  智捷iOS课堂新浪微博：http://weibo.com/u/3215753973
//  作者微博：http://weibo.com/516inc
//  QQ：1575716557 邮箱：jylong06@163.com
//  QQ交流群：239148636/274580109
//  
//

#import "NotesXMLParser.h"

@implementation NotesXMLParser


-(void)startData:(NSData *)data{
  //  NSString* path = [[NSBundle mainBundle] pathForResource:@"Notes" ofType:@"xml"];
    
  //  NSURL *url = [NSURL fileURLWithPath:path];
    //开始解析XML
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
   // NSXMLParser *parser = [[NSXMLParser alloc] initWithData:@"fdsfs"];
    parser.delegate = self;
    [parser parse];
    NSLog(@"解析完成...");
}

//文档开始的时候触发
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    _notes = [NSMutableArray new];
}

//文档出错的时候触发
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    NSLog(@"%@",parseError);
}

//遇到一个开始标签时候触发

/**
 <Notes>
 <Note id="1">
 <CDate>2012-12-21</CDate>
 <Content>早上8点钟到公司</Content>
 <UserID>tony</UserID>
 </Note>
 */
//elementName(节点名字，<Note id="1">)     attributeDict （节点里面的内容，id="1"）  attributeDict(节点里面的对象)
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict{

    NSLog(@"%@",elementName);
    _currentTagName = elementName;
    NSLog(@"%@",elementName);

        
        NSLog(@"%@",attributeDict);
        
//        NSString *_id = [attributeDict objectForKey:@"id"];
//        NSLog(@"%@",_id);
//        NSMutableDictionary *dict = [NSMutableDictionary new];
//        [dict setObject:_id forKey:@"id"];
//        [_notes addObject:dict];

   
}

//遇到字符串时候触发 elementName(里面的子节点) 如<CDate>2012-12-21</CDate>
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    //替换回车符和空格
	string =[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([string isEqualToString:@""]) {
        return;
    }
    NSMutableDictionary *dict = [_notes lastObject];
    
	if ([_currentTagName isEqualToString:@"data"] && dict) {
      //  [dict setObject:string forKey:@"CDate"];
	}
    
    if ([_currentTagName isEqualToString:@"Content"] && dict) {
        [dict setObject:string forKey:@"Content"];
	}
    
    if ([_currentTagName isEqualToString:@"UserID"] && dict) {
        [dict setObject:string forKey:@"UserID"];
	}
}

//遇到结束标签时候出发
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI
qualifiedName:(NSString *)qName{

    //elementName 节点名字
    self.currentTagName = nil;
}

//遇到文档结束时候触发
- (void)parserDidEndDocument:(NSXMLParser *)parser{

    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadViewNotification" object:self.notes userInfo:nil];
    self.notes = nil;
}



@end
