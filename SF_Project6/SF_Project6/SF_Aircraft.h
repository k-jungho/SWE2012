//
//  SF_Aircraft.h
//  SF_Project6
//
//  Created by JungHo Kim on 12. 10. 25..
//  Copyright (c) 2012년 frf1226@nate.com. All rights reserved.
//

#ifndef SF_Project6_SF_Aircraft_h
#define SF_Project6_SF_Aircraft_h

#include "SF_Object.h"

#define ELASTICITY 0.7
#define PI 3.141592

class SF_Aircraft : public SF_Object
{
private:
    SF_vector velocity;
    double Angle;
    
public:
    void Init_Aircraft(double x, double y);
    void Set_angle(double y);
    void Add_velocity(double x, double y);
    void Set_velocity(double x, double y);
    void Add_angle(double x);
    void Aircraft_Move(cocos2d::CCSize winSize);
    double Get_angle();
};

#endif
