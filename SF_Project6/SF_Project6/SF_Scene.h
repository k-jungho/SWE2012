#ifndef SF_Project6_SF_Scene_h
#define SF_Project6_SF_Scene_h
#include "cocos2d.h"
#include "SF_Aircraft.h"
#include "SF_Missile.h"



#define MAX_SHOOT_POWER 40

typedef struct Missile_struct{
    cocos2d::CCSprite *Missile;                                        //이미지
    SF_Missile Missile_class;                                          //미사일 클래
    bool enable=false;
}Missile_struct;

class SF_Scene: public cocos2d::CCLayer
{
public:
	// Here's a difference. Method 'init' in cocos2d-x returns bool, instead of returning 'id' in cocos2d-iphone
	virtual bool init();  
    
	// there's no 'id' in cpp, so we recommand to return the exactly class pointer
	static cocos2d::CCScene* scene();
	
	// a selector callback
	virtual void menuShootCallback(CCObject* pSender);
    virtual void select1(CCObject* pSender);
    virtual void select2(CCObject* pSender);
    
    cocos2d::CCSprite* wait_backgroud;
    cocos2d::CCMenu* pMenu1;
    cocos2d::CCMenu* pMenu2;
    
	// implement the "static node()" method manually
	LAYER_NODE_FUNC(SF_Scene);
    
    void frame(float dt);
    cocos2d::CCSprite* pMiniMap;
    
    cocos2d::CCSprite* pFighter;
    cocos2d::CCSprite* pFighter_HPbar;
    SF_Aircraft Fighter;
    cocos2d::CCSprite* pEnemy;
    cocos2d::CCSprite* pEnemy_HPbar;
    SF_Aircraft Enemy;
    
    cocos2d::CCLabelTTF *pLabel;
    cocos2d::CCLabelTTF *pTimer;
    cocos2d::CCSize winSize;
    cocos2d::CCSprite* pArrow;
    cocos2d::CCSprite* pPowergauge;
    cocos2d::CCSprite* pCheckbar;
    cocos2d::CCSprite* pGreendot;
    cocos2d::CCSprite* pReddot;
    
    int player_num;
    int present_turn;
    int Layer_operator;
    int Missile_count,Missile_base;
    Missile_struct N_Missile[255];                                      //대기중인 노드
    
    virtual void didAccelerate(cocos2d::CCAcceleration* pAccelerationValue);
    void setting_scene();
    
    //파워게이지
    bool Powerbar_Direction;
    void Move_Powerbar();
    double Get_Powerposition();//파워를 계산해줌
    //미니맵
    void MiniMap_dot();         //미니맵의 포인트를 조정해줌
    //프레임수를 카운팅함
    float count_frame;
    //체력바
    void Draw_HPbar();
    
private:
    float prev_elapsedTime;
};

#endif
