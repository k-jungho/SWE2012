//
//  SF_Item.h
//  SF_Project6
//
//  Created by JungHo Kim on 12. 10. 29..
//  Copyright (c) 2012년 frf1226@nate.com. All rights reserved.
//

#ifndef SF_Project6_SF_Item_h
#define SF_Project6_SF_Item_h

#include "SF_Object.h"
#include <time.h>

class SF_Item : public SF_Object
{
private:
    bool check;
    
public:
    void Init_Item();
};


#endif
