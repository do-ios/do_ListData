//
//  do_ListData_MM.m
//  DoExt_MM
//
//  Created by @userName on @time.
//  Copyright (c) 2015年 DoExt. All rights reserved.
//

#import "do_ListData_MM.h"

#import "doScriptEngineHelper.h"
#import "doIScriptEngine.h"
#import "doInvokeResult.h"
#import "doJsonHelper.h"
#import "doTextHelper.h"
#import "doServiceContainer.h"
#import "doILogEngine.h"

@implementation do_ListData_MM
{
@private
    NSMutableArray* array;
}
#pragma mark - doIListData
-(int) GetCount
{
    return (int)array.count;
}
-(id) GetData:(int) index
{
    return array[index];
}
-(void) SetData:(int) index :(id) data
{
    array[index] = data;
}
-(NSString*) Serialize
{
    return [doJsonHelper ExportToText:array:YES];
}
-(id) UnSerialize:(NSString*) str
{
    array = [doJsonHelper LoadDataFromText:str];
    return self;
}
#pragma mark - 注册属性（--属性定义--）
/*
 [self RegistProperty:[[doProperty alloc]init:@"属性名" :属性类型 :@"默认值" : BOOL:是否支持代码修改属性]];
 */
-(void)OnInit
{
    [super OnInit];
    if(array==nil)
        array = [[NSMutableArray alloc]init];
    //注册属性
}

//销毁所有的全局对象
-(void)Dispose
{
    [array removeAllObjects];
    //自定义的全局属性
}
#pragma mark -
#pragma mark - doIDataSource implements
-(id) GetJsonData;
{
    return array;
}

#pragma mark - 父类方法重载
-(void)LoadModelFromString:(NSString *)_moduleText
{
    id _rootJsonValue =[doJsonHelper LoadDataFromText : _moduleText];
    NSArray *nodeArray = [doJsonHelper GetArray:_rootJsonValue];
    [array addObjectsFromArray:nodeArray];
}

#pragma mark -
#pragma mark - 同步异步方法的实现

//同步
- (void)addData:(NSArray *)parms
{
    NSDictionary *_dictParas = [parms objectAtIndex:0];
    //自己的代码实现
    int temp = (int)array.count;
    NSArray* datas =[doJsonHelper GetOneArray:_dictParas :@"data"];
    int index = [doJsonHelper GetOneInteger:_dictParas :@"index" :temp];
    if(index>temp)
        index = temp;
    if(index<0)
        index = 0;
    
    for(id data in datas){
        if (data&&![data isKindOfClass:[NSNull class]]) {
            [array insertObject:data atIndex:index];
            index++;
        }
    }
}
- (void)addOne:(NSArray *)parms
{
    NSDictionary *_dictParas = [parms objectAtIndex:0];
    //自己的代码实现
    int temp = (int)array.count;
    id data =[doJsonHelper GetOneValue:_dictParas :@"data"];
    int index = [doJsonHelper GetOneInteger:_dictParas :@"index" :temp];
    if(index>temp)
        index = temp;
    if(index<0)
        index = 0;
    if (data&&![data isKindOfClass:[NSNull class]]) {
        [array insertObject:data atIndex:index];
    }
}
- (void)getCount:(NSArray *)parms
{
    doInvokeResult *_invokeResult = [parms objectAtIndex:2];
    [_invokeResult SetResultInteger:(int)array.count];
    //自己的代码实现
}
- (void)getOne:(NSArray *)parms
{
    NSDictionary *_dictParas = [parms objectAtIndex:0];
    //自己的代码实现
    int temp = (int)array.count-1;
    int index = [doJsonHelper GetOneInteger:_dictParas :@"index" : temp];
    id _jsonValue;
    if(array.count==0)
    {
        _jsonValue = [NSNull null];
    }
    else{
        if (index < 0)
        {
            _jsonValue = array.firstObject;
        }
        else if (index >=0 && index <=temp)
        {
            _jsonValue = array[index];
        }
        else
        {
            _jsonValue = array.lastObject;
        }
    }
    doInvokeResult *_invokeResult = [parms objectAtIndex:2];
    [_invokeResult SetResultValue:_jsonValue];
}
- (void)getData:(NSArray *)parms
{
    NSDictionary *_dictParas = [parms objectAtIndex:0];
    //自己的代码实现
    NSArray* indexs = [doJsonHelper GetOneArray:_dictParas :@"indexs"];
    NSMutableArray* result = [[NSMutableArray alloc]init];
    for(id index in indexs)
    {
        int _index;
        if([index isKindOfClass:[NSString class]])
            _index=[[doTextHelper Instance] StrToInt:index :-2];
        else if([index isKindOfClass:[NSNumber class]])
            _index = ((NSNumber*)index).intValue;
            int temp = (int)array.count-1;
        if(_index == -1)
        {
            [result addObject:array.lastObject];
            continue;
        }
        if(temp>=_index&&_index>=0){
            [result addObject:array[_index]];
        }else{
            [result addObject:[NSNull null]];
        }
    }
    doInvokeResult *_invokeResult = [parms objectAtIndex:2];
    [_invokeResult SetResultArray:result ];
}
- (void)getRange:(NSArray *)parms
{
    NSDictionary *_dictParas = [parms objectAtIndex:0];
    //自己的代码实现
    int temp = (int)array.count-1;
    int fromIndex = [doJsonHelper GetOneInteger:_dictParas :@"fromIndex" : 0];
    int toIndex = [doJsonHelper GetOneInteger:_dictParas :@"toIndex" : temp];
    if (fromIndex < 0) {
        fromIndex = 0;
    }
    if(toIndex>temp)toIndex = temp;
    if(toIndex<0)toIndex = 0;
    @try {
        if (fromIndex > temp) {
            [NSException raise:@"listData" format:@"fromIndex 参数值非法！"];
        }
        if (fromIndex > toIndex) {
            [NSException raise:@"listData" format:@"fromIndex 必须小于或等于 toIndex！"];
        }
    }
    @catch (NSException *exception) {
        [[doServiceContainer Instance].LogEngine WriteError:exception:exception.description];
        doInvokeResult* _result = [[doInvokeResult alloc]init];
        [_result SetException:exception];
        return;
    }

    NSMutableArray* result = [[NSMutableArray alloc]init];
    if (array.count>0) {
        for(int i =fromIndex ;i<=toIndex;i++)
        {
            [result addObject:array[i]];
        }
    }
    doInvokeResult *_invokeResult = [parms objectAtIndex:2];
    [_invokeResult SetResultArray:result ];
}

