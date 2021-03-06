//
//  ViewController.m
//  Do_Test
//
//  Created by linliyuan on 15/4/27.
//  Copyright (c) 2015年 DoExt. All rights reserved.
//

#import "ViewController.h"
#import "doPage.h"
#import "doService.h"
#import "do_ListData_MM.h"
@interface ViewController ()
{
@private
    NSString *Type;
    doModule* model;
}
@end
@implementation CallBackEvnet

-(void)eventCallBack:(NSString *)_data
{
    NSLog(@"异步方法回调数据:%@",_data);
}

@end
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self InitInstance];
    [self ConfigUI];
    // Do any additional setup after loading the view, typically from a nib.
}
- (void) InitInstance
{
    NSString *testPath = [[NSBundle mainBundle] pathForResource:@"do_Test" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:testPath];
    NSMutableDictionary *_testDics = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    Type = [_testDics valueForKey:@"Type"];
    //在下面构造model
    model = [[do_ListData_MM alloc]init];
    
    //如果是UI类型，还需要构造view
    //UIView* view = [[xxxxView alloc]init];
    
}
- (void)ConfigUI {
    CGFloat w = self.view.frame.size.width;
    CGFloat h = self.view.frame.size.height;
    //在对应的测试按钮添加自己的测试代码, 如果6个测试按钮不够，可以自己添加
    
    if([Type isEqualToString:@"UI"]){
        //和SM，MM不一样，UI类型还得添加自己的View，所以测试按钮都在底部
        CGFloat height = h/6;
        CGFloat width = (w - 35)/6;
        for(int i = 0;i<6;i++){
            UIButton *test = [UIButton buttonWithType:UIButtonTypeCustom];
            test.frame = CGRectMake(5*(i+1)+width*i, h-h/6, width, height);
            NSString* title = [NSString stringWithFormat:@"Test%d",i ];
            [test setTitle:title forState:UIControlStateNormal];
            SEL customSelector = NSSelectorFromString([NSString stringWithFormat:@"test%d:",i]);
            [test addTarget:self action:customSelector forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:test];
        }
        //addsubview 自定义的UI
        
    }else{
        CGFloat height = (h-140)/6;
        CGFloat width = w - 60;
        for(int i = 0;i<6;i++){
            UIButton *test = [UIButton buttonWithType:UIButtonTypeCustom];
            test.frame = CGRectMake(30, 20*(i+1)+height*i, width, height);
            NSString* title = [NSString stringWithFormat:@"Test%d",i ];
            [test setTitle:title forState:UIControlStateNormal];
            SEL customSelector = NSSelectorFromString([NSString stringWithFormat:@"test%d:",i]);
            [test addTarget:self action:customSelector forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:test];
        }
    }
}

- (void)test0:(UIButton *)sender
{
    //执行同步方法
    NSMutableDictionary* node = [[NSMutableDictionary alloc]init];
    NSArray* data = [[NSArray alloc]initWithObjects:@"test1",@"test2", @"test3",nil];
    [node setObject:data forKey:@"data"];
    [node setObject:[NSNumber numberWithInt:2] forKey:@"index"];
    [[doService Instance] SyncMethod:model:@"addData" :node];
    NSLog(@"data:%@",[((id<doIListData>)model) Serialize]);
}
- (void)test1:(UIButton *)sender
{
    //执行同步方法
    NSMutableDictionary* node = [[NSMutableDictionary alloc]init];
    NSArray* indexs = [[NSArray alloc]initWithObjects:@"1",@"-3", @"7",nil];
    [node setObject:indexs forKey:@"indexs"];
    [[doService Instance] SyncMethod:model:@"getData" :node];
    
}
- (void)test2:(UIButton *)sender
{
    NSLog(@"请添加自己的测试代码");
    //执行异步方法
    NSMutableDictionary* node = [[NSMutableDictionary alloc]init];
    
    [node setObject:@"1" forKey:@"fromIndex"];
    [node setObject:@"111" forKey:@"toIndex"];
    [[doService Instance] SyncMethod:model:@"getRange" :node];
}
- (void)test3:(UIButton *)sender
{
    NSLog(@"请添加自己的测试代码");
}
- (void)test4:(UIButton *)sender
{
    NSLog(@"请添加自己的测试代码");
}
- (void)test5:(UIButton *)sender
{
    NSLog(@"请添加自己的测试代码");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
