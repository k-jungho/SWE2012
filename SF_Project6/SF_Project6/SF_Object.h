//
//  SF_Object.h
//  SF_Project6
//
//  Created by JungHo Kim on 12. 10. 25..
//  Copyright (c) 2012년 frf1226@nate.com. All rights reserved.
//

#ifndef SF_Project6_SF_Object_h
#define SF_Project6_SF_Object_h
#include "cocos2d.h"

#define FPS 60

typedef struct SF_vector{
    double x;
    double y;
    SF_vector() {}
    SF_vector(double _x, double _y) : x(_x), y(_y) {}
    
}SF_vector;

class SF_Object{
    
private:
    SF_vector position;
public:
    void Init_Object(double x, double y);
    SF_vector Get_position();
    void Set_Position(double x, double y);
};

#endif
