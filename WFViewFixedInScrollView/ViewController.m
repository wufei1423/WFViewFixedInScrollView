//
//  ViewController.m
//  WFViewFixedInScrollView
//
//  Created by feiwu on 16/3/2.
//  Copyright © 2016年 zzu. All rights reserved.
//

#import "ViewController.h"
#import "UIView+WFViewFixedInScrollView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) UIView *redView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.scrollView.contentSize = CGSizeMake(1000, 1000);
    
    UIView *redView = [[UIView alloc] init];
    redView.backgroundColor = [UIColor redColor];
    [redView fixInScrollView:self.scrollView withFrame:CGRectMake(100, 100, 50, 50) atIndex:1];
    self.redView = redView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.redView removeFromScrollViewInFixPosition];
}

@end
