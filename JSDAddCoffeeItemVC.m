#import "JSDAddCoffeeItemVC.h"
#import "JSDSelectedNumberView.h"
#import "JSDPhotoManage.h"
@interface JSDAddCoffeeItemVC ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *scrollerViewContentView;
@property (weak, nonatomic) IBOutlet UIImageView *coffeeImageView;
@property (weak, nonatomic) IBOutlet MDCButton *addCoffeeButton;
@property (weak, nonatomic) IBOutlet MDCTextField *coffeeCNNameTextField;
@property (nonatomic, strong) MDCTextInputControllerUnderline* coffeeCNNameController;
@property (weak, nonatomic) IBOutlet MDCTextField *coffeeENNameTextField;
@property (nonatomic, strong) MDCTextInputControllerUnderline* coffeeENNameController;
@property (weak, nonatomic) IBOutlet UIView *coffeeParameterView;
@property (weak, nonatomic) IBOutlet MDCMultilineTextField *coffeeIntroTextField;
@property (nonatomic, strong) MDCTextInputControllerUnderline* coffeeIntroController;
@property (weak, nonatomic) IBOutlet JSDSelectedNumberView *bakeNumberView;
@property (weak, nonatomic) IBOutlet JSDSelectedNumberView *sourNumberView;
@property (weak, nonatomic) IBOutlet JSDSelectedNumberView *chunNumberView;
@property (assign, nonatomic) BOOL havaPhoto;
@end
@implementation JSDAddCoffeeItemVC
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
    self.navigationItem.title = @"Add Caffee";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(onTouchSave:)];
}
- (void)setupView {
    self.view.backgroundColor = [UIColor jsd_mainGrayColor];
    self.scrollView.backgroundColor = [UIColor jsd_mainGrayColor];
    self.scrollerViewContentView.backgroundColor = [UIColor jsd_mainGrayColor];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTouchContentView:)];
    [self.scrollerViewContentView addGestureRecognizer:tap];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self coffeeCNNameController];
    [self coffeeENNameController];
    [self coffeeIntroController];
    self.coffeeImageView.backgroundColor = [UIColor jsd_grayColor];
    NSString* path = [JSDBundle pathForResource:@"selected_photo" ofType:@"png"];
    self.coffeeImageView.image = [UIImage imageNamed:path];
    self.coffeeImageView.contentMode = UIViewContentModeCenter;
    self.addCoffeeButton.backgroundColor = [UIColor clearColor];
    self.coffeeImageView.layer.cornerRadius = 5;
    self.coffeeImageView.layer.masksToBounds = YES;
    self.addCoffeeButton.layer.masksToBounds = YES;
    self.addCoffeeButton.layer.cornerRadius = 5;
    self.coffeeParameterView.layer.cornerRadius = 5;
    self.coffeeParameterView.layer.masksToBounds = YES;
}
- (void)reloadView {
}
#pragma mark - 3.Request Data
- (void)setupData {
    [self.addCoffeeButton addTarget:self action:@selector(onTouchAddCoffee:) forControlEvents:UIControlEventTouchUpInside];
    if (self.model.canEdit) {
        NSLog(@"包含了");
        if (JSDIsString(self.model.imageName)) {
            NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
            NSString* coffeeName = [NSString stringWithFormat:@"%@/%@.png", documentsDirectory, self.model.imageName];
            UIImage* image = [UIImage imageWithContentsOfFile:coffeeName];
            self.coffeeImageView.contentMode = UIViewContentModeScaleToFill;
            self.coffeeImageView.image = image;
        }
        self.coffeeCNNameTextField.text = self.model.coffeeCNName;
        self.coffeeENNameTextField.text = self.model.coffeeENName;
        [self.bakeNumberView updateNumber:self.model.expressoNumber];
        [self.sourNumberView updateNumber:self.model.milkNumber];
        [self.chunNumberView updateNumber:self.model.waterNumber];
        self.coffeeIntroTextField.text = self.model.coffeeDetail;
    }
}
#pragma mark - 4.UITableViewDataSource and UITableViewDelegate
#pragma mark - 5.Event Response
- (void)onTouchAddCoffee:(id) sender {
    [JSDPhotoManage presentWithViewController:self sourceType:JSDImagePickerSourceTypePhotoLibrary finishPicking:^(UIImage * _Nonnull image) {
        if (image) {
            self.havaPhoto = YES;
            self.coffeeImageView.contentMode = UIViewContentModeScaleToFill;
            self.coffeeImageView.image = image;
        } else {
        }
    }];
}
- (void)onTouchSave:(id) sender {
    BOOL havaImageView = NO;
    if (self.coffeeImageView.image) {
        havaImageView = YES;
    }
    BOOL havaCoffeeName = JSDIsString(self.coffeeCNNameTextField.text);
    if (havaImageView && havaCoffeeName) {
        if (self.model.canEdit) {
            [self updateCoffee];
        } else {
            [self addCoffee];
        }
    } else {
        MDCSnackbarManager* snackManger = [MDCSnackbarManager defaultManager];
        MDCSnackbarMessage* message = [MDCSnackbarMessage messageWithText:@"Please add a picture and coffee name"];
        [snackManger showMessage:message];
    }
}
- (void)onTouchContentView:(id)sender {
    [self.view endEditing:YES];
}
#pragma mark - 6.Private Methods
- (void)setupNotification {
}
- (void)addCoffee {
    JSDCoffeeViewModel* coffeeViewModel = [[JSDCoffeeViewModel alloc] init];
    if (self.havaPhoto) {
        self.coffeeImageView.animationRepeatCount = coffeeViewModel.listArray.count;
        NSString* coffeeFileName = self.coffeeCNNameTextField.text;
        [JSDPhotoManage savaImageView:self.coffeeImageView fileName: coffeeFileName];
        NSString* coffeeName = [NSString stringWithFormat:@"%@%@", kJSDPhotoImageFiles, coffeeFileName];
        self.model.imageName = coffeeName;
    }
    self.model.coffeeCNName = self.coffeeCNNameTextField.text;
    self.model.coffeeENName = self.coffeeENNameTextField.text;
    self.model.coffeeDetail = self.coffeeIntroTextField.text;
    self.model.expressoNumber = self.bakeNumberView.currentNumber;
    self.model.milkNumber = self.sourNumberView.currentNumber;
    self.model.waterNumber = self.chunNumberView.currentNumber;
    self.model.canEdit = YES;
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateString = [dateFormatter stringFromDate:currentDate];
    self.model.coffeeID = currentDateString;
    [coffeeViewModel addDateCoffee: self.model];
    [self.navigationController popViewControllerAnimated:YES];
    MDCSnackbarManager* manager = [MDCSnackbarManager defaultManager];
    MDCSnackbarMessage* message = [MDCSnackbarMessage messageWithText: @"The coffee variety has been added successfully and can be viewed in the list."];
    [manager showMessage:message];
}
- (void)updateCoffee {
    JSDCoffeeViewModel* coffeeViewModel = [[JSDCoffeeViewModel alloc] init];
    if (self.havaPhoto) {
        self.coffeeImageView.animationRepeatCount = coffeeViewModel.listArray.count;
        NSString* coffeeFileName = self.coffeeCNNameTextField.text;
        [JSDPhotoManage savaImageView:self.coffeeImageView fileName: coffeeFileName];
        NSString* coffeeName = [NSString stringWithFormat:@"%@%@", kJSDPhotoImageFiles, coffeeFileName];
        self.model.imageName = coffeeName;
    }
    self.model.coffeeCNName = self.coffeeCNNameTextField.text;
    self.model.coffeeENName = self.coffeeENNameTextField.text;
    self.model.coffeeDetail = self.coffeeIntroTextField.text;
    self.model.expressoNumber = self.bakeNumberView.currentNumber;
    self.model.milkNumber = self.sourNumberView.currentNumber;
    self.model.waterNumber = self.chunNumberView.currentNumber;
    self.model.canEdit = YES;
    [coffeeViewModel editDataCoffee:self.model];
    [self.navigationController popViewControllerAnimated:YES];
    MDCSnackbarManager* manager = [MDCSnackbarManager defaultManager];
    MDCSnackbarMessage* message = [MDCSnackbarMessage messageWithText: @"The coffee variety has been added successfully and can be viewed in the list."];
    [manager showMessage:message];
}
#pragma mark - 7.GET & SET
- (MDCTextInputControllerUnderline *)coffeeCNNameController {
    if (!_coffeeCNNameController) {
        _coffeeCNNameController = [[MDCTextInputControllerUnderline alloc] initWithTextInput: self.coffeeCNNameTextField];
        _coffeeCNNameController.activeColor = [UIColor blueColor];
        _coffeeCNNameController.normalColor = ColorWithFROMRGB(0xdddddd, 1);
        _coffeeCNNameController.borderFillColor = [UIColor whiteColor];
        _coffeeCNNameController.placeholderText = @"Coffee name (recommended up to 15 characters)";
        _coffeeCNNameController.characterCountMax = 15;
        _coffeeCNNameController.roundedCorners = UIRectCornerAllCorners;
    }
    return _coffeeCNNameController;
}
- (MDCTextInputControllerUnderline *)coffeeENNameController {
    if (!_coffeeENNameController) {
        _coffeeENNameController = [[MDCTextInputControllerUnderline alloc] initWithTextInput: self.coffeeENNameTextField];
        _coffeeENNameController.activeColor = [UIColor blueColor];
        _coffeeENNameController.normalColor = ColorWithFROMRGB(0xdddddd, 1);
        _coffeeENNameController.borderFillColor = [UIColor whiteColor];
        _coffeeENNameController.placeholderText = @"Alias (optional)";
        _coffeeENNameController.roundedCorners = UIRectCornerAllCorners;
    }
    return _coffeeENNameController;
}
- (MDCTextInputControllerUnderline *)coffeeIntroController {
    if (!_coffeeIntroController) {
        _coffeeIntroController = [[MDCTextInputControllerUnderline alloc] initWithTextInput: self.coffeeIntroTextField];
        _coffeeIntroController.activeColor = [UIColor blueColor];
        _coffeeIntroController.normalColor = ColorWithFROMRGB(0xdddddd, 1);
        _coffeeIntroController.borderFillColor = [UIColor whiteColor];
        _coffeeIntroController.placeholderText = @"Coffee Introduction (optional)";
        _coffeeIntroController.roundedCorners = UIRectCornerAllCorners;
    }
    return _coffeeIntroController;
}
- (JSDCoffeeModel *)model {
    if (!_model) {
        _model = [[JSDCoffeeModel alloc] init];
    }
    return _model;
}
@end
