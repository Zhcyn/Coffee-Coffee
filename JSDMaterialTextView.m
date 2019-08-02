#import "JSDMaterialTextView.h"
#import "JSDPublic.h"
@interface JSDMaterialTextView ()
@property (weak, nonatomic) IBOutlet UILabel *coffeeNameCNLabel; 
@property (weak, nonatomic) IBOutlet UILabel *coffeeNameENLabel;
@property (weak, nonatomic) IBOutlet UILabel *bakeCNLabel;
@property (weak, nonatomic) IBOutlet UILabel *backENLabel;
@property (weak, nonatomic) IBOutlet UILabel *sourCNLabel;
@property (weak, nonatomic) IBOutlet UILabel *sourENLabel;
@property (weak, nonatomic) IBOutlet UILabel *chunCNLabel;
@property (weak, nonatomic) IBOutlet UILabel *chunENLabel;
@property (weak, nonatomic) IBOutlet JSDShowNumberView *bakeNumberView; 
@property (weak, nonatomic) IBOutlet JSDShowNumberView *sourNumberView; 
@property (weak, nonatomic) IBOutlet JSDShowNumberView *chunNumberView; 
@end
@implementation JSDMaterialTextView
- (void)awakeFromNib {
    [super awakeFromNib];
    self.coffeeNameCNLabel.font = [UIFont jsd_fontSize:24];
    self.coffeeNameCNLabel.textColor = [UIColor jsd_mainTextColor];
    self.coffeeNameENLabel.font = [UIFont jsd_fontSize:14];
    self.coffeeNameENLabel.textColor = [UIColor jsd_detailTextColor];
    self.bakeCNLabel.font = [UIFont jsd_fontSize:14];
    self.bakeCNLabel.textColor = [UIColor jsd_mainTextColor];
    self.backENLabel.font = [UIFont jsd_fontSize:14];
    self.backENLabel.textColor = [UIColor jsd_detailTextColor];
    self.sourCNLabel.font = [UIFont jsd_fontSize:14];
    self.sourCNLabel.textColor = [UIColor jsd_mainTextColor];
    self.sourENLabel.font = [UIFont jsd_fontSize:14];
    self.sourENLabel.textColor = [UIColor jsd_detailTextColor];
    self.chunCNLabel.font = [UIFont jsd_fontSize:14];
    self.chunCNLabel.textColor = [UIColor jsd_mainTextColor];
    self.chunENLabel.font = [UIFont jsd_fontSize:14];
    self.chunENLabel.textColor = [UIColor jsd_detailTextColor];
}
- (void)setModel:(JSDMaterialModel *)model {
    _model = model;
    self.coffeeNameCNLabel.text = model.materialName;
    self.coffeeNameENLabel.text = model.materialENName;
    [self.bakeNumberView updateNumber:model.bakeNumber];
    [self.sourNumberView updateNumber:model.sourNumber];
    [self.chunNumberView updateNumber:model.chunNumber];
}
- (void)updateViewWithModel:(JSDMaterialModel *)model {
    [self setModel:model];
}
@end
