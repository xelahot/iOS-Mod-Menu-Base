#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"
#import "Page.h"

@interface Menu : UIView <UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray<Page *> *Pages;
@property (nonatomic, assign) int CurrentPage;
@property (nonatomic, strong) NSMutableDictionary *MenuItems;
@property (nonatomic) UIScrollView *ScrollViewRef;

- (void)addToggleItem:(NSString *)title_ 
		description:(NSString *)description_ isOn:(BOOL)isOn_;
- (void)addPageItem:(NSString *)title_ targetPage:(NSUInteger)targetPage_;
- (void)addSliderItem:(NSString *)title_ 
		description:(NSString *)description_ isOn:(BOOL)isOn_ isFloating:(BOOL)isFloating_ defaultValue:(float)defaultValue_ minValue:(float)minValue_ maxValue:(float)maxValue_;
- (BOOL)isItemOn:(NSString *)itemName;
- (float)getSliderValue:(NSString *)itemName;
- (NSString *)getTextfieldValue:(NSString *)itemName;
- (void)addPage:(Page *)page;
- (void)loadPage:(int)pageNumber;
- (void)backPage;
- (id)initMenu;
- (id)itemWithName:(NSString *)itemName;
- (void)setUserDefaultsAndDict;
- (UIButton *)getMenuButtRef ;
@end