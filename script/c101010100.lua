--created & coded by Lyris
--Clear Magician
function c101010100.initial_effect(c)
	--If this card is Normal or Special Summoned: Declare 1 Attribute, then target a number of Spell/Trap Card(s) your opponent controls, up to the number of other monsters on the field with that Attribute; destroy them, then, place a number of Spell Counters on this card, up to the number of cards destroyed by this effect.
	local ae1=Effect.CreateEffect(c)
	ae1:SetCategory(CATEGORY_DESTROY)
	ae1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	ae1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	ae1:SetCode(EVENT_SUMMON_SUCCESS)
	ae1:SetTarget(c101010100.destg)
	ae1:SetOperation(c101010100.desop)
	c:RegisterEffect(ae1)
	local ae2=ae1:Clone()
	ae2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(ae2)
	--atkup
	local ae3=Effect.CreateEffect(c)
	ae3:SetType(EFFECT_TYPE_SINGLE)
	ae3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	ae3:SetRange(LOCATION_MZONE)
	ae3:SetCode(EFFECT_UPDATE_ATTACK)
	ae3:SetCondition(c101010100.tpcon)
	ae3:SetValue(c101010100.attackup)
	c:RegisterEffect(ae3)
	--cannot summon
	local ae4=Effect.CreateEffect(c)
	ae4:SetType(EFFECT_TYPE_FIELD)
	ae4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	ae4:SetRange(LOCATION_MZONE)
	ae4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	ae4:SetTargetRange(1,0)
	ae4:SetCondition(c101010100.ntpcon)
	ae4:SetTarget(c101010100.splimit)
	c:RegisterEffect(ae4)
	local ae5=ae4:Clone()
	ae5:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(ae5)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	e1:SetCode(97811903)
	e1:SetCondition(c101010100.tpcon)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetTargetRange(0,1)
	e2:SetCondition(c101010100.ntpcon)
	c:RegisterEffect(e2)
	--cannot be material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UNRELEASABLE_SUM)
	e3:SetValue(1)
	e3:SetCondition(c101010100.ntpcon)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e5:SetValue(1)
	e5:SetCondition(c101010100.ntpcon)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e6)
	local e7=e5:Clone()
	e7:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e7)
end
function c101010100.tpcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(c:GetOwner())
end
function c101010100.ntpcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(1-c:GetOwner())
end
function c101010100.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c101010100.chkfilter(c)
	return c:IsFaceup() and c:IsAttribute(0xff)
end
function c101010100.filter(c,at)
	return c:IsFaceup() and c:IsAttribute(at)
end
function c101010100.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c101010100.desfilter(chkc) end
	if chk==0 then return Duel.GetMatchingGroupCount(c101010100.chkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,c)>0
		and Duel.IsExistingTarget(c101010100.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c101010100.chkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,c)
	local aat=0
	local tc=g:GetFirst()
	while tc do
		aat=bit.bor(aat,tc:GetAttribute())
		tc=g:GetNext()
	end
	Duel.Hint(HINT_SELECTMSG,tp,563)
	local at=Duel.AnnounceAttribute(tp,1,aat)
	local ct=Duel.GetMatchingGroupCount(c101010100.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,at)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local tg=Duel.SelectTarget(tp,c101010100.desfilter,tp,0,LOCATION_ONFIELD,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,tg:GetCount(),0,0)
end
function c101010100.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local ctr=Duel.Destroy(g,REASON_EFFECT)
	if ctr>0 and e:GetHandler():IsRelateToEffect(e) then
		Duel.BreakEffect()
		e:GetHandler():AddCounter(0x3001,ctr)
	end
end
function c101010100.attackup(e,c)
	return c:GetCounter(0x3001)*1000
end
function c101010100.splimit(e,c)
	return c:GetLevel()>e:GetHandler():GetCounter(0x3001)
end
