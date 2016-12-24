--created & coded by Lyris
--Clear Tyranno
function c101010098.initial_effect(c)
	--normal summon
	local ae1=Effect.CreateEffect(c)
	ae1:SetDescription(aux.Stringid(101010097,0))
	ae1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	ae1:SetType(EFFECT_TYPE_SINGLE)
	ae1:SetCode(EFFECT_SUMMON_PROC)
	ae1:SetCondition(c101010097.otcon)
	ae1:SetValue(SUMMON_TYPE_NORMAL)
	c:RegisterEffect(ae1)
	--pierce
	local ae2=Effect.CreateEffect(c)
	ae2:SetType(EFFECT_TYPE_SINGLE)
	ae2:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(ae2)
	--destroy
	local ae3=Effect.CreateEffect(c)
	ae3:SetCategory(CATEGORY_DESTROY)
	ae3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	ae3:SetCode(EVENT_BATTLE_START)
	ae3:SetCondition(c101010097.tpcon)
	ae3:SetTarget(c101010097.targ)
	ae3:SetOperation(c101010097.op)
	c:RegisterEffect(ae3)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	e1:SetCode(97811903)
	e1:SetCondition(c101010097.tpcon)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetTargetRange(0,1)
	e2:SetCondition(c101010097.ntpcon)
	c:RegisterEffect(e2)
	--cannot be material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UNRELEASABLE_SUM)
	e3:SetValue(1)
	e3:SetCondition(c101010097.ntpcon)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e5:SetValue(1)
	e5:SetCondition(c101010097.ntpcon)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e6)
	local e7=e5:Clone()
	e7:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e7)
end
function c101010097.tpcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(c:GetOwner())
end
function c101010097.ntpcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(1-c:GetOwner())
end
function c101010097.cfilter1(c)
	return Duel.IsExistingMatchingCard(c101010097.cfilter2,tp,0,LOCATION_MZONE,1,nil,c:GetOriginalAttribute())
end
function c101010097.cfilter2(c,att)
	return c:GetOriginalAttribute()~=att
end
function c101010097.otcon(e,c)
	if c==nil then return true end
	local g=Duel.GetMatchingGroup(c101010097.cfilter1,c:GetControler(),0,LOCATION_MZONE,nil)
	return c:GetLevel()>4 and g:GetCount()>1 and Duel.GetTributeCount(c)>0
end
function c101010097.targ(e,tp,eg,ep,ev,re,r,rp,chk)
	local d=Duel.GetAttackTarget()
	if chk ==0 then return Duel.GetAttacker()==e:GetHandler()
		and d~=nil and d:IsFaceup() and d:IsAttribute(ATTRIBUTE_WIND+ATTRIBUTE_WATER) and d:IsRelateToBattle() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,d,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,d:GetOriginalLevel()*200)
end
function c101010097.op(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	if d~=nil and d:IsRelateToBattle() and Duel.Destroy(d,REASON_EFFECT)~=0 and d:IsLocation(LOCATION_GRAVE) then
		 Duel.Damage(1-tp,d:GetLevel()*200,REASON_EFFECT)
	end
end