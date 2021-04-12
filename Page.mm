#import "Page.h"
#import "Menu.h"

@implementation Page

@synthesize Items = _Items;
@synthesize PageNumber = _PageNumber;
@synthesize ParentPage = _ParentPage;

- (void) setItems:(NSMutableArray<id> *)pItems {
   _Items = pItems;
}

- (NSMutableArray<id> *) Items {
   return _Items;
}

- (void) setPageNumber:(int)pPageNumber {
   _PageNumber = pPageNumber;
}

- (int) PageNumber {
   return _PageNumber;
}

- (void) setParentPage:(int)pParentPage {
   _ParentPage = pParentPage;
}

- (int) ParentPage {
   return _ParentPage;
}

/*- (instancetype)init {
   _Items = [[NSMutableArray alloc] init];
   return self;
}*/

- (void)addItem:(id)item {
   [self.Items addObject:item];
}

- (id)initWithPageNumber:(int)pageNumber_ parentPage:(int)parentPage_{
   _Items = [[NSMutableArray alloc] init];
   _PageNumber = pageNumber_;
   _ParentPage = parentPage_;
   return self;
}

+ (Page *)pageWithNum:(int)pageNum menuRef:(id)menuRef_{
   Menu *menuRef = menuRef_;
   for (Page *currentPage in menuRef.Pages)
   {
      if(currentPage.PageNumber == pageNum)
      {
         return currentPage;
      }
   }
   return NULL;
}

@end