- (void)removeAll:(NSArray *)parms
{
    //自己的代码实现
    [array removeAllObjects];
}
- (void)removeOne:(NSArray *)parms
{
    NSDictionary *_dictParas = [parms objectAtIndex:0];
    //自己的代码实现
    int index = [doJsonHelper GetOneInteger:_dictParas :@"index" : 0];
    if (array.count>0) {
        [array removeObjectAtIndex:index];
    }
}
- (void)removeData:(NSArray *)parms
{
    NSDictionary *_dictParas = [parms objectAtIndex:0];
    //自己的代码实现
    NSArray* indexs = [doJsonHelper GetOneArray:_dictParas :@"indexs"];
    NSMutableIndexSet* result = [[NSMutableIndexSet alloc]init];
    for(id index in indexs)
    {
        int _index;
        if([index isKindOfClass:[NSString class]])
            _index=[[doTextHelper Instance] StrToInt:index :-1];
        else if([index isKindOfClass:[NSNumber class]])
            _index = ((NSNumber*)index).intValue;
        else continue;
        if(_index>=0 && _index<array.count)
           [result addIndex:_index];
    }
    if (array.count > 0) {
        [array removeObjectsAtIndexes:result];
    }
}
- (void)removeRange:(NSArray *)parms
{
    NSDictionary *_dictParas = [parms objectAtIndex:0];
    //自己的代码实现
    int temp = (int)array.count-1;
    int fromIndex = [doJsonHelper GetOneInteger:_dictParas :@"fromIndex" : 0];
    int toIndex = [doJsonHelper GetOneInteger:_dictParas :@"toIndex" : -1];
    @try {
        if (fromIndex > temp) {
            [NSException raise:@"listData" format:@"fromIndex 参数值非法！"];
        }
        if (fromIndex > toIndex) {
            [NSException raise:@"listData" format:@"fromIndex 必须小于或等于 toIndex！"];
        }
    }
    @catch (NSException *exception) {
        [[doServiceContainer Instance].LogEngine WriteError:exception:exception.description];
        doInvokeResult* _result = [[doInvokeResult alloc]init];
        [_result SetException:exception];
    }
    if(fromIndex<0) return;
    if(toIndex>temp || toIndex==-1) toIndex = (int)array.count-1;
    int length = (toIndex-fromIndex)+1;
    if(length<0||length>array.count)return;
    NSRange range = NSMakeRange(fromIndex, length);
    if (array.count>0) {
        [array removeObjectsInRange:range];
    }
}
- (void)updateOne:(NSArray *)parms
{
    NSDictionary *_dictParas = [parms objectAtIndex:0];
    //自己的代码实现
    int index = [doJsonHelper GetOneInteger:_dictParas :@"index" : -1];
    id _jsonValue = [doJsonHelper GetOneValue:_dictParas :@"data"];
    int temp = (int)array.count-1;
    if(index>=0&&index<=temp&&_jsonValue&&![_jsonValue isKindOfClass:[NSNull class]])
        array[index] = _jsonValue;
}
//异步

@end