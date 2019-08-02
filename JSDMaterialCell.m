#import "JSDMaterialCell.h"
#import "JSDPublic.h"
@interface JSDMaterialCell ()
@property (weak, nonatomic) IBOutlet UIImageView *materialImageView;
@property (weak, nonatomic) IBOutlet UIView *textContentView;
@property (weak, nonatomic) IBOutlet UILabel *meterialNameLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *coffeeStoryLabel;
@end
@implementation JSDMaterialCell
- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    self.textContentView.backgroundColor = [UIColor colorWithRed:243/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];
    self.meterialNameLabel.font = [UIFont jsd_fontSize:24];
    self.meterialNameLabel.textColor = [UIColor jsd_mainTextColor];
    self.coffeeStoryLabel.font = [UIFont jsd_fontSize:22];
    self.coffeeStoryLabel.textColor = [UIColor jsd_minorTextColor];
    self.lineView.backgroundColor = [UIColor colorWithRed:108/255.0 green:64/255.0 blue:34/255.0 alpha:1.0];
}
- (void)setModel:(JSDMaterialModel *)model {
    _model = model;
    if (JSDIsString(model.imageName)) {
        self.materialImageView.image = [UIImage imageNamed: model.imageName];
    }
    self.meterialNameLabel.text = model.materialName;
    self.coffeeStoryLabel.text = @"Coffee Story";
}
@end
