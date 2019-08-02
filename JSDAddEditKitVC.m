#import "JSDAddEditKitVC.h"
@interface JSDAddEditKitVC ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *scrollerViewContentView;
@property (weak, nonatomic) IBOutlet UIImageView *coffeeImageView;
@property (weak, nonatomic) IBOutlet MDCButton *addCoffeeButton;
@property (weak, nonatomic) IBOutlet MDCTextField *kitCNNameTextField;
@property (nonatomic, strong) MDCTextInputControllerUnderline* kitCNNameController;
@property (weak, nonatomic) IBOutlet MDCTextField *kitENNameTextField;
@property (nonatomic, strong) MDCTextInputControllerUnderline* kitENNameController;
@property (weak, nonatomic) IBOutlet MDCMultilineTextField *kitIntroTextField;
@property (nonatomic, strong) MDCTextInputControllerUnderline* kitIntroController;
@property (weak, nonatomic) IBOutlet MDCMultilineTextField *kitStepTextField;
@property (nonatomic, strong) MDCTextInputControllerUnderline* kitStepController;
@property (nonatomic, assign) BOOL havaImage;
@end
@implementation JSDAddEditKitVC
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
        self.title = @"Editing Apparatus";
    } else {
        self.title = @"Add Apparatus";
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
    [self kitCNNameController];
    [self kitENNameController];
    [self kitIntroController];
    [self kitStepController];
    self.coffeeImageView.backgroundColor = [UIColor jsd_grayColor];
    NSString* path = [JSDBundle pathForResource:@"selected_photo" ofType:@"png"];
    self.coffeeImageView.image = [UIImage imageNamed:path];
    self.coffeeImageView.contentMode = UIViewContentModeCenter;
    self.addCoffeeButton.backgroundColor = [UIColor clearColor];
    self.coffeeImageView.layer.cornerRadius = 5;
    self.coffeeImageView.layer.masksToBounds = YES;
    self.addCoffeeButton.layer.masksToBounds = YES;
    self.addCoffeeButton.layer.cornerRadius = 5;
    [self.addCoffeeButton addTarget:self action:@selector(onTouchAddCoffee:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)reloadView {
}
#pragma mark - 3.Request Data
- (void)setupData {
    if (self.model.canEdit) {
        if (JSDIsString(self.model.kitImageName)) {
            NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
            NSString* coffeeName = [NSString stringWithFormat:@"%@/%@.png", documentsDirectory, self.model.kitImageName];
            UIImage* image = [UIImage imageWithContentsOfFile:coffeeName];
            self.coffeeImageView.contentMode = UIViewContentModeScaleToFill;
            self.coffeeImageView.image = image;
        }
    }
    self.kitCNNameTextField.text = self.model.kitCNName;
    self.kitENNameTextField.text = self.model.kitENName;
    self.kitIntroTextField.text = self.model.kitDetail;
    self.kitStepTextField.text = self.model.step;
}
#pragma mark - 4.UITableViewDataSource and UITableViewDelegate
#pragma mark - 5.Event Response
- (void)onTouchSave:(id) sender {
    BOOL havakitName = JSDIsString(self.kitCNNameTextField.text);
    BOOL havaImageView = NO;
    if (self.coffeeImageView.image) {
        havaImageView = YES;
    }
    if (havakitName && havaImageView) {
        if (self.model.canEdit) {
            [self updatekit];
        } else {
            [self addkit];
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
- (void)onTouchAddCoffee:(id) sender {
    [JSDPhotoManage presentWithViewController:self sourceType:JSDImagePickerSourceTypePhotoLibrary finishPicking:^(UIImage * _Nonnull image) {
        if (image) {
            self.havaImage = YES;
            self.coffeeImageView.contentMode = UIViewContentModeScaleToFill;
            self.coffeeImageView.image = image;
        } else {
        }
    }];
}
#pragma mark - 6.Private Methods
- (void)setupNotification {
}
- (void)updatekit {
    JSDKitTypeViewModel* viewModel = [[JSDKitTypeViewModel alloc] init];
    if (self.havaImage) {
        self.coffeeImageView.animationRepeatCount = viewModel.listArray.count;
        NSString* kitFileName = self.kitCNNameTextField.text;
        [JSDPhotoManage savaKitImageView:self.coffeeImageView fileName:kitFileName];
        NSString* kitName = [NSString stringWithFormat:@"%@%@", kJSDKitImageFiles, kitFileName];
        self.model.kitImageName = kitName;
    }
    self.model.kitCNName = self.kitCNNameTextField.text;
    self.model.kitENName = self.kitENNameTextField.text;
    self.model.kitDetail = self.kitIntroTextField.text;
    self.model.step = self.kitStepTextField.text;
    [viewModel editDataKit:self.model];
    [self.navigationController popViewControllerAnimated:YES];
    MDCSnackbarManager* manager = [MDCSnackbarManager defaultManager];
    MDCSnackbarMessage* message = [MDCSnackbarMessage messageWithText: @"The coffee appliance has been edited successfully and can be viewed in the list."];
    [manager showMessage:message];
}
- (void)addkit {
    JSDKitTypeViewModel* viewModel = [[JSDKitTypeViewModel alloc] init];
    if (self.havaImage) {
        self.coffeeImageView.animationRepeatCount = viewModel.listArray.count;
        NSString* kitFileName = self.kitCNNameTextField.text;
        [JSDPhotoManage savaKitImageView:self.coffeeImageView fileName:kitFileName];
        NSString* kitName = [NSString stringWithFormat:@"%@%@", kJSDKitImageFiles, kitFileName];
        self.model.kitImageName = kitName;
    }
    self.model.kitCNName = self.kitCNNameTextField.text;
    self.model.kitENName = self.kitENNameTextField.text;
    self.model.kitDetail = self.kitIntroTextField.text;
    self.model.step = self.kitStepTextField.text;
    self.model.canEdit = YES;
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateString = [dateFormatter stringFromDate:currentDate];
    self.model.kitID = currentDateString;
    [viewModel addDateKit:self.model];
    [self.navigationController popViewControllerAnimated:YES];
    MDCSnackbarManager* manager = [MDCSnackbarManager defaultManager];
    MDCSnackbarMessage* message = [MDCSnackbarMessage messageWithText: @"The coffee appliance has been edited successfully and can be viewed in the list."];
    [manager showMessage:message];
}
#pragma mark - 7.GET & SET
- (MDCTextInputControllerUnderline *)kitCNNameController {
    if (!_kitCNNameController) {
        _kitCNNameController = [[MDCTextInputControllerUnderline alloc] initWithTextInput: self.kitCNNameTextField];
        _kitCNNameController.activeColor = [UIColor blueColor];
        _kitCNNameController.normalColor = ColorWithFROMRGB(0xdddddd, 1);
        _kitCNNameController.borderFillColor = [UIColor whiteColor];
        _kitCNNameController.placeholderText = @"Appliance name (up to 15 characters recommended)";
        _kitCNNameController.characterCountMax = 15;
        _kitCNNameController.roundedCorners = UIRectCornerAllCorners;
    }
    return _kitCNNameController;
}
- (MDCTextInputControllerUnderline *)kitENNameController {
    if (!_kitENNameController) {
        _kitENNameController = [[MDCTextInputControllerUnderline alloc] initWithTextInput: self.kitENNameTextField];
        _kitENNameController.activeColor = [UIColor blueColor];
        _kitENNameController.normalColor = ColorWithFROMRGB(0xdddddd, 1);
        _kitENNameController.borderFillColor = [UIColor whiteColor];
        _kitENNameController.placeholderText = @"Alias (up to 15 characters recommended)";
        _kitENNameController.roundedCorners = UIRectCornerAllCorners;
    }
    return _kitENNameController;
}
- (MDCTextInputControllerUnderline *)kitIntroController {
    if (!_kitIntroController) {
        _kitIntroController = [[MDCTextInputControllerUnderline alloc] initWithTextInput: self.kitIntroTextField];
        _kitIntroController.activeColor = [UIColor blueColor];
        _kitIntroController.normalColor = ColorWithFROMRGB(0xdddddd, 1);
        _kitIntroController.borderFillColor = [UIColor whiteColor];
        _kitIntroController.placeholderText = @"Appliance Description (optional)";
        _kitIntroController.roundedCorners = UIRectCornerAllCorners;
    }
    return _kitIntroController;
}
- (MDCTextInputControllerUnderline *)kitStepController {
    if (!_kitStepController) {
        _kitStepController = [[MDCTextInputControllerUnderline alloc] initWithTextInput: self.kitStepTextField];
        _kitStepController.activeColor = [UIColor blueColor];
        _kitStepController.normalColor = ColorWithFROMRGB(0xdddddd, 1);
        _kitStepController.borderFillColor = [UIColor whiteColor];
        _kitStepController.placeholderText = @"Use step (optional)";
        _kitStepController.roundedCorners = UIRectCornerAllCorners;
    }
    return _kitStepController;
}
- (JSDKitTypeModel *)model {
    if (!_model) {
        _model = [[JSDKitTypeModel alloc] init];
    }
    return _model;
}
@end
