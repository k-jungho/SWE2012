//
//  SF_Missile.h
//  SF_Project6
//
//  Created by JungHo Kim on 12. 10. 25..
//  Copyright (c) 2012년 frf1226@nate.com. All rights reserved.
//

#ifndef SF_Project6_SF_Missile_h
#define SF_Project6_SF_Missile_h

#include "SF_Object.h"

class SF_Missile : public SF_Object
{
    private:
    SF_vector velocity;
    int power;                  //미사일 종류
public:
    void Init_Missile(SF_vector Shoot_pos, SF_vector Shoot_angle, int power);
    void Set_Missile_velocity(double velocity);
    int Get_Missile_power();
    void Missile_Move(cocos2d::CCSize winSize);
    bool Check_EndMissile(cocos2d::CCSize winSize);
};

#endif
