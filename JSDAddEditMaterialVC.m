#import "JSDAddEditMaterialVC.h"
#import "JSDSelectedNumberView.h"
@interface JSDAddEditMaterialVC ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *scrollerViewContentView;
@property (weak, nonatomic) IBOutlet MDCTextField *materialCNNameTextField;
@property (nonatomic, strong) MDCTextInputControllerUnderline* materialCNNameController;
@property (weak, nonatomic) IBOutlet MDCTextField *materialENNameTextField;
@property (nonatomic, strong) MDCTextInputControllerUnderline* materialENNameController;
@property (weak, nonatomic) IBOutlet UIView *materialParameterView;
@property (weak, nonatomic) IBOutlet MDCMultilineTextField *materialIntroTextField;
@property (nonatomic, strong) MDCTextInputControllerUnderline* materialIntroController;
@property (weak, nonatomic) IBOutlet JSDSelectedNumberView *bakeNumberView;
@property (weak, nonatomic) IBOutlet JSDSelectedNumberView *sourNumberView;
@property (weak, nonatomic) IBOutlet JSDSelectedNumberView *chunNumberView;
@end
@implementation JSDAddEditMaterialVC
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
    if (self.model.canEdit) {
        self.title = @"Edit beans";
    } else {
        self.title = @"Add beans";
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(onTouchSave:)];
}
- (void)setupView {
    self.view.backgroundColor = [UIColor jsd_mainGrayColor];
    self.scrollView.backgroundColor = [UIColor jsd_mainGrayColor];
    self.scrollerViewContentView.backgroundColor = [UIColor jsd_mainGrayColor];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTouchContentView:)];
    [self.scrollerViewContentView addGestureRecognizer:tap];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self materialCNNameController];
    [self materialENNameController];
    [self materialIntroController];
    self.materialParameterView.layer.cornerRadius = 5;
    self.materialParameterView.layer.masksToBounds = YES;
}
- (void)reloadView {
}
#pragma mark - 3.Request Data
- (void)setupData {
    self.materialCNNameTextField.text = self.model.materialName;
    self.materialENNameTextField.text = self.model.materialENName;
    self.materialIntroTextField.text = self.model.materialDetail;
    [self.bakeNumberView updateNumber:self.model.bakeNumber];
    [self.sourNumberView updateNumber:self.model.sourNumber];
    [self.chunNumberView updateNumber:self.model.chunNumber];
}
#pragma mark - 4.UITableViewDataSource and UITableViewDelegate
#pragma mark - 5.Event Response
- (void)onTouchSave:(id) sender {
    BOOL havamaterialName = JSDIsString(self.materialCNNameTextField.text);
    if (havamaterialName) {
        if (self.model.canEdit) {
            [self updateMaterial];
        } else {
            [self addMaterial];
        }
    } else {
        MDCSnackbarManager* snackManger = [MDCSnackbarManager defaultManager];
        MDCSnackbarMessage* message = [MDCSnackbarMessage messageWithText:@"Coffee name"];
        [snackManger showMessage:message];
    }
}
- (void)onTouchContentView:(id)sender {
    [self.view endEditing:YES];
}
#pragma mark - 6.Private Methods
- (void)setupNotification {
}
- (void)updateMaterial {
    self.model.materialName = self.materialCNNameTextField.text;
    self.model.materialENName = self.materialENNameTextField.text;
    self.model.materialDetail = self.materialIntroTextField.text;
    self.model.bakeNumber = self.bakeNumberView.currentNumber;
    self.model.sourNumber = self.sourNumberView.currentNumber;
    self.model.chunNumber = self.chunNumberView.currentNumber;
    JSDMaterialViewModel* viewModel = [[JSDMaterialViewModel alloc] init];
    [viewModel editDataMaterial:self.model];
    [self.navigationController popViewControllerAnimated:YES];
    MDCSnackbarManager* manager = [MDCSnackbarManager defaultManager];
    MDCSnackbarMessage* message = [MDCSnackbarMessage messageWithText: @"The bean variety has been edited successfully and can be viewed in the list."];
    [manager showMessage:message];
}
- (void)addMaterial {
    self.model.materialName = self.materialCNNameTextField.text;
    self.model.materialENName = self.materialENNameTextField.text;
    self.model.materialDetail = self.materialIntroTextField.text;
    self.model.bakeNumber = self.bakeNumberView.currentNumber;
    self.model.sourNumber = self.sourNumberView.currentNumber;
    self.model.chunNumber = self.chunNumberView.currentNumber;
    self.model.canEdit = YES;
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateString = [dateFormatter stringFromDate:currentDate];
    self.model.materialID = currentDateString;
    JSDMaterialViewModel* viewModel = [[JSDMaterialViewModel alloc] init];
    [viewModel addDateMaterial:self.model];
    [self.navigationController popViewControllerAnimated:YES];
    MDCSnackbarManager* manager = [MDCSnackbarManager defaultManager];
    MDCSnackbarMessage* message = [MDCSnackbarMessage messageWithText: @"The coffee variety has been added successfully and can be viewed in the list."];
    [manager showMessage:message];
}
#pragma mark - 7.GET & SET
- (MDCTextInputControllerUnderline *)materialCNNameController {
    if (!_materialCNNameController) {
        _materialCNNameController = [[MDCTextInputControllerUnderline alloc] initWithTextInput: self.materialCNNameTextField];
        _materialCNNameController.activeColor = [UIColor blueColor];
        _materialCNNameController.normalColor = ColorWithFROMRGB(0xdddddd, 1);
        _materialCNNameController.borderFillColor = [UIColor whiteColor];
        _materialCNNameController.placeholderText = @"Bean name (recommended up to 15 characters)";
        _materialCNNameController.characterCountMax = 15;
        _materialCNNameController.roundedCorners = UIRectCornerAllCorners;
    }
    return _materialCNNameController;
}
- (MDCTextInputControllerUnderline *)materialENNameController {
    if (!_materialENNameController) {
        _materialENNameController = [[MDCTextInputControllerUnderline alloc] initWithTextInput: self.materialENNameTextField];
        _materialENNameController.activeColor = [UIColor blueColor];
        _materialENNameController.normalColor = ColorWithFROMRGB(0xdddddd, 1);
        _materialENNameController.borderFillColor = [UIColor whiteColor];
        _materialENNameController.placeholderText = @"Alias (optional)";
        _materialENNameController.roundedCorners = UIRectCornerAllCorners;
    }
    return _materialENNameController;
}
- (MDCTextInputControllerUnderline *)materialIntroController {
    if (!_materialIntroController) {
        _materialIntroController = [[MDCTextInputControllerUnderline alloc] initWithTextInput: self.materialIntroTextField];
        _materialIntroController.activeColor = [UIColor blueColor];
        _materialIntroController.normalColor = ColorWithFROMRGB(0xdddddd, 1);
        _materialIntroController.borderFillColor = [UIColor whiteColor];
        _materialIntroController.placeholderText = @"Coffee Story (optional)";
        _materialIntroController.roundedCorners = UIRectCornerAllCorners;
    }
    return _materialIntroController;
}
- (JSDMaterialModel *)model {
    if (!_model) {
        _model = [[JSDMaterialModel alloc] init];
    }
    return _model;
}
@end
