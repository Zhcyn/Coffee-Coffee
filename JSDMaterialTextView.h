#import "JSDBaseView.h"
#import "JSDMaterialViewModel.h"
NS_ASSUME_NONNULL_BEGIN
@interface JSDMaterialTextView : JSDBaseView
@property (nonatomic, strong) JSDMaterialModel* model;
- (void)updateViewWithModel:(JSDMaterialModel *)model;
@end
NS_ASSUME_NONNULL_END
