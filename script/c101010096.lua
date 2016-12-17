--created & coded by Lyris
--Clear Protector
function c101010096.initial_effect(c)
	local ae1=Effect.CreateEffect(c)
	ae1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	ae1:SetCode(EVENT_SUMMON_SUCCESS)
	ae1:SetTarget(c101010096.target)
	ae1:SetOperation(c101010096.operation)
	c:RegisterEffect(ae1)
	local ae2=ae1:Clone()
	ae2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(ae2)
	local ae3=ae1:Clone()
	ae3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(ae)
	--Your opponent cannot attack with monsters of the declared Attribute.
	local ae4=Effect.CreateEffect(c)
	ae4:SetType(EFFECT_TYPE_FIELD)
	ae4:SetCode(EFFECT_CANNOT_ATTACK)
	ae4:SetRange(LOCATION_MZONE)
	ae4:SetTargetRange(0,LOCATION_MZONE)
	ae4:SetCondition(c101010096.tpcon)
	ae4:SetTarget(c101010096.block)
	c:RegisterEffect(ae4)
	--You cannot Special Summon monsters from the hand or Deck with the declared Attribute.
	local ae5=Effect.CreateEffect(c)
	ae5:SetType(EFFECT_TYPE_FIELD)
	ae5:SetRange(LOCATION_MZONE)
	ae5:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	ae5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	ae5:SetTargetRange(1,0)
	ae5:SetValue(c101010096.sumlimit)
	ae5:SetCondition(c101010096.ntpcon)
	c:RegisterEffect(ae5)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	e1:SetCode(97811903)
	e1:SetCondition(c101010096.tpcon)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetTargetRange(0,1)
	e2:SetCondition(c101010096.ntpcon)
	c:RegisterEffect(e2)
	--If this card is Summoned: Its owner declares 1 Attribute.
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e5:SetValue(1)
	e5:SetCondition(c101010096.ntpcon)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e6)
	local e7=e5:Clone()
	e7:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e7)
end
c101010096[0]=0
c101010096[1]=0
function c101010096.tpcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(c:GetOwner())
end
function c101010096.ntpcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(1-c:GetOwner())
end
function c101010096.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	c101010096[0]=0
	c101010096[1]=0
	Duel.Hint(HINT_SELECTMSG,tp,562)
	local rc=Duel.AnnounceAttribute(tp,1,0xffff)
	e:SetLabel(rc)
end
function c101010096.operation(e,tp,eg,ep,ev,re,r,rp)
	local at=e:GetLabel()
	c:SetHint(CHINT_ATTRIBUTE,at)
	c101010096[0],c101010096[1]=at,at
end
function c101010096.block(e,c)
	return c:IsAttribute(c101010096[e:GetHandlerPlayer()])
end
function c101010096.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsAttribute(c101010096[e:GetHandlerPlayer()]) and c:IsLocation(LOCATION_DECK+LOCATION_HAND)
end
