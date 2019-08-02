#import "JSDMyCenterVC.h"
#import "JSDMyCenterViewModel.h"
#import "JSDCollectionViewCell.h"
#import "JSDCoffeeHistoryVC.h"
@interface JSDMyCenterVC ()
@property (strong, nonatomic) JSDMyCenterViewModel *viewModel;
@end
@implementation JSDMyCenterVC
static NSString * const reuseIdentifier = @"Cell";
#pragma mark - 1.View Controller Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavBar];
    [self setupView];
    [self setupData];
    [self setupNotification];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - 2.SettingView and Style
- (void)setupNavBar {
    self.navigationItem.title = @"Mine";
}
- (void)setupView {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"JSDCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.backgroundColor = [UIColor jsd_mainGrayColor];
}
- (void)reloadView {
}
#pragma mark - 3.Request Data
- (void)setupData {
}
#pragma mark - 4.UITableViewDataSource and UITableViewDelegate
#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.listArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JSDCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    JSDMyCenterModel* model = self.viewModel.listArray[indexPath.item];
    cell.model = model;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [super collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    JSDMyCenterModel* model = self.viewModel.listArray[indexPath.item];
    if (model.route) {
        JSDCoffeeHistoryVC* historyVC = [NSClassFromString(model.route) new];
        if ([historyVC isKindOfClass:[JSDCoffeeHistoryVC class]]) {
            historyVC.titleString = model.title;
            historyVC.subTitleString = model.subTitle;
            [self.navigationController pushViewController:historyVC animated:YES];
        } else {
            [self.navigationController pushViewController:historyVC animated:YES];
        }
    }
}
#pragma mark <UICollectionViewLayoutDelegate>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((ScreenWidth - 20), 60);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(21, 10, 20, 10);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 20;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 20;
}
#pragma mark <UICollectionViewDelegate>
#pragma mark - 5.Event Response
#pragma mark - 6.Private Methods
- (void)setupNotification {
}
#pragma mark - 7.GET & SET
- (JSDMyCenterViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[JSDMyCenterViewModel alloc] init];
    }
    return _viewModel;
}
@end
