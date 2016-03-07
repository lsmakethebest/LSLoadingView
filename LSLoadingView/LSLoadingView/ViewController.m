//
//  ViewController.m
//  LSLoadingView
//
//  Created by ls on 16/3/7.
//  Copyright © 2016年 song. All rights reserved.
//

#import "ViewController.h"
#import "LSLoadingView.h"
@interface ViewController ()

@property (nonatomic,weak) LSLoadingView * loadingView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    LSLoadingView *view=[[LSLoadingView alloc]initWithFrame:CGRectMake(150, 150, 100, 100) title:@"加载中..."];
    view.backgroundColor=[UIColor colorWithWhite:0.3 alpha:0.5];

    [self.view addSubview:view];
    self.loadingView=view;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
- (IBAction)start:(id)sender {
    [self.loadingView startAnimation];
}
- (IBAction)stop:(id)sender {
    [self.loadingView stopAnimation];
}

@end
