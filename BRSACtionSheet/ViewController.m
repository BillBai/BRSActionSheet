//
//  ViewController.m
//  BRSACtionSheet
//
//  Created by Bill Bai on 2017/3/24.
//  Copyright © 2017年 Bill Bai. All rights reserved.
//

#import "ViewController.h"
#import "BRSActionSheet.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated
{
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)buttonTapped:(id)sender {
    
    BRSActionSheet *actionSheet = [[BRSActionSheet alloc] init];
    [actionSheet show];
}


@end
