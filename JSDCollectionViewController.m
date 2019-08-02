#import "JSDCollectionViewController.h"
#import <UINavigationController+FDFullscreenPopGesture.h>
@interface JSDCollectionViewController ()
@end
@implementation JSDCollectionViewController
static NSString * const reuseIdentifier = @"Cell";
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    if (self.navigationController.viewControllers.count > 1) {
        [self setupNavigation];
    }
}
- (void)setupNavigation {
    self.fd_interactivePopDisabled = NO;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(didTapBack:)];
    UIImage *backImage = [UIImage imageNamed:@"back"];
    backButton.image = backImage;
    backButton.tintColor = [UIColor jsd_colorWithHexString:@"#333333"];
    self.navigationItem.leftBarButtonItem = backButton;
}
- (void)didTapBack:(id)button {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [super numberOfSectionsInCollectionView:collectionView];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [super collectionView:collectionView numberOfItemsInSection:section];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [super collectionView:collectionView cellForItemAtIndexPath:indexPath];
}
#pragma mark <UICollectionViewDelegate>
@end
