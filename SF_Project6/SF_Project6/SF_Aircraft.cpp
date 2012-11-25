//
//  SF_Aircraft.cpp
//  SF_Project6
//
//  Created by JungHo Kim on 12. 10. 25..
//  Copyright (c) 2012년 frf1226@nate.com. All rights reserved.
//

#include <iostream>
#include "SF_Aircraft.h"

void SF_Aircraft::Init_Aircraft(double x, double y){
    SF_Object::Init_Object(x, y);
    SF_Aircraft::velocity.x=0;
    SF_Aircraft::velocity.y=0;
    SF_Aircraft::HP=100;
    Angle=0;
}

void SF_Aircraft::Add_velocity(double x, double y){
    velocity.x+=x*0.3;
    velocity.y+=y;
}

void SF_Aircraft::Aircraft_Move(cocos2d::CCSize winSize){
    SF_vector temp_position;
    
    temp_position=SF_Object::Get_position();
    //속도를 반영한뒤 포지션을 조정
    temp_position.x+=velocity.x;
    temp_position.y+=velocity.y;
    
    //화면 밖으로 안나가게 고정 벽에 닿을 경우 속도 반전
    if(temp_position.x<50){
        temp_position.x=50;
        Set_velocity(-velocity.x*ELASTICITY, velocity.y);
        //Set_velocity(0, velocity.y);
    }
    if(temp_position.y<86*2){
        temp_position.y=86*2;
        Set_velocity(velocity.x,-velocity.y*ELASTICITY);
    }
    if(temp_position.x > (winSize.width*2-50)){
        temp_position.x=winSize.width*2-50;
        Set_velocity(-velocity.x*ELASTICITY, velocity.y);
    }
    if(temp_position.y > (winSize.height-50)){
        temp_position.y=winSize.height-50;
        Set_velocity(velocity.x,-velocity.y*ELASTICITY);
    }
    
    SF_Object::Set_Position(temp_position.x, temp_position.y);
}

void SF_Aircraft::Set_velocity(double x, double y){
    velocity.x=x;
    velocity.y=y;
}

void SF_Aircraft::Add_angle(double x){
    Angle+=x/(double)40;
    if(Angle>2*PI){
        Angle=0;
    }
    if(Angle<0){
        Angle=2*PI;
    }
}

double SF_Aircraft::Get_angle(){
    return Angle;
}

void SF_Aircraft::Set_angle(double y){
    Angle=y;
}

int SF_Aircraft::Get_HP(){
    return HP;
}