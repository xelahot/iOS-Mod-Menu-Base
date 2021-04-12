#import "UIKit/UIKit.h"

@interface MenuItem : UIView

@property (nonatomic) NSString *Title;

@end

//Should add a reference to the parent UI element of this item.
//ex: A SlidderItem always starts with a UIButton*. That UIButton contains childs UI elements.
//I could add a reference to that parent UI element as a property.
//I wouldn't be able to read a slider UI value if I'm currently on a different page though because that UI element is not in memory anymore.
//I would need to either set the reference property to NULL when I change page or make sure not to rtry and read when it's not there.