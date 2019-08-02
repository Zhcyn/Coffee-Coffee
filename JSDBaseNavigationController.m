#import "JSDBaseNavigationController.h"
#import <UINavigationController+FDFullscreenPopGesture.h>
@interface JSDBaseNavigationController ()
@end
@implementation JSDBaseNavigationController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:231/255.0 green:227/255.0 blue:227/255.0 alpha:1.0];
    self.fd_fullscreenPopGestureRecognizer.enabled = YES;
}
- (void)onTouchBack {
}
@end
