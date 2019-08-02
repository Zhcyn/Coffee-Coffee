#import "JSDCoffeeHistoryVC.h"
#import "JSDPublic.h"
@interface JSDCoffeeHistoryVC ()
@property (weak, nonatomic) IBOutlet UIImageView *logImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIView *scrollViewContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrolleViewContentViewHeight;
@end
@implementation JSDCoffeeHistoryVC
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
    self.title = @"Coffee science";
}
- (void)setupView {
    self.view.backgroundColor = [UIColor jsd_mainGrayColor];
    self.titleLabel.font = [UIFont jsd_fontSize: 18];
    self.titleLabel.textColor = [UIColor jsd_mainTextColor];
    self.scrollViewContentView.backgroundColor = [UIColor jsd_mainGrayColor];
    self.detailLabel.numberOfLines = 0;
}
- (void)reloadView {
}
#pragma mark - 3.Request Data
- (void)setupData {
    if (JSDIsString(self.logImageName)) {
        NSString* path = [JSDBundle pathForResource:self.logImageName ofType:@"png"];
        self.logImageView.image = [UIImage imageWithContentsOfFile:path];
    } else {
        self.logImageView.image = [UIImage imageNamed:@"coffee_tabbar_selected"];
    }
    self.titleLabel.text = self.titleString;
    NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:15];
    NSMutableAttributedString* detail;
    if (JSDIsString(self.subTitleString)) {
        detail = [[NSMutableAttributedString alloc] initWithString:self.subTitleString attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Helvetica Neue" size: 14.0],NSForegroundColorAttributeName: [UIColor colorWithRed:113/255.0 green:120/255.0 blue:130/255.0 alpha:1.0]}];
        [detail addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, [detail length])];
    } else {
    }
    self.detailLabel.attributedText = detail;
}
#pragma mark - 4.UITableViewDataSource and UITableViewDelegate
#pragma mark - 5.Event Response
#pragma mark - 6.Private Methods
- (void)setupNotification {
}
#pragma mark - 7.GET & SET
@end
