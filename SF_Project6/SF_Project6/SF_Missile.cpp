//
//  SF_Missile.cpp
//  SF_Project6
//
//  Created by JungHo Kim on 12. 10. 25..
//  Copyright (c) 2012년 frf1226@nate.com. All rights reserved.
//

#include <iostream>
#include "SF_Missile.h"

void SF_Missile::Init_Missile(SF_vector Shoot_pos, SF_vector Shoot_angle, int power){
    SF_Object::Init_Object(Shoot_pos.x, Shoot_pos.y);
    SF_Missile::velocity.x=Shoot_angle.x;
    SF_Missile::velocity.y=Shoot_angle.y;
    SF_Missile::power=power;
}

void SF_Missile::Missile_Move(cocos2d::CCSize winSize){
    SF_vector temp;
    temp=SF_Object::Get_position();
    velocity.y+=-0.5;
    
    temp.x+=velocity.x;
    temp.y+=velocity.y;
    //if(winSize.width*2>temp.x){
        SF_Object::Set_Position(temp.x, temp.y);
    //}
}

void SF_Missile::Set_Missile_velocity(double velocity){
    SF_Missile::velocity.x=velocity;
}

int SF_Missile::Get_Missile_power(){
    return this->power;
}

bool SF_Missile::Check_EndMissile(cocos2d::CCSize winSize){
    SF_vector present_position;
    present_position=SF_Object::Get_position();
    
    if(present_position.x > (winSize.width*2-20))
        return true;
    
    if(present_position.y < 86*1.5)
        return true;
    
    if(present_position.x < 0 + 10)
        return true;
    
    return false;
}