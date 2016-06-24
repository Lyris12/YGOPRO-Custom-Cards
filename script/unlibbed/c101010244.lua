--Sea Scout Dragon - Monsoon
function c101010228.initial_effect(c)
	--change name
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(101010201)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c101010228.spscon)
	e2:SetOperation(c101010228.spsop)
	c:RegisterEffect(e2)
	--fetch
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e0:SetCode(EVENT_DAMAGE_STEP_END)
	e0:SetCondition(c101010228.rtcon)
	e0:SetTarget(c101010228.rttg)
	e0:SetOperation(c101010228.rtop)
	c:RegisterEffect(e0)
	--material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return r==REASON_SYNCHRO end)
	e3:SetOperation(c101010228.matop)
	c:RegisterEffect(e3)
end
function c101010228.ffilter(c)
	return (c:IsType(TYPE_MONSTER) or (c:IsFaceup() and c:IsOnField())) and c:IsAbleToGraveAsCost()
end
function c101010228.spscon(e,c)
	if c==nil then return true end
	local mg=Duel.GetMatchingGroup(c101010228.ffilter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil)
	return mg:CheckWithSumEqual(Card.GetLevel,c:GetOriginalLevel(),1,99,nil)
end
function c101010228.spsop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(Card.IsAbleToDeckOrExtraAsCost,tp,LOCATION_MZONE+LOCATION_HAND,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local mat=mg:SelectWithSumEqual(tp,Card.GetLevel,c:GetOriginalLevel(),1,99,nil)
	Duel.SendtoGrave(mat,nil,2,REASON_COST)
end
function c101010228.rtcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsRelateToBattle()
end
function c101010228.filter(c,e)
	return c:IsSetCard(0x5cd) and c:IsAbleToHand()
end
function c101010228.rttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101010228.rtop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101010228.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c101010228.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e0:SetCode(EVENT_ATTACK_ANNOUNCE)
	e0:SetTarget(c101010228.sptg)
	e0:SetOperation(c101010228.spop)
	e0:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(e0)
	--actlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c101010228.aclimit)
	e1:SetCondition(c101010228.actcon)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(e1)
end
function c101010228.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c101010228.actcon(e)
	return (Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()) and e:GetHandler():GetBattleTarget()~=nil
end
function c101010228.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsAbleToRemove() end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c101010228.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end