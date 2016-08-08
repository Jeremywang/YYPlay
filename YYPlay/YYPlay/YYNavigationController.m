//
//  YYNavigationController.m
//  YYPlay
//
//  Created by jeremy on 8/3/16.
//  Copyright © 2016 MF. All rights reserved.
//

#import "YYNavigationController.h"

@interface YYNavigationController () {
    BOOL _setup;
}

@end

@implementation YYNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_setup) {
        return;
    }
    
    UINavigationBar *navigationBar = self.navigationBar;
    navigationBar.barTintColor = [UIColor jc_tomatoColor];
    navigationBar.tintColor = [UIColor whiteColor];
    navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:21.0f]};
    
    _setup = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
