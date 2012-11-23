//
//  SF_Object.cpp
//  SF_Project6
//
//  Created by JungHo Kim on 12. 10. 25..
//  Copyright (c) 2012년 frf1226@nate.com. All rights reserved.
//

#include <iostream>
#include "SF_Object.h"

void SF_Object::Init_Object(double x, double y){
    SF_Object::position.x=x;
    SF_Object::position.y=y;
}

SF_vector SF_Object::Get_position(){
    SF_vector temp;
    temp.x=position.x;
    temp.y=position.y;
    
    return temp;
}

void SF_Object::Set_Position(double x, double y){
    SF_Object::position.x=x;
    SF_Object::position.y=y;
}