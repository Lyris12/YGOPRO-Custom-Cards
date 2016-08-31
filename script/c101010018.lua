--サイバー・ワイバーン
function c101010018.initial_effect(c)
--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1160)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c101010018.condition)
	c:RegisterEffect(e1)
	--Spell effect
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e4:SetRange(LOCATION_PZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetCountLimit(1)
	e4:SetValue(c101010018.value)
	c:RegisterEffect(e4)
	--Monster effect
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_TOHAND)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e0:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e0:SetRange(LOCATION_REMOVED)
	e0:SetCountLimit(1,101010018)
	e0:SetCondition(c101010018.spcon)
	e0:SetCost(c101010018.spcost)
	e0:SetTarget(c101010018.sptg)
	e0:SetOperation(c101010018.spop)
	c:RegisterEffect(e0)
end
function c101010018.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
	and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
end
function c101010018.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c101010018.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_RETURN)
end
function c101010018.filter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:GetOriginalLevel()<5
end
function c101010018.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and c101010018.filter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c101010018.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,e:GetHandler(),e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c101010018.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,1,e:GetHandler(),e,tp)
end
function c101010018.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
		e1:SetCode(EVENT_PHASE_START+PHASE_BATTLE)
		e1:SetOperation(c101010018.thop)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		tc:RegisterEffect(e1,true)
	end
end
function c101010018.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetOwner()==tp then
		Duel.SendtoHand(e:GetHandler(),Duel.GetTurnPlayer(),REASON_EFFECT+REASON_RETURN)
	else
		Duel.SendtoHand(e:GetHandler(),tp,REASON_EFFECT+REASON_RETURN)
	end
end
function c101010018.value(e,c)
	return c:IsSetCard(0x93) and c:IsReason(REASON_EFFECT)
end
