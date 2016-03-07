//
//  LSLoadingView.h
//  LSLoadingView
//
//  Created by ls on 16/3/7.
//  Copyright © 2016年 song. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSLoadingView : UIView

-(instancetype)initWithFrame:(CGRect)frame title:(NSString *)title;
//开始动画
-(void)startAnimation;

//结束动画
-(void)stopAnimation;

@end
