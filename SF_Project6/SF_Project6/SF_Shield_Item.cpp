//
//  SF_Shield_Item.cpp
//  SF_Project6
//
//  Created by JungHo Kim on 12. 10. 29..
//  Copyright (c) 2012년 frf1226@nate.com. All rights reserved.
//

#include <iostream>
#include "SF_Shield_Item.h"

int SF_Shield_Item::Random_Heal(){
    int temp;
    temp=rand();
    temp=20+temp%20;
    
    return temp;
